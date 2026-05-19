// ******************* FILE INFO *******************
// File Name: contact_repo_impl.dart
// Created by: Amr Mesbah
// UPDATED: SendGrid email calls added after Firestore save

import 'package:cloud_firestore/cloud_firestore.dart';


import '../../domain/repo/contact_us_repo.dart';
import '../../domain/repo/sendgrid_repository.dart';
import '../model/contact_us_model.dart';

class ContactRepoImpl implements ContactRepo {
  final _col      = FirebaseFirestore.instance.collection('contact_submissions');
  final _sendGrid = SendGridRepository();

  // ── Submit (public website) ────────────────────────────────────────────────

  @override
  Future<void> submitContact(ContactSubmission submission) async {
    // 1️⃣ Save to Firestore
    final doc = _col.doc();
    await doc.set(submission.copyWith(id: doc.id).toMap());
    print('✅ [ContactRepo] Saved to Firestore: ${doc.id}');

    // 2️⃣ Send company notification email
    try {
      await _sendGrid.sendContactNotification(
        toEmail:           'm.handousa@bayanatz.com',
        submitterName:     submission.fullName,
        submitterEmail:    submission.email,
        submitterPhone:    '${submission.countryCode}${submission.phoneNumber}',
        subject:           submission.subject,
        message:           submission.message,
        isArabic:          submission.preferredLanguage == 'ar',
        preferredLanguage: submission.preferredLanguage,
        location:          submission.location,
        entityName:        submission.entityName,
        entityType:        submission.entityType,
        entitySize:        submission.entitySize,
      );
      print('✅ [ContactRepo] Company notification sent');
    } catch (e) {
      print('🔴 [ContactRepo] Company notification failed: $e');
    }

    // 3️⃣ Send confirmation email to submitter
    try {
      await _sendGrid.sendContactConfirmation(
        toEmail:           submission.email,
        submitterName:     submission.fullName,
        subject:           submission.subject,
        message:           submission.message,
        isArabic:          submission.preferredLanguage == 'ar',
        preferredLanguage: submission.preferredLanguage,
        location:          submission.location,
        entityName:        submission.entityName,
        entityType:        submission.entityType,
        entitySize:        submission.entitySize,
      );
      // dsfasd
      print('🔴 DEBUG sending confirmation → preferredLanguage: ${submission.preferredLanguage} | isArabic: ${submission.preferredLanguage == 'ar'}');

      print('✅ [ContactRepo] Confirmation email sent to: ${submission.email}');
    } catch (e) {
      print('🔴 [ContactRepo] Confirmation email failed: $e');
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