import 'package:cloud_functions/cloud_functions.dart';

class TwilioRepository {
  Future<void> sendOTP(String to, String channel, String locale) async {

    try {
      final callable = FirebaseFunctions.instance.httpsCallable('sendOTP');

      final result = await callable.call({
        'to': to,
        'channel': channel,
        'locale': locale,
      });


      final success = result.data['success'] as bool? ?? false;
      if (!success) {
        throw Exception('Cloud Function returned success=false');
      }
    } on FirebaseFunctionsException catch (e) {
      throw Exception('Failed to send OTP: ${e.message}');
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> verifyOTP(String to, String code) async {

    try {
      final callable = FirebaseFunctions.instance.httpsCallable('verifyOTP');

      final result = await callable.call({
        'to': to,
        'code': code,
      });


      final success = result.data['success'] as bool? ?? false;
      final status = result.data['status'] as String? ?? '';


      return success;
    } on FirebaseFunctionsException catch (e) {
      throw Exception('Failed to verify OTP: ${e.message}');
    } catch (e) {
      rethrow;
    }
  }
}