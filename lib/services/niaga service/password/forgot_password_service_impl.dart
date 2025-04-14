import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';

import '../../../model/forgot_password.dart';
import 'forgot_password_service.dart';

class ForgotPasswordServiceImpl implements ForgotPasswordService {
  final log = getLogger('ForgotPasswordServiceImpl');
  final Dio dio;
  final FlutterSecureStorage storage;

  ForgotPasswordServiceImpl({
    required this.dio,
    required this.storage,
  });

  @override
  //Forgot Password
  Future<void> forgotPasswordNiaga(ForgotPassword credential) async {
    log.i('forgotPasswordNiaga(${credential.toJson()})');
    log.i(dio.options.baseUrl);

    // Print the credential email
    log.i('Credential Email Forgot Password: ${credential.email}');

    try {
      log.i('account/reset-password/init');

      final response = await dio.post(
        'account/reset-password/init',
        data: credential.email,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      log.i("Response Niaga: " + response.data.toString());

      if (response.statusCode == 200) {
        // log.i("Password change successful: ${response.data['data']}");
        log.i("Berhasil kirim email");
      } else if (response.statusCode == 400) {
        log.e("Gagal");
      } else {
        throw Exception('Unknown error occurred');
      }
    } on DioException catch (e) {
      log.e(e);
      if (e.message != null) {
        log.e(e.message!);
      }
      if (e.error != null) {
        throw e.error!;
      }
    }
  }
}
