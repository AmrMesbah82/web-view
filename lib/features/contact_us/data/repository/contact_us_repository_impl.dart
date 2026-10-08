// ******************* FILE INFO *******************
// File Name: contact_repo_impl.dart
// Created by: Amr Mesbah
// UPDATED: SendGrid email calls added after Firestore save

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';


import '../../domain/base_repository/contact_us_repo.dart';
import '../models/contact_us_model.dart';

class ContactRepoImpl implements ContactRepo {
  // Same collection the admin app reads ('contactSubmissions' — was 'contact_submissions')
  final _col      = FirebaseFirestore.instance.collection('contactSubmissions');

  // ── Submit (public website) ────────────────────────────────────────────────

  @override
  Future<void> submitContact(
    ContactSubmission submission, {
    required String verificationToken,
  }) async {
    // BUG-51: the submission is written by the `submitContactForm` Cloud
    // Function, which first checks the OTP token issued by `verifyOTP`, then
    // saves to 'contactSubmissions' and sends both e-mails server-side.
    // Firestore rules no longer allow the public to create submissions
    // directly, so the phone verification can't be skipped.
    try {
      await FirebaseFunctions.instance.httpsCallable('submitContactForm').call({
        'verificationToken': verificationToken,
        'submission': submission.toMap(),
      });
    } on FirebaseFunctionsException catch (e) {
      throw Exception(e.message ?? 'Your message could not be sent.');
    }
  }

  // ── Fetch all (admin) ──────────────────────────────────────────────────────

  @override
  Future<List<ContactSubmission>> fetchAll() async {
    final snap = await _col
        .orderBy('submissionDate', descending: true)
        .get();
    return snap.docs
        .map((d) => ContactSubmission.fromMap(d.id, d.data()))
        .toList();
  }

  // ── Update (admin: status / note) ─────────────────────────────────────────

  @override
  Future<void> updateSubmission(ContactSubmission submission) async {
    await _col.doc(submission.id).update({
      'status': submission.status,
      'note':   submission.note,
    });
  }
}