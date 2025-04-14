import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/otp/wa_push_otp_service.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';
import 'dart:convert';

import '../../../model/niaga/otp/wa_push_otp.dart';
import '../../../shared/constants.dart';

class WAPushOTPServiceImpl implements WAPushOTPService {
  final log = getLogger('WAPushOTPServiceImpl');
  final Dio dio;
  final FlutterSecureStorage storage;

  WAPushOTPServiceImpl({
    required this.dio,
    required this.storage,
  });

  @override
  Future<WAPushOTPNiaga> waPushOtp(WAPushOTPNiaga credential) async {
    log.i('waPushOtp(${credential.toJson()})');
    log.i(dio.options.baseUrl);

    try {
      // Read phone and email from secure storage
      final phone = await storage.read(
        key: AuthKey.phone.toString(),
        aOptions: const AndroidOptions(encryptedSharedPreferences: true),
      );

      final email = await storage.read(
        key: AuthKey.email.toString(),
        aOptions: const AndroidOptions(encryptedSharedPreferences: true),
      );

      log.i('Making API request to get phone: $phone');
      log.i('Making API request to get email: $email');

      // Make API request using Dio
      final response = await dio.post(
        'api/v1/wa/push/otp',
        data: {
          'no': phone, // Corrected variable usage
          'email': email, // Corrected variable usage
        },
      );

      log.i("Response Niaga: " + response.data.toString());

      // Return the parsed response as needed
      return WAPushOTPNiaga.fromJson(response.data);
    } on DioException catch (e) {
      log.e(e);
      if (e.message != null) {
        log.e(e.message!);
      }
      if (e.error != null) {
        throw e.error!;
      }
      rethrow;
    }
  }
}
