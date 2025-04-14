import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';
import '../../model/niaga/login_token_niaga.dart';
import '../../shared/constants.dart';
import 'log_out_service.dart';

class LogOutServiceImpl implements LogOutService {
  final log = getLogger('LogOutServiceImpl');
  final Dio dio;
  final FlutterSecureStorage storage;

  LogOutServiceImpl({
    required this.dio,
    required this.storage,
  });

  @override
  Future<LoginTokenNiaga> logOut(LoginTokenNiaga credential) async {
    log.i('log out(${credential.toJson()})');

    LoginTokenNiaga logOutResponse = LoginTokenNiaga();

    final refreshToken = await storage.read(
      key: AuthKey.refreshToken.toString(),
      aOptions: const AndroidOptions(encryptedSharedPreferences: true),
    );

    log.i('Refresh Token retrieved from AuthNiagaCubit: $refreshToken');

    log.i('Refresh Token nya untuk Log Out: $refreshToken');

    try {
      final response = await dio.post(
        'api/v1/auth/logout',
        data: {'refresh_token': refreshToken},
      );

      log.i("Response data: ${response.data.toString()}");

      if (response.statusCode == 204) {
        log.i("Success");
      }

      logOutResponse = LoginTokenNiaga.fromJson(response.data);

      // Log the captchaEncode value
      log.i("Captcha Encode Validate: ${logOutResponse.refreshToken}");
    } on DioException catch (e) {
      log.e(e);
      if (e.message != null) {
        log.e(e.message!);
      }
      if (e.error != null) {
        throw e.error!;
      }
    }

    return logOutResponse;
  }
}
