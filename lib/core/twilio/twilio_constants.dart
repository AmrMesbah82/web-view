// BUG-51: Twilio credentials must NEVER be compiled into the website — they
// were readable by anyone in main.dart.js. They now live only as Cloud
// Functions secrets (TWILIO_ACCOUNT_SID / TWILIO_AUTH_TOKEN /
// TWILIO_VERIFY_SERVICE_SID). Rotate the old token in the Twilio console.
//
// This file is kept (empty) only so old imports still compile.
@Deprecated('Twilio is called from Cloud Functions only (BUG-51).')
class TwilioConstants {
  TwilioConstants._();
}
