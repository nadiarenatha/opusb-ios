import 'package:niaga_apps_mobile/model/register/register.dart';
import '../model/register/generate_validate_captcha.dart';
// import '../model/register/register_generate_captcha.dart';
// import '../model/register/register_validate_captcha.dart';

abstract class RegisterService {
  // Future<RegisterGenerateCaptcha> getSession();
  // Future<RegisterValidateCaptcha> validatecaptcha();
  //====
  // Future<RegisterGenerateCaptcha> generatecaptcha(
  //     RegisterGenerateCaptcha credential);
  //====
  Future<GenerateValidateCaptcha> generatecaptcha(
      GenerateValidateCaptcha credential);
  // Future<RegisterValidateCaptcha> validate(RegisterValidateCaptcha credential);
  Future<GenerateValidateCaptcha> validate(GenerateValidateCaptcha credential);
  Future<RegisterCredential> registeringaccount(RegisterCredential credential);
  // Future<void> register(RegisterCredential credential);
}
