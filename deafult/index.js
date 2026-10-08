// ═════════════════════════════════════════════════════════════════════════════
// Bayanatz — Cloud Functions (public Contact form)
//
// BUG-51 / BUG-14: the browser used to call verify.twilio.com directly with a
// Basic-auth header built from constants compiled into main.dart.js, and it
// decided on its own whether the code was "approved". Anyone could copy the
// Twilio credentials or skip the OTP and write straight to Firestore.
//
// Now:
//   • sendOTP / verifyOTP run here; Twilio credentials are Secret Manager
//     secrets and never reach the browser.
//   • verifyOTP returns a one-time `verificationToken` (stored in the
//     `otpVerifications` collection, readable by nobody but this code).
//   • submitContactForm checks that token (exists, same phone, < 15 min old,
//     not used yet), writes the submission with the Admin SDK and sends both
//     e-mails. Firestore rules no longer let the public create
//     contactSubmissions directly, so the OTP can't be skipped.
//   • sendContactEmail / sendContactConfirmation are no longer exported: they
//     accepted any `toEmail` from any caller (an open mail relay).
//
// After deploying, ROTATE the Twilio Auth Token / API key that was shipped in
// the old website build — it is public.
// ═════════════════════════════════════════════════════════════════════════════

const {setGlobalOptions} = require("firebase-functions");
const {onCall, HttpsError} = require("firebase-functions/v2/https");
const {defineSecret} = require("firebase-functions/params");
const admin = require("firebase-admin");
const crypto = require("crypto");
const sgMail = require("@sendgrid/mail");

admin.initializeApp();
setGlobalOptions({maxInstances: 10});

// ── Secrets ─────────────────────────────────────────────
const SENDGRID_API_KEY   = defineSecret("SENDGRID_API_KEY");
const TWILIO_ACCOUNT_SID = defineSecret("TWILIO_ACCOUNT_SID");
const TWILIO_AUTH_TOKEN  = defineSecret("TWILIO_AUTH_TOKEN");
const TWILIO_VERIFY_SID  = defineSecret("TWILIO_VERIFY_SERVICE_SID");

// ── Template IDs ─────────────────────────────────────────
const TEMPLATE_USER    = "d-983dbdd1b0564ddf8b4dfacb3007e564";
const TEMPLATE_COMPANY = "d-4ae8d76149bf46e29a429fc442c4c84d";

// ── Sender / company inbox (fixed on the server) ─────────
const SENDER_EMAIL  = "m.handousa@bayanatz.com";
const COMPANY_EMAIL = "m.handousa@bayanatz.com";

const TOKEN_TTL_MS = 15 * 60 * 1000;
const E164 = /^\+[1-9]\d{6,14}$/;
const EMAIL = /^[^\s@]+@[^\s@]+\.[^\s@]{2,}$/;

function twilioClient() {
  return require("twilio")(TWILIO_ACCOUNT_SID.value(), TWILIO_AUTH_TOKEN.value());
}

function str(v, max = 5000) {
  return (typeof v === "string" ? v : "").trim().slice(0, max);
}

