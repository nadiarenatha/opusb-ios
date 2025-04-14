import 'dart:ffi';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:niaga_apps_mobile/model/register/register.dart';
import 'package:niaga_apps_mobile/servicelocator.dart';
import 'package:niaga_apps_mobile/services/register_service.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';
import '../model/register/generate_validate_captcha.dart';
import '../model/register/register.dart';
// import '../model/register/register_validate_captcha.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final log = getLogger('RegisterCubit');
  String? sessionId; // Store sessionId here
  String? captchaEncode;

  RegisterCubit() : super(RegisterInitial());
  //GENERATE CAPTCHA
  Future<void> generateCaptcha(String email) async {
    log.i('generate($email)');
    try {
      emit(RegisterInProgress());

      // Use GenerateValidateCaptcha with the correct type
      final captchaResponse = await sl<RegisterService>()
          .generatecaptcha(GenerateValidateCaptcha(email: email));
      sessionId = captchaResponse.sessionId;
      captchaEncode = captchaResponse.captchaEncode;

      emit(GenerateCaptchaSuccess(response: captchaResponse));
    } catch (e) {
      log.e('register error: $e');
      emit(RegisterFailure('$e'));
    }
  }

  //VALIDATE
  Future<void> validateCaptcha({
    required String email,
    required String sessionId,
    required String otpCode,
  }) async {
    log.i('validate($email, $sessionId, $otpCode)');
    try {
      emit(RegisterInProgress());

      if (sessionId == null) {
        throw Exception("Session ID is missing. Generate CAPTCHA first.");
      }

      final validateResponse = await sl<RegisterService>().validate(
        GenerateValidateCaptcha(
          email: email,
          sessionId: sessionId, // Use the stored sessionId
          otpCode: otpCode,
        ),
      );

      emit(ValidateCaptchaSuccess(response: validateResponse));

      // Access and log the status from the response
      log.i('Validation status: ${validateResponse.status}');
    } catch (e) {
      log.e('ValidateCaptcha error: $e');
      emit(RegisterFailure('$e'));
    }
  }

//REGISTERING
  Future<void> registeringAccount(
    bool? active,
    String? phone,
    String? userLogin,
    // String? firstName,
    String? lastName,
    String? email,
    int? adOrganizationId,
    // String? name,
    String? city,
    String? nik,
    String? npwp,
    String? password,
    String? businessUnit,
    String? address,
    String? entitas,
    bool? employee,
    String? adOrganizationName,
    String? ownerCode,
    bool? contractFlag,
    bool? waVerified,
    String? picName,
    bool? assigner,
  ) async {
    // Logging the input values
    log.i(
        'register($active, $phone, $userLogin, $lastName, $email, $adOrganizationId, $city, $nik, $npwp, $password, $businessUnit, $address, $entitas, $employee, $adOrganizationName, $ownerCode, $contractFlag, $waVerified, $picName, $assigner)');
    try {
      emit(RegisterInProgress());

      // Add your registration logic here. For now, it's just a placeholder:
      final registrationResponse =
          await sl<RegisterService>().registeringaccount(
        RegisterCredential(
          // active: active,
          // phone: phone,
          // userLogin: userLogin,
          // firstName: firstName,
          // lastName: lastName,
          // email: email,
          // adOrganizationId: adOrganizationId,
          // name: name,
          // companyName: companyName,
          // companyAddress: companyAddress,
          // city: city,
          // nik: nik,
          // npwp: npwp,
          // password: password,
          //NEW
          active: active ?? false,
          phone: phone ?? '', // Provide a default value if null
          userLogin: userLogin ?? '',
          // firstName: '',
          lastName: lastName ?? '',
          email: email ?? '',
          adOrganizationId: adOrganizationId ?? 0,
          // name: name ?? '',
          city: city ?? '',
          nik: nik ?? '',
          npwp: npwp ?? '',
          password: password ?? '',
          businessUnit: businessUnit ?? '',
          address: address ?? '',
          entitas: entitas ?? '',
          employee: employee ?? false,
          adOrganizationName: adOrganizationName ?? '',
          ownerCode: ownerCode ?? '',
          contractFlag: contractFlag ?? false,
          waVerified: waVerified ?? false,
          picName: picName ?? '',
          assigner: assigner ?? false,
        ),
      );

      emit(RegisteringAccountSuccess(response: registrationResponse));
    } catch (e) {
      log.e('registeringAccount error: $e');
      emit(RegisterFailure('$e'));
    }
  }
}
