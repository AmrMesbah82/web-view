import 'package:flutter_bloc/flutter_bloc.dart';

// BUG-51: was core/twilio/twilio_repository.dart, which called Twilio from the
// browser with hard-coded credentials. This one calls our Cloud Functions.
import '../../domain/base_repository/twilio_repo.dart';
import 'contact_us_otp_state.dart';

class ContactOtpCubit extends Cubit<ContactOtpState> {
  final TwilioRepository _twilioRepo;

  ContactOtpCubit({TwilioRepository? repo})
      : _twilioRepo = repo ?? TwilioRepository(),
        super(OtpInitial());

  /// Send OTP to the user's phone number
  Future<void> sendOtp({
    required String phoneNumber,
    required String locale, // 'en' or 'ar'
  }) async {
    try {
      emit(OtpSending());
      await _twilioRepo.sendOTP(phoneNumber, 'sms', locale);
      emit(OtpSent(phoneNumber: phoneNumber));
    } catch (e) {
      // BUG-14: a failed send (e.g. 401 / invalid number) is now reported and
      // the "code sent" dialog is NOT opened.
      emit(OtpSendFailed(message: _clean(e)));
    }
  }

  /// Verify the OTP code entered by the user
  Future<void> verifyOtp({
    required String phoneNumber,
    required String code,
  }) async {
    try {
      emit(OtpVerifying());
      final result = await _twilioRepo.verifyOTP(phoneNumber, code);
      if (result.approved && (result.verificationToken ?? '').isNotEmpty) {
        emit(OtpVerified(verificationToken: result.verificationToken!));
      } else {
        emit(const OtpError(message: 'Invalid verification code. Please try again.'));
      }
    } catch (e) {
      emit(OtpError(message: _clean(e)));
    }
  }

  /// Reset the OTP state to initial
  void reset() => emit(OtpInitial());

  static String _clean(Object e) =>
      e.toString().replaceFirst(RegExp(r'^Exception:\s*'), '');
}