// ═════════════════════════════════════════════════════════
// 1) sendOTP  –  Twilio Verify → send verification code
// ═════════════════════════════════════════════════════════
exports.sendOTP = onCall(
    {secrets: [TWILIO_ACCOUNT_SID, TWILIO_AUTH_TOKEN, TWILIO_VERIFY_SID]},
    async (request) => {
      const to = str(request.data && request.data.to, 20);
      const channel = str(request.data && request.data.channel, 10) || "sms";
      const locale = str(request.data && request.data.locale, 10) || "en";

      // BUG-102: "+20 0000000000" was accepted and Twilio's failure surfaced as
      // a raw HTTP 500 "INTERNAL". The number is checked here too (all-zero /
      // repeated digits, Egyptian mobile format) and EVERY failure is mapped
      // to an HttpsError with a readable code the site translates (EN/AR).
      if (!E164.test(to) || !isPlausiblePhone(to)) {
        throw new HttpsError("invalid-argument", "invalid-phone");
      }
      if (!["sms", "whatsapp", "call"].includes(channel)) {
        throw new HttpsError("invalid-argument", "Unsupported channel.");
      }

      try {
        const verifySid = TWILIO_VERIFY_SID.value();
        if (!verifySid || !TWILIO_ACCOUNT_SID.value() || !TWILIO_AUTH_TOKEN.value()) {
          console.error("[sendOTP] Twilio secrets are not configured");
          throw new HttpsError("failed-precondition", "otp-not-configured");
        }
        const verification = await twilioClient().verify.v2
            .services(verifySid)
            .verifications.create({to, channel, locale: locale === "ar" ? "ar" : "en"});
        return {success: true, status: verification.status};
      } catch (error) {
        if (error instanceof HttpsError) throw error;
        console.error("[sendOTP] Twilio error:", error.status, error.code, error.message);
        // 60200 = invalid parameter, 60205 = landline / not SMS-capable,
        // 21211/21614 = invalid number.
        if ([60200, 60205, 21211, 21614].includes(error.code) || error.status === 400) {
          throw new HttpsError("invalid-argument", "invalid-phone");
        }
        if (error.code === 60203 || error.status === 429) {
          throw new HttpsError("resource-exhausted", "too-many-attempts");
        }
        throw new HttpsError("unavailable", "otp-send-failed");
      }
    },
);

/** BUG-102: rejects obviously fake numbers (+20 0000000000, 1111111…). */
function isPlausiblePhone(e164) {
  const digits = e164.replace(/\D/g, "");
  if (/^(\d)\1+$/.test(digits.slice(-9))) return false; // all the same digit
  if (e164.startsWith("+20")) {
    // Egypt mobile: +20 1[0125] xxxxxxxx (10 digits after the country code)
    return /^\+201[0125]\d{8}$/.test(e164);
  }
  if (e164.startsWith("+966")) return /^\+9665\d{8}$/.test(e164); // KSA mobile
  return true;
}

// ═════════════════════════════════════════════════════════
// 2) verifyOTP  –  Twilio Verify → check code, issue one-time token
// ═════════════════════════════════════════════════════════
exports.verifyOTP = onCall(
    {secrets: [TWILIO_ACCOUNT_SID, TWILIO_AUTH_TOKEN, TWILIO_VERIFY_SID]},
    async (request) => {
      const to = str(request.data && request.data.to, 20);
      const code = str(request.data && request.data.code, 10);

      if (!E164.test(to) || !/^\d{4,10}$/.test(code)) {
        throw new HttpsError("invalid-argument", "Missing phone number or code.");
      }

      let status = "pending";
      try {
        const check = await twilioClient().verify.v2
            .services(TWILIO_VERIFY_SID.value())
            .verificationChecks.create({to, code});
        status = check.status;
      } catch (error) {
        // Twilio returns 404 when the verification expired / was already used.
        console.error("[verifyOTP] Twilio error:", error.status, error.message);
        return {success: false, status: "expired"};
      }

      if (status !== "approved") return {success: false, status};

      const token = crypto.randomBytes(24).toString("hex");
      await admin.firestore().collection("otpVerifications").doc(token).set({
        phone: to,
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
        used: false,
      });
      return {success: true, status, verificationToken: token};
    },
);

