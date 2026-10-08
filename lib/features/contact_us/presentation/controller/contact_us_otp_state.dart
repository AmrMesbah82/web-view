abstract class ContactOtpState {
  const ContactOtpState();
}

/// Initial state - no OTP action taken yet
class OtpInitial extends ContactOtpState {}

/// Sending OTP to the phone number
class OtpSending extends ContactOtpState {}

/// OTP sent successfully
class OtpSent extends ContactOtpState {
  final String phoneNumber;
  const OtpSent({required this.phoneNumber});
}

/// Verifying the OTP code
class OtpVerifying extends ContactOtpState {}

/// OTP verified successfully. [verificationToken] is the one-time token the
/// server issued; it must accompany the submission (BUG-51).
class OtpVerified extends ContactOtpState {
  final String verificationToken;
  const OtpVerified({required this.verificationToken});
}

/// Error while verifying a code (wrong / expired code).
class OtpError extends ContactOtpState {
  final String message;
  const OtpError({required this.message});
}

/// BUG-14: sending the code failed — the OTP dialog must not open.
class OtpSendFailed extends OtpError {
  const OtpSendFailed({required super.message});
}
