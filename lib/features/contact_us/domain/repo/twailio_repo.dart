import 'package:cloud_functions/cloud_functions.dart';

class TwilioRepository {
  Future<void> sendOTP(String to, String channel, String locale) async {
    print('\n📤 [TWILIO_REPO] Calling Cloud Function sendOTP...');
    print('   - To: $to');
    print('   - Channel: $channel');
    print('   - Locale: $locale');

    try {
      final callable = FirebaseFunctions.instance.httpsCallable('sendOTP');

      final result = await callable.call({
        'to': to,
        'channel': channel,
        'locale': locale,
      });

      print('✅ [TWILIO_REPO] sendOTP result: ${result.data}');

      final success = result.data['success'] as bool? ?? false;
      if (!success) {
        throw Exception('Cloud Function returned success=false');
      }
    } on FirebaseFunctionsException catch (e) {
      print('❌ [TWILIO_REPO] FirebaseFunctionsException: ${e.code} - ${e.message}');
      print('   Details: ${e.details}');
      throw Exception('Failed to send OTP: ${e.message}');
    } catch (e) {
      print('❌ [TWILIO_REPO] Error: $e');
      rethrow;
    }
  }

  Future<bool> verifyOTP(String to, String code) async {
    print('\n🔍 [TWILIO_REPO] Calling Cloud Function verifyOTP...');
    print('   - To: $to');
    print('   - Code: $code');

    try {
      final callable = FirebaseFunctions.instance.httpsCallable('verifyOTP');

      final result = await callable.call({
        'to': to,
        'code': code,
      });

      print('✅ [TWILIO_REPO] verifyOTP result: ${result.data}');

      final success = result.data['success'] as bool? ?? false;
      final status = result.data['status'] as String? ?? '';

      print('   - Approved: $success');
      print('   - Status: $status');

      return success;
    } on FirebaseFunctionsException catch (e) {
      print('❌ [TWILIO_REPO] FirebaseFunctionsException: ${e.code} - ${e.message}');
      print('   Details: ${e.details}');
      throw Exception('Failed to verify OTP: ${e.message}');
    } catch (e) {
      print('❌ [TWILIO_REPO] Error: $e');
      rethrow;
    }
  }
}