// ═════════════════════════════════════════════════════════
// 3) submitContactForm  –  token check → Firestore → e-mails
// ═════════════════════════════════════════════════════════
exports.submitContactForm = onCall(
    {secrets: [SENDGRID_API_KEY]},
    async (request) => {
      const d = request.data || {};
      const token = str(d.verificationToken, 100);
      const s = d.submission || {};

      const submission = {
        firstName:         str(s.firstName, 100),
        lastName:          str(s.lastName, 100),
        email:             str(s.email, 200),
        countryCode:       str(s.countryCode, 8),
        phoneNumber:       str(s.phoneNumber, 20),
        preferredLanguage: str(s.preferredLanguage, 50) || "en",
        location:          str(s.location, 100),
        entityName:        str(s.entityName, 200),
        entityType:        str(s.entityType, 100),
        entitySize:        str(s.entitySize, 100),
        subject:           str(s.subject, 300),
        message:           str(s.message, 5000),
        note:              "",
        status:            "New",
        submissionDate:    new Date().toISOString(),
      };
      submission.fullName = `${submission.firstName} ${submission.lastName}`.trim();

      const missing = ["firstName", "lastName", "email", "phoneNumber", "subject", "message"]
          .filter((k) => !submission[k]);
      if (missing.length) {
        throw new HttpsError("invalid-argument", `Missing required fields: ${missing.join(", ")}`);
      }
      if (!EMAIL.test(submission.email)) {
        throw new HttpsError("invalid-argument", "Please enter a valid email address.");
      }
      if (!token) throw new HttpsError("permission-denied", "Phone number not verified.");

      const db = admin.firestore();
      const tokenRef = db.collection("otpVerifications").doc(token);
      const docRef = db.collection("contactSubmissions").doc();

      await db.runTransaction(async (tx) => {
        const snap = await tx.get(tokenRef);
        if (!snap.exists) throw new HttpsError("permission-denied", "Phone number not verified.");
        const t = snap.data();
        const created = t.createdAt ? t.createdAt.toMillis() : 0;
        if (t.used || Date.now() - created > TOKEN_TTL_MS) {
          throw new HttpsError("permission-denied", "Verification expired. Please request a new code.");
        }
        const localDigits = submission.phoneNumber.replace(/\D/g, "").replace(/^0+/, "");
        if (!t.phone.endsWith(localDigits)) {
          throw new HttpsError("permission-denied", "Verified phone number doesn't match.");
        }
        tx.update(tokenRef, {used: true, usedAt: admin.firestore.FieldValue.serverTimestamp()});
        tx.set(docRef, {...submission, id: docRef.id, verifiedPhone: t.phone});
      });

      // E-mails are best effort: the submission is already saved.
      sgMail.setApiKey(SENDGRID_API_KEY.value());
      const isArabic = submission.preferredLanguage === "ar";
      const common = {
        location:    submission.location,
        entity_name: submission.entityName,
        entity_type: submission.entityType,
        entity_size: submission.entitySize,
        subject:     submission.subject,
        message:     submission.message,
      };
      try {
        await sgMail.send({
          to:      COMPANY_EMAIL,
          from:    SENDER_EMAIL,
          replyTo: submission.email,
          subject: `New Contact Form Submission: ${submission.subject}`,
          templateId: TEMPLATE_COMPANY,
          dynamic_template_data: {
            ...common,
            first_name: submission.firstName,
            last_name:  submission.lastName,
            email:      submission.email,
            phone:      `${submission.countryCode}${submission.phoneNumber}`,
          },
        });
      } catch (error) {
        console.error("[submitContactForm] company e-mail failed:", error.message);
      }
      try {
        await sgMail.send({
          to:      submission.email,
          from:    SENDER_EMAIL,
          subject: isArabic ?
            `تم استلام رسالتك: ${submission.subject}` :
            `We received your message: ${submission.subject}`,
          templateId: TEMPLATE_USER,
          dynamic_template_data: {
            ...common,
            client_name:   submission.fullName,
            show_en:       submission.preferredLanguage !== "ar",
            show_ar:       submission.preferredLanguage !== "en",
            ar_salutation: "السيد",
          },
        });
      } catch (error) {
        console.error("[submitContactForm] confirmation e-mail failed:", error.message);
      }

      return {success: true, id: docRef.id};
    },
);

