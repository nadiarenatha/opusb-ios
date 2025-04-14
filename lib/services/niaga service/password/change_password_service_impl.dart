import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';

import '../../../model/change_password.dart';
import '../../../model/forgot_password.dart';
import 'change_password_service.dart';

class ChangePasswordImpl implements ChangePasswordService {
  final log = getLogger('ChangePasswordImpl');
  final Dio dio;
  final FlutterSecureStorage storage;

  ChangePasswordImpl({
    required this.dio,
    required this.storage,
  });

  @override
  Future<void> changePasswordNiaga(ChangePassword credential) async {
    log.i('changePassword(${credential.toJson()})');
    log.i(dio.options.baseUrl);

    try {
      log.i('account/change-password');

      final response = await dio.post(
        'account/change-password',
        data: {
          'currentPassword': credential.currentPassword,
          'newPassword': credential.newPassword,
        },
      );

      log.i("Response Niaga: " + response.data.toString());

      if (response.statusCode == 200) {
        // log.i("Password change successful: ${response.data['data']}");
        log.i("Password change successful");
      } else if (response.statusCode == 400) {
        // log.e("Incorrect password");
        // throw Exception('Incorrect password');
        final responseData = response.data;
        if (responseData['title'] == "Incorrect password") {
          log.e("Incorrect password provided");
          throw Exception("Incorrect password");
        } else {
          throw Exception("Password change failed with status 400");
        }
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
