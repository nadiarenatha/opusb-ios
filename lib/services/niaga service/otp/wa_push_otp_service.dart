import '../../../model/niaga/otp/wa_push_otp.dart';

abstract class WAPushOTPService {
  Future<WAPushOTPNiaga> waPushOtp(
      WAPushOTPNiaga credential);
}
