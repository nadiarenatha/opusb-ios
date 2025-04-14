import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:niaga_apps_mobile/model/niaga/login_credential_niaga.dart';
import 'package:niaga_apps_mobile/shared/constants.dart';
import 'package:niaga_apps_mobile/shared/functions/flutter_secure_storage.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';

import '../../model/niaga/login_token_niaga.dart';
import 'auth_niaga_service_niaga.dart';

class AuthServiceNiagaImpl implements AuthNiagaService {
  final log = getLogger('AuthServiceNiagaImpl');
  final Dio dio;
  final FlutterSecureStorage storage;

  AuthServiceNiagaImpl({
    required this.dio,
    required this.storage,
  });

  @override
  // Future<LoginCredentialNiaga> authenticateNiaga(
  //     LoginCredentialNiaga credential) async {
  //   log.i('authenticateNiaga(${credential.toJson()})');
  //   log.i(dio.options.baseUrl);
  //   LoginCredentialNiaga authNiagaResponse =
  //       LoginCredentialNiaga(accessToken: '');

  //   try {
  //     final response = await dio.post(
  //       'api/v1/auth/login',
  //       data: {
  //         'username': 'niaga',
  //         'password': 'niaga@123',
  //       },
  //     );

  //     log.i("Response Niaga: " + response.data.toString());

  //     final data = response.data['data'];
  //     authNiagaResponse = LoginCredentialNiaga.fromJson(data);

  //     // Extract the access token and store it in secure storage
  //     final accessToken = authNiagaResponse.accessToken;

  //     print('Access Token Niaga: $accessToken');
  //     log.i('Access Token Niaga: $accessToken');

  //     if (accessToken != null) {
  //       // await storage.write(key: AuthKey.accessToken.name, value: accessToken);
  //       await saveAuthData(AuthKey.accessToken, accessToken);
  //       log.i('Access token Niaga stored successfully');
  //     } else {
  //       log.e('Access token Niaga is null');
  //     }
  //   } on DioException catch (e) {
  //     log.e(e);
  //     if (e.message != null) {
  //       log.e(e.message!);
  //     }
  //     if (e.error != null) {
  //       throw e.error!;
  //     }
  //   }
  //   return authNiagaResponse;
  // }

  Future<LoginTokenNiaga> authenticateNiaga(LoginTokenNiaga credential) async {
    log.i('authenticateNiaga(${credential.toJson()})');
    log.i(dio.options.baseUrl);
    LoginTokenNiaga authNiagaResponse = LoginTokenNiaga(accessToken: '');

    try {
      final response = await dio.post(
        'niaga/authenticate',
        data: {},
      );
      log.i("Full Response Data: ${response.data}");

      // Adjust according to actual structure
      final data = response.data['data'] ?? response.data;

      if (data != null) {
        authNiagaResponse = LoginTokenNiaga.fromJson(data);

        final accessToken = authNiagaResponse.accessToken;
        final refreshToken = authNiagaResponse.refreshToken;
        final expiredAt = authNiagaResponse.expiredAt;

        log.i('Parsed Access Token: $accessToken');
        log.i('Parsed Refresh Token: $refreshToken');
        log.i('Parsed Expired At: $expiredAt');

        if (accessToken != null) {
          await saveAuthData(AuthKey.accessToken, accessToken);
          if (refreshToken != null) {
            await saveAuthData(AuthKey.refreshToken, refreshToken);
            log.i('Refresh token Niaga stored successfully');
          } else {
            log.e('Refresh token Niaga is null');
          }
          await storage.write(key: 'access_token', value: accessToken);
          await storage.write(key: 'refresh_token', value: refreshToken);
          log.i('Access token and refresh token stored successfully');
          // log.i('Access token Niaga stored successfully');
        } else {
          log.e('Access token Niaga is null');
        }
      } else {
        log.e('No data found in response');
      }
    } on DioException catch (e) {
      log.e("Error during request: $e");
      if (e.message != null) {
        log.e(e.message!);
      }
      if (e.error != null) {
        throw e.error!;
      }
    }
    return authNiagaResponse;
  }
}
