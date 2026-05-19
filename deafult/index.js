const {setGlobalOptions} = require("firebase-functions");
const {onCall} = require("firebase-functions/v2/https");
const {defineSecret} = require("firebase-functions/params");
const sgMail = require("@sendgrid/mail");

setGlobalOptions({maxInstances: 10});

// ── Secrets ─────────────────────────────────────────────
const SENDGRID_API_KEY   = defineSecret("SENDGRID_API_KEY");
const TWILIO_ACCOUNT_SID = defineSecret("TWILIO_ACCOUNT_SID");
const TWILIO_AUTH_TOKEN  = defineSecret("TWILIO_AUTH_TOKEN");
const TWILIO_VERIFY_SID  = defineSecret("TWILIO_VERIFY_SERVICE_SID");

// ── Template IDs ─────────────────────────────────────────
const TEMPLATE_USER    = "d-983dbdd1b0564ddf8b4dfacb3007e564";
const TEMPLATE_COMPANY = "d-4ae8d76149bf46e29a429fc442c4c84d";

// ── Sender email ─────────────────────────────────────────
const SENDER_EMAIL = "m.handousa@bayanatz.com";

// ═════════════════════════════════════════════════════════
// 1) sendContactEmail  –  notify company of new submission
// ═════════════════════════════════════════════════════════
exports.sendContactEmail = onCall(
    {secrets: [SENDGRID_API_KEY]},
    async (request) => {
      const {
        toEmail,
        submitterName,
        submitterEmail,
        submitterPhone,
        subject,
        message,
        isArabic,
        preferredLanguage,
        location,
        entityName,
        entityType,
        entitySize,
      } = request.data;

      console.log("📧 [sendContactEmail] Called with:", {
        toEmail, submitterName, submitterEmail, submitterPhone,
        subject, isArabic, preferredLanguage,
        location, entityName, entityType, entitySize,
      });

      if (!toEmail || !submitterName || !submitterEmail || !subject || !message) {
        console.error("❌ [sendContactEmail] Missing required fields");
        throw new Error("Missing required fields");
      }

      sgMail.setApiKey(SENDGRID_API_KEY.value());

      const nameParts = submitterName.trim().split(" ");
      const firstName = nameParts[0] || "";
      const lastName  = nameParts.slice(1).join(" ") || "";

      // Company email is always English only — no language gates needed
      try {
        await sgMail.send({
          to:      toEmail,
          from:    SENDER_EMAIL,
          replyTo: submitterEmail,
          subject: `New Contact Form Submission: ${subject}`,
          templateId: TEMPLATE_COMPANY,
          dynamic_template_data: {
            first_name:  firstName,
            last_name:   lastName,
            email:       submitterEmail,
            phone:       submitterPhone,
            location:    location   || "",
            entity_name: entityName || "",
            entity_type: entityType || "",
            entity_size: entitySize || "",
            subject:     subject,
            message:     message,
          },
        });

        console.log("✅ [sendContactEmail] Company email sent to:", toEmail);
        return {success: true};
      } catch (error) {
        console.error("❌ [sendContactEmail] SendGrid error:", error);
        if (error.response) {
          console.error("❌ SendGrid response body:", error.response.body);
        }
        throw new Error("Failed to send email: " + error.message);
      }
    },
);

