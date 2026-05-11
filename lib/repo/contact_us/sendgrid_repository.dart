// ******************* FILE INFO *******************
// File Name: sendgrid_repository.dart
// Created by: Amr Mesbah
// UPDATED: location, entityName, entityType, entitySize added to both calls

import 'package:cloud_functions/cloud_functions.dart';

class SendGridRepository {

  // ── Company notification ───────────────────────────────────────────────────

  Future<void> sendContactNotification({
    required String toEmail,
    required String submitterName,
    required String submitterEmail,
    required String submitterPhone,
    required String subject,
    required String message,
    required bool   isArabic,
    required String preferredLanguage,
    required String location,
    required String entityName,
    required String entityType,
    required String entitySize,
  }) async {
    print('📧 [SendGridRepo] sendContactNotification → lang: $preferredLanguage');
    try {
      final callable = FirebaseFunctions.instance.httpsCallable('sendContactEmail');
      final result   = await callable.call({
        'toEmail':           toEmail,
        'submitterName':     submitterName,
        'submitterEmail':    submitterEmail,
        'submitterPhone':    submitterPhone,
        'subject':           subject,
        'message':           message,
        'isArabic':          isArabic,
        'preferredLanguage': preferredLanguage,
        'location':          location,
        'entityName':        entityName,
        'entityType':        entityType,
        'entitySize':        entitySize,
      });
      print('✅ [SendGridRepo] sendContactNotification result: ${result.data}');
    } on FirebaseFunctionsException catch (e) {
      print('❌ [SendGridRepo] sendContactNotification FunctionsException: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      print('❌ [SendGridRepo] sendContactNotification error: $e');
      rethrow;
    }
  }

  // ── Submitter confirmation ─────────────────────────────────────────────────

  Future<void> sendContactConfirmation({
    required String toEmail,
    required String submitterName,
    required String subject,
    required String message,
    required bool   isArabic,
    required String preferredLanguage,
    required String location,
    required String entityName,
    required String entityType,
    required String entitySize,
  }) async {
    try {
      final callable = FirebaseFunctions.instance.httpsCallable('sendContactConfirmation');
      final result   = await callable.call({
        'toEmail':           toEmail,
        'submitterName':     submitterName,
        'subject':           subject,
        'message':           message,
        'isArabic':          isArabic,
        'preferredLanguage': preferredLanguage,
        'location':          location,
        'entityName':        entityName,
        'entityType':        entityType,
        'entitySize':        entitySize,
      });
      print('✅ [SendGridRepo] sendContactConfirmation result: ${result.data}');
    } on FirebaseFunctionsException catch (e) {
      print('❌ [SendGridRepo] sendContactConfirmation FunctionsException: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      print('❌ [SendGridRepo] sendContactConfirmation error: $e');
      rethrow;
    }
  }
}