// ═════════════════════════════════════════════════════════════════════════════
// ADMIN SIGN-IN  (BUG-01 / BUG-96 / BUG-97)
//
// The admin used to download admin_accounts/<email> (password hash + salt) in
// the browser and compare the hash there; the session was a hash kept in
// localStorage and a "[one-time setup]" routine shipped a default password.
// Now:
//   • adminLogin checks the password HERE (Admin SDK, rules don't apply) and
//     returns a Firebase CUSTOM TOKEN with the claim  admin: true.  The admin
//     app signs in with it (FirebaseAuth.signInWithCustomToken), so every
//     Firestore / Storage request carries request.auth.token.admin and the
//     rules can finally tell an admin from a visitor.
//   • admin_accounts is readable by NOBODY from the browser.
//   • 5 wrong passwords lock the account for 15 minutes.
//   • old sha256 hashes are upgraded to scrypt on the next successful login.
//   • adminRequestPasswordReset / adminResetPassword = "Forgot Password?".
//
// One-time setup: the functions' service account needs the IAM role
// "Service Account Token Creator" (see QA_FIXES_2026-10-07.md).
// ═════════════════════════════════════════════════════════════════════════════

const ADMIN_SITE_URL = "https://dashboard-app-33b.web.app";
const MAX_FAILED_LOGINS = 5;
const LOCK_MS = 15 * 60 * 1000;
const RESET_TTL_MS = 60 * 60 * 1000;

function adminDocRef(email) {
  return admin.firestore().collection("admin_accounts").doc(email);
}

function adminUid(email) {
  return "admin_" + crypto.createHash("sha256").update(email).digest("hex").slice(0, 28);
}

function legacyHash(password, salt) {
  return crypto.createHash("sha256").update(`${salt}:${password}`).digest("hex");
}

function scryptHash(password, salt) {
  return crypto.scryptSync(password, salt, 64).toString("hex");
}

function safeEqual(a, b) {
  const ba = Buffer.from(String(a || ""), "utf8");
  const bb = Buffer.from(String(b || ""), "utf8");
  return ba.length === bb.length && crypto.timingSafeEqual(ba, bb);
}

function checkPassword(data, password) {
  const salt = data.passwordSalt || "";
  if (!data.passwordHash) return false;
  if (data.passwordAlgo === "scrypt") return safeEqual(scryptHash(password, salt), data.passwordHash);
  return safeEqual(legacyHash(password, salt), data.passwordHash);
}

function newPasswordFields(password) {
  const salt = crypto.randomBytes(16).toString("base64url");
  return {passwordSalt: salt, passwordHash: scryptHash(password, salt), passwordAlgo: "scrypt"};
}

function passwordPolicyError(p) {
  if (typeof p !== "string" || p.length < 8) return "weak-password";
  if (!/[A-Za-z]/.test(p) || !/\d/.test(p)) return "weak-password";
  return null;
}

exports.adminLogin = onCall(async (request) => {
  const email = str(request.data && request.data.email, 200).toLowerCase();
  const password = typeof (request.data && request.data.password) === "string" ?
    request.data.password.slice(0, 200) : "";
  // One generic error for "no such account" and "wrong password" so the
  // login can't be used to find out which e-mails are admins.
  const bad = () => new HttpsError("unauthenticated", "invalid-credentials");
  if (!EMAIL.test(email) || !password) throw bad();

  const ref = adminDocRef(email);
  const snap = await ref.get();
  if (!snap.exists) throw bad();
  const data = snap.data();

  const lockedUntil = data.lockedUntil ? data.lockedUntil.toMillis() : 0;
  if (lockedUntil > Date.now()) throw new HttpsError("resource-exhausted", "locked");

  if (!checkPassword(data, password)) {
    const failed = (data.failedLogins || 0) + 1;
    await ref.update(failed >= MAX_FAILED_LOGINS ? {
      failedLogins: 0,
      lockedUntil: admin.firestore.Timestamp.fromMillis(Date.now() + LOCK_MS),
    } : {failedLogins: failed});
    throw bad();
  }
  if (data.isActive === false) throw new HttpsError("permission-denied", "inactive");

  const update = {
    failedLogins: 0,
    lockedUntil: null,
    lastLoginAt: admin.firestore.FieldValue.serverTimestamp(),
  };
  if (data.passwordAlgo !== "scrypt") Object.assign(update, newPasswordFields(password));
  await ref.update(update);

  const role = data.role || "admin";
  const token = await admin.auth().createCustomToken(adminUid(email), {admin: true, role, email});
  return {token, email, name: data.name || "", role};
});

