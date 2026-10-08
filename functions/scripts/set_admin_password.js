#!/usr/bin/env node
// ═════════════════════════════════════════════════════════════════════════════
// BUG-96 — create an admin account or set a new password, from YOUR computer.
//
// The old admin build created admin@bayanatz.com with a password written in
// the public main.dart.js, so that password must be treated as leaked.
// Run this once to rotate it (and to add more admins later):
//
//   cd website_app/functions
//   gcloud auth application-default login          (once, as a project owner)
//   node scripts/set_admin_password.js admin@bayanatz.com 'New-Strong-Pass1' "Bayanatz Admin" super_admin
//
// Arguments: <email> <password> [name] [role]. The password is stored as a
// salted scrypt hash (same format the adminLogin Cloud Function checks).
// ═════════════════════════════════════════════════════════════════════════════

const crypto = require("crypto");
const admin = require("firebase-admin");

admin.initializeApp({projectId: "web-app-admin-33b9a"});

async function main() {
  const [emailArg, password, name, role] = process.argv.slice(2);
  const email = (emailArg || "").trim().toLowerCase();
  if (!/^[^\s@]+@[^\s@]+\.[^\s@]{2,}$/.test(email) || !password) {
    console.error("Usage: node scripts/set_admin_password.js <email> <password> [name] [role]");
    process.exit(1);
  }
  if (password.length < 8 || !/[A-Za-z]/.test(password) || !/\d/.test(password)) {
    console.error("Password must be at least 8 characters with letters and digits.");
    process.exit(1);
  }
  const salt = crypto.randomBytes(16).toString("base64url");
  const ref = admin.firestore().collection("admin_accounts").doc(email);
  const exists = (await ref.get()).exists;
  await ref.set({
    email,
    ...(name ? {name} : exists ? {} : {name: "Bayanatz Admin"}),
    ...(role ? {role} : exists ? {} : {role: "admin"}),
    passwordSalt: salt,
    passwordHash: crypto.scryptSync(password, salt, 64).toString("hex"),
    passwordAlgo: "scrypt",
    isActive: true,
    failedLogins: 0,
    lockedUntil: null,
    resetTokenHash: null,
    resetExpiresAt: null,
    passwordChangedAt: admin.firestore.FieldValue.serverTimestamp(),
    ...(exists ? {} : {createdAt: admin.firestore.FieldValue.serverTimestamp()}),
  }, {merge: true});
  console.log(`${exists ? "Updated" : "Created"} admin_accounts/${email}`);
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});
