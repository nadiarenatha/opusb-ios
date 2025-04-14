import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';

import '../../../model/niaga/check-email/email_account.dart';
import 'check_email_service.dart';

class CheckEmailServiceImpl implements CheckEmailService {
  final log = getLogger('CheckEmailServiceImpl');
  final Dio dio;
  final FlutterSecureStorage storage;

  CheckEmailServiceImpl({
    required this.dio,
    required this.storage,
  });

  @override
  Future<EmailAccountAccesses> checkEmail(String email) async {
    try {
      // Make the API call
      log.i('ad-users/check-email?email=$email');
      final response = await dio.post('ad-users/check-email?email=$email');
      log.i('Response received: ${response.data}');

      if (response.statusCode == 200) {
        // Assuming response.data is a single JSON object
        final responseData = response.data;

        // Parse the response data into a EmailAccountAccesses object
        final dataLoginAccess = EmailAccountAccesses.fromJson(responseData);

        log.i('Successfully parsed check email');
        return dataLoginAccess;
      } else {
        log.e('Failed to fetch data login: ${response.statusCode}');
        throw Exception('Failed to fetch check email');
      }
    } on DioException catch (e) {
      log.e('Error fetching data login: $e');
      throw Exception('Error fetching check email: $e');
    }
  }
}