exports.adminRequestPasswordReset = onCall({secrets: [SENDGRID_API_KEY]}, async (request) => {
  const email = str(request.data && request.data.email, 200).toLowerCase();
  const isArabic = str(request.data && request.data.locale, 5) === "ar";
  // Always the same answer, whether the account exists or not.
  const done = {success: true};
  if (!EMAIL.test(email)) return done;

  const ref = adminDocRef(email);
  const snap = await ref.get();
  if (!snap.exists || snap.data().isActive === false) return done;
  const last = snap.data().resetRequestedAt ? snap.data().resetRequestedAt.toMillis() : 0;
  if (Date.now() - last < 60 * 1000) return done; // 1 mail per minute

  const token = crypto.randomBytes(32).toString("hex");
  await ref.update({
    resetTokenHash: crypto.createHash("sha256").update(token).digest("hex"),
    resetExpiresAt: admin.firestore.Timestamp.fromMillis(Date.now() + RESET_TTL_MS),
    resetRequestedAt: admin.firestore.FieldValue.serverTimestamp(),
  });

  const link = `${ADMIN_SITE_URL}/?reset=${token}&email=${encodeURIComponent(email)}`;
  try {
    sgMail.setApiKey(SENDGRID_API_KEY.value());
    await sgMail.send({
      to: email,
      from: SENDER_EMAIL,
      subject: isArabic ? "إعادة تعيين كلمة مرور لوحة تحكم بيانات" : "Reset your Bayanatz Admin password",
      text: isArabic ?
        `لإعادة تعيين كلمة المرور افتح الرابط التالي (صالح لمدة ساعة):\n${link}\n\nإذا لم تطلب ذلك تجاهل هذه الرسالة.` :
        `To reset your password open this link (valid for 1 hour):\n${link}\n\nIf you didn't ask for this, ignore this e-mail.`,
    });
  } catch (error) {
    console.error("[adminRequestPasswordReset] e-mail failed:", error.message);
  }
  return done;
});

exports.adminResetPassword = onCall(async (request) => {
  const d = request.data || {};
  const email = str(d.email, 200).toLowerCase();
  const token = str(d.token, 100);
  const password = typeof d.password === "string" ? d.password.slice(0, 200) : "";
  const invalid = () => new HttpsError("permission-denied", "invalid-reset-link");
  if (!EMAIL.test(email) || !/^[a-f0-9]{64}$/.test(token)) throw invalid();
  const weak = passwordPolicyError(password);
  if (weak) throw new HttpsError("invalid-argument", weak);

  const ref = adminDocRef(email);
  const snap = await ref.get();
  if (!snap.exists) throw invalid();
  const data = snap.data();
  const expires = data.resetExpiresAt ? data.resetExpiresAt.toMillis() : 0;
  const hash = crypto.createHash("sha256").update(token).digest("hex");
  if (!data.resetTokenHash || expires < Date.now() || !safeEqual(hash, data.resetTokenHash)) {
    throw invalid();
  }

  await ref.update({
    ...newPasswordFields(password),
    resetTokenHash: null,
    resetExpiresAt: null,
    failedLogins: 0,
    lockedUntil: null,
    passwordChangedAt: admin.firestore.FieldValue.serverTimestamp(),
  });
  // Sign the old sessions out.
  try {
    await admin.auth().revokeRefreshTokens(adminUid(email));
  } catch (_) {/* user not created yet */}
  return {success: true};
});
