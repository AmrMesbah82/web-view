#!/usr/bin/env node
// ═════════════════════════════════════════════════════════════════════════════
// BUG-20 — remove QA / junk test data from the LIVE Firestore database.
//
// SAFE BY DEFAULT: without --delete it only LISTS what it would remove.
//
//   cd website_app/functions
//   gcloud auth application-default login        (once, as a project owner)
//   node scripts/cleanup_test_data.js             → dry run (list only)
//   node scripts/cleanup_test_data.js --delete    → really delete
//
// What counts as test data:
//   • jobListings whose English title is empty, starts with "QA TEST"/"test",
//     or is keyboard junk (asdasd, qqqqq, cxvxcv…) — with their applications
//   • departments with such names
//   • contactSubmissions from *@example.com addresses or "QA TEST" subjects
// Check the dry-run list before running with --delete. Deleting is final.
// ═════════════════════════════════════════════════════════════════════════════

const admin = require("firebase-admin");

admin.initializeApp({projectId: "web-app-admin-33b9a"});
const db = admin.firestore();
const DELETE = process.argv.includes("--delete");

// Values are stored as version arrays by the admin app — take the last one.
const cur = (v) => (Array.isArray(v) ? v[v.length - 1] : v);
const str = (v) => (typeof cur(v) === "string" ? cur(v).trim() : "");

const JUNK = /^(asd|sad|qwe|zxc|cxv|dsf|fds|q{3,}|x{3,}|a{3,}|test\b|qa test)/i;
const isJunk = (s) => s === "" || JUNK.test(s);

async function scan(collection, pick, extra = () => false) {
  const snap = await db.collection(collection).get();
  return snap.docs.filter((d) => {
    const data = d.data();
    return isJunk(pick(data)) || extra(data);
  });
}

(async () => {
  const jobs = await scan("jobListings",
      (d) => str(d.Title_En) || str(d.title && d.title.en));
  const depts = await scan("departments",
      (d) => str(d.Name_En) || str(d.nameEn) || str(d.name_en));
  const contacts = await scan("contactSubmissions",
      (d) => (str(d.subject).toLowerCase().startsWith("qa test") ? "" : "keep"),
      (d) => /@example\.com$/i.test(str(d.email)));

  const report = (name, docs, label) => {
    console.log(`\n${name}: ${docs.length}`);
    docs.forEach((d) => console.log(`  - ${d.id}  ${label(d.data())}`));
  };
  report("Jobs", jobs, (d) => JSON.stringify(str(d.Title_En) || "(no title)"));
  report("Departments", depts, (d) => JSON.stringify(str(d.Name_En) || str(d.nameEn)));
  report("Contact submissions", contacts, (d) => `${str(d.email)}  ${str(d.subject)}`);

  if (!DELETE) {
    console.log("\nDry run only. Re-run with --delete to remove the items above.");
    return;
  }
  for (const d of [...jobs, ...depts, ...contacts]) {
    await db.recursiveDelete(d.ref); // also removes jobListings/*/applications
  }
  console.log("\nDeleted.");
})().catch((e) => {
  console.error(e);
  process.exit(1);
});
