import 'package:cloud_functions/cloud_functions.dart';

/// Result of checking an OTP code on the server.
class OtpCheckResult {
  final bool approved;

  /// One-time token issued by the `verifyOTP` Cloud Function. It must be sent
  /// with the contact submission (`submitContactForm`) — the server refuses a
  /// submission without a fresh, unused token (BUG-51).
  final String? verificationToken;

  const OtpCheckResult({required this.approved, this.verificationToken});
}

/// BUG-51 / BUG-14: every Twilio call goes through our own Cloud Functions.
/// Twilio keys stay on the server and the server decides if a code is valid.
class TwilioRepository {
  Future<void> sendOTP(String to, String channel, String locale) async {
    try {
      final result = await FirebaseFunctions.instance
          .httpsCallable('sendOTP')
          .call({'to': to, 'channel': channel, 'locale': locale});
      final data = Map<String, dynamic>.from(result.data as Map);
      if (data['success'] != true) {
        throw Exception('The verification code could not be sent.');
      }
    } on FirebaseFunctionsException catch (e) {
      // BUG-14: surface the real failure instead of pretending it was sent.
      throw Exception(e.message ?? 'The verification code could not be sent.');
    }
  }

  Future<OtpCheckResult> verifyOTP(String to, String code) async {
    try {
      final result = await FirebaseFunctions.instance
          .httpsCallable('verifyOTP')
          .call({'to': to, 'code': code});
      final data = Map<String, dynamic>.from(result.data as Map);
      return OtpCheckResult(
        approved: data['success'] == true,
        verificationToken: data['verificationToken'] as String?,
      );
    } on FirebaseFunctionsException catch (e) {
      throw Exception(e.message ?? 'The code could not be verified.');
    }
  }
}
