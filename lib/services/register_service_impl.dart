import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:niaga_apps_mobile/services/register_service.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';
import '../model/register/generate_validate_captcha.dart';
import '../model/register/register.dart';
// import '../model/register/register_generate_captcha.dart';
// import '../model/register/register_validate_captcha.dart';
import '../shared/constants.dart';
import '../shared/functions/flutter_secure_storage.dart';

class RegisterServiceImpl implements RegisterService {
// abstract class RegisterServiceImpl implements RegisterService {
  final log = getLogger('RegisterServiceImpl');
  final Dio dio;
  final FlutterSecureStorage storage;

  RegisterServiceImpl({
    required this.dio,
    required this.storage,
  });

  //Generate
  @override
  Future<GenerateValidateCaptcha> generatecaptcha(
      GenerateValidateCaptcha credential) async {
    // Adjusted to use GenerateValidateCaptcha
    log.i('generate(${credential.toJson()})');
    GenerateValidateCaptcha generateResponse = GenerateValidateCaptcha();

    try {
      final response = await dio.post(
        'm-otp-histories/generate-captcha',
        data: {'email': credential.email},
      );

      log.i("Response data: ${response.data.toString()}");

      // Extract and store sessionId
      final String sessionId = response.data['sessionId'];
      print("Session ID: $sessionId");
      await storage.write(key: AuthKey.sessionId.name, value: sessionId);

      // Deserialize the response into GenerateValidateCaptcha
      generateResponse = GenerateValidateCaptcha.fromJson(response.data);

      // Save sessionId for later use
      // await saveAuthData(AuthKey.sessionId, generateResponse.sessionId!);

      // Log the captchaEncode value
      log.i("Captcha Encode Generate: ${generateResponse.captchaEncode}");
    } on DioException catch (e) {
      log.e(e);
      if (e.message != null) {
        log.e(e.message!);
      }
      if (e.error != null) {
        throw e.error!;
      }
    }
    return generateResponse;
  }

//Validate
  @override
  Future<GenerateValidateCaptcha> validate(
      GenerateValidateCaptcha credential) async {
    log.i('validate(${credential.toJson()})');
    GenerateValidateCaptcha validateResponse = GenerateValidateCaptcha();

    try {
      // Retrieve the stored sessionId
      final String? sessionId = await storage.read(key: AuthKey.sessionId.name);

      if (sessionId == null) {
        throw Exception("Session ID not found");
      }
      // print("Session ID validate: $sessionId");
      // Print or log the values
      print("OTP Code validate: ${credential.otpCode}");
      print("Email validate: ${credential.email}");
      print("Session ID validate: $sessionId");

      log.i("OTP Code validate: ${credential.otpCode}");
      log.i("Email validate: ${credential.email}");
      log.i("Session ID validate: $sessionId");

      final response = await dio.post(
        'm-otp-histories/validate-captcha',
        data: {
          'email': credential.email,
          'otpCode': credential.otpCode,
          'sessionId': sessionId, // Use the retrieved sessionId
        },
      );

      log.i("Response data: ${response.data.toString()}");

      validateResponse = GenerateValidateCaptcha.fromJson(response.data);

      // Log the captchaEncode value
      log.i("Captcha Encode Validate: ${validateResponse.captchaEncode}");
    } on DioException catch (e) {
      log.e(e);
      if (e.message != null) {
        log.e(e.message!);
      }
      if (e.error != null) {
        throw e.error!;
      }
    }

    return validateResponse;
  }

