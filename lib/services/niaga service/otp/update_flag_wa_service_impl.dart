import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/otp/update_flag_wa_service.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/otp/wa_verifikasi_service.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';
import 'dart:convert';

import '../../../model/niaga/wa_verified.dart';
import '../../../shared/constants.dart';

class UpdateFlagWAServiceImpl implements UpdateFlagWAService {
  final log = getLogger('UpdateFlagWAServiceImpl');
  final Dio dio;
  final FlutterSecureStorage storage;

  UpdateFlagWAServiceImpl({
    required this.dio,
    required this.storage,
  });

  @override
  Future<WAVerifiedAccesses> updateWAVerfied() async {
    try {
      final email = await storage.read(
        key: AuthKey.email.toString(),
        aOptions: const AndroidOptions(encryptedSharedPreferences: true),
      );
      log.i("Email update nya: $email");

      if (email == null) {
        log.e("Email is null, cannot proceed with contract flag update.");
        throw Exception("Email not found in secure storage");
      }

      log.i(
          'Ini Link nya : ad-users/validate-wa');

      final response = await dio.post(
        'ad-users/validate-wa',
        data: {
          'userLogin': email
        },
      );

      log.i("WA Verified flag update response: ${response.data}");
      return WAVerifiedAccesses.fromJson(response.data);
    } on DioException catch (e) {
      log.e("Error update wa verified flag: $e");
      rethrow;
    }
  }
}