// ═════════════════════════════════════════════════════════
// 2) sendContactConfirmation  –  thank-you receipt to submitter
// ═════════════════════════════════════════════════════════
exports.sendContactConfirmation = onCall(
    {secrets: [SENDGRID_API_KEY]},
    async (request) => {
      const {
        toEmail,
        submitterName,
        subject,
        message,
        isArabic,
        preferredLanguage,
        location,
        entityName,
        entityType,
        entitySize,
      } = request.data;

      console.log("📧 [sendContactConfirmation] Called with:", {
        toEmail, submitterName, subject, isArabic, preferredLanguage,
        location, entityName, entityType, entitySize,
      });

      if (!toEmail || !submitterName || !subject || !message) {
        console.error("❌ [sendContactConfirmation] Missing required fields");
        throw new Error("Missing required fields");
      }

      sgMail.setApiKey(SENDGRID_API_KEY.value());

      // ── Language gates ────────────────────────────────────────────────
      // 'ar'  → show AR section only  (show_en=false, show_ar=true)
      // 'en'  → show EN section only  (show_en=true,  show_ar=false)
      // other → show BOTH sections    (show_en=true,  show_ar=true)
      const showEn = preferredLanguage !== "ar";
      const showAr = preferredLanguage !== "en";

      console.log(`   preferredLanguage="${preferredLanguage}" → show_en=${showEn} show_ar=${showAr}`);

      try {
        await sgMail.send({
          to:      toEmail,
          from:    SENDER_EMAIL,
          subject: isArabic
              ? `تم استلام رسالتك: ${subject}`
              : `We received your message: ${subject}`,
          templateId: TEMPLATE_USER,
          dynamic_template_data: {
            client_name:   submitterName,
            subject:       subject,
            message:       message,
            show_en:       showEn,
            show_ar:       showAr,
            ar_salutation: "السيد",
            location:      location   || "",
            entity_name:   entityName || "",
            entity_type:   entityType || "",
            entity_size:   entitySize || "",
          },
        });

        console.log("✅ [sendContactConfirmation] Confirmation sent to:", toEmail, "| show_en:", showEn, "| show_ar:", showAr);
        return {success: true};
      } catch (error) {
        console.error("❌ [sendContactConfirmation] SendGrid error:", error);
        if (error.response) {
          console.error("❌ SendGrid response body:", error.response.body);
        }
        throw new Error("Failed to send confirmation: " + error.message);
      }
    },
);

// ═════════════════════════════════════════════════════════
// 3) sendOTP  –  Twilio Verify → send verification code
// ═════════════════════════════════════════════════════════
exports.sendOTP = onCall(
    {secrets: [TWILIO_ACCOUNT_SID, TWILIO_AUTH_TOKEN, TWILIO_VERIFY_SID]},
    async (request) => {
      const {to, channel, locale} = request.data;

      console.log("📞 [sendOTP] Called with:", {to, channel, locale});

      if (!to || !channel) {
        throw new Error("Missing required fields: to, channel");
      }

      const client = require("twilio")(
          TWILIO_ACCOUNT_SID.value(),
          TWILIO_AUTH_TOKEN.value(),
      );

      try {
        const verification = await client.verify.v2
            .services(TWILIO_VERIFY_SID.value())
            .verifications.create({
              to,
              channel,
              locale: locale || "en",
            });

        console.log("✅ [sendOTP] Verification SID:", verification.sid);
        console.log("✅ [sendOTP] Status:", verification.status);
        return {success: true, status: verification.status};
      } catch (error) {
        console.error("❌ [sendOTP] Error:", error.message);
        throw new Error("Failed to send OTP: " + error.message);
      }
    },
);

// ═════════════════════════════════════════════════════════
// 4) verifyOTP  –  Twilio Verify → check verification code
// ═════════════════════════════════════════════════════════
exports.verifyOTP = onCall(
    {secrets: [TWILIO_ACCOUNT_SID, TWILIO_AUTH_TOKEN, TWILIO_VERIFY_SID]},
    async (request) => {
      const {to, code} = request.data;

      console.log("🔍 [verifyOTP] Called with:", {to, code});

      if (!to || !code) {
        throw new Error("Missing required fields: to, code");
      }

      const client = require("twilio")(
          TWILIO_ACCOUNT_SID.value(),
          TWILIO_AUTH_TOKEN.value(),
      );

      try {
        const check = await client.verify.v2
            .services(TWILIO_VERIFY_SID.value())
            .verificationChecks.create({to, code});

        console.log("🔍 [verifyOTP] Status:", check.status);
        return {
          success: check.status === "approved",
          status:  check.status,
        };
      } catch (error) {
        console.error("❌ [verifyOTP] Error:", error.message);
        throw new Error("Failed to verify OTP: " + error.message);
      }
    },
);