  //Register
  // @override
  // Future<RegisterCredential> registeringaccount(
  //     RegisterCredential credential)async {
  //   log.i('register(${credential.toJson()})');
  //   log.i(dio.options.baseUrl);
  //   try {
  //     final response = await dio.post(
  //       'api/ad-users/register',
  //       data: {
  //         'active': credential.active,
  //         'phone': credential.phone,
  //         'userLogin': credential.userLogin,
  //         'firstName': credential.firstName,
  //         'lastName': credential.lastName,
  //         'email': credential.email,
  //         'adOrganizationId': credential.adOrganizationId,
  //         'name': credential.name,
  //         'companyName': credential.companyName,
  //         'companyAddress': credential.companyAddress,
  //         'city': credential.city,
  //         'nik': credential.nik,
  //         'npwp': credential.npwp,
  //         'password': credential.password,
  //       },
  //     );
  //     log.i("Response data: ${response.data.toString()}");
  //     // Handle the response as needed, or just log it
  //   } on DioException catch (e) {
  //     log.e(e);
  //     if (e.message != null) {
  //       log.e(e.message!);
  //     }
  //     if (e.error != null) {
  //       throw e.error!;
  //     }
  //   }
  // }
  //2
  @override
  Future<RegisterCredential> registeringaccount(
      RegisterCredential credential) async {
    log.i('register(${credential.toJson()})');
    log.i('base url: (${dio.options.baseUrl})');

    // Print the values of all the fields in RegisterCredential
    log.i('Active: ${credential.active}');
    log.i('Phone: ${credential.phone}');
    log.i('User Login: ${credential.userLogin}');
    // log.i('First Name: ${credential.firstName}');
    log.i('Last Name: ${credential.lastName}');
    log.i('Email: ${credential.email}');
    log.i('Organization ID: ${credential.adOrganizationId}');
    // log.i('Name: ${credential.name}');
    log.i('City: ${credential.city}');
    log.i('NIK: ${credential.nik}');
    log.i('NPWP: ${credential.npwp}');
    log.i('Password: ${credential.password}');
    log.i('Business Unit: ${credential.businessUnit}');
    log.i('Address: ${credential.address}');
    log.i('Entitas: ${credential.entitas}');
    log.i('Employee: ${credential.employee}');
    log.i('Organization Name: ${credential.adOrganizationName}');
    log.i('Owner Code: ${credential.ownerCode}');
    log.i('Contract Flag: ${credential.contractFlag}');
    log.i('WA Verified: ${credential.waVerified}');
    log.i('PIC Name: ${credential.picName}');
    log.i('assigner: ${credential.assigner}');

    try {
      // log.i('Hit API ${credential.password}');
      final response = await dio.post(
        'ad-users/register',
        data: {
          // 'active': credential.active,
          // 'phone': credential.phone,
          // 'userLogin': credential.userLogin,
          // 'firstName': credential.firstName,
          // 'lastName': credential.lastName,
          // 'email': credential.email,
          // 'adOrganizationId': credential.adOrganizationId,
          // 'name': credential.name,
          // 'companyName': credential.companyName,
          // 'companyAddress': credential.companyAddress,
          // 'city': credential.city,
          // 'nik': credential.nik,
          // 'npwp': credential.npwp,
          // 'password': credential.password,
          // 'active': credential.active,
          // 'phone': credential.phone,
          // 'userLogin': credential.userLogin,
          // 'firstName': credential.firstName,
          // 'lastName': credential.lastName,
          // 'email': credential.email,
          // 'adOrganizationId': credential.adOrganizationId,
          // 'name': credential.name,
          // 'companyName': credential.companyName,
          // 'companyAddress': credential.companyAddress,
          // 'city': credential.city,
          // 'nik': credential.nik,
          // 'npwp': credential.npwp,
          // 'password': credential.password,
          'active': credential.active,
          'phone': credential.phone,
          'userLogin': credential.userLogin,
          // 'firstName': '',
          'lastName': credential.lastName,
          'email': credential.email,
          'adOrganizationId': credential.adOrganizationId,
          // 'name': credential.name,
          'city': credential.city,
          'nik': credential.nik,
          'npwp': credential.npwp,
          'password': credential.password,
          'businessUnit': credential.businessUnit,
          'address': credential.address,
          'entitas': credential.entitas,
          'employee': credential.employee,
          'adOrganizationName': credential.adOrganizationName,
          'ownerCode': credential.ownerCode,
          'contractFlag': credential.contractFlag,
          'waVerified': credential.waVerified,
          'picName': credential.picName,
          'assigner': credential.assigner,
        },
      );

      log.i("Response data: ${response.data.toString()}");

      // Assuming you want to return the RegisterCredential in case of success
      // or you can create a new instance if the response has necessary data.
      return credential; // or map response.data to RegisterCredential if needed
    } on DioException catch (e) {
      log.e(e);
      if (e.message != null) {
        log.e(e.message!);
      }
      if (e.error != null) {
        throw e.error!;
      }
      // Throw a generic exception if no specific error is caught
      throw Exception('Failed to register account');
    }
  }
}
