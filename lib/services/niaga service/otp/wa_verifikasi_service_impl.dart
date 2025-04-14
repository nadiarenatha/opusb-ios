import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/otp/wa_verifikasi_service.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';
import 'dart:convert';

import '../../../model/niaga/otp/wa_verifikasi.dart';
import '../../../shared/constants.dart';

class WAVerifikasiServiceImpl implements WAVerifikasiService {
  final log = getLogger('WAVerifikasiServiceImpl');
  final Dio dio;
  final FlutterSecureStorage storage;

  WAVerifikasiServiceImpl({
    required this.dio,
    required this.storage,
  });

  @override
  // Future<WAVerifikasiNiaga> waVerifikasi(WAVerifikasiNiaga credential) async {
  Future<Response> waVerifikasi(WAVerifikasiNiaga credential) async {
    log.i('waVerifikasi(${credential.toJson()})');
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
        'api/v1/wa/verifikasi',
        data: {
          'no': phone, // Corrected variable usage
          'email': email, // Corrected variable usage
          'otp': credential.otp,
        },
      );

      log.i("Response Niaga Verifkasi: " + response.data.toString());

      // Return the parsed response as needed
      // return WAVerifikasiNiaga.fromJson(response.data);
      return response;
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

  // Future<Response> updateupdateWAVerfied() async {
  //   try {
  //     final email = await storage.read(
  //       key: AuthKey.email.toString(),
  //       aOptions: const AndroidOptions(encryptedSharedPreferences: true),
  //     );
  //     log.i("Email update nya: $email");

  //     if (email == null) {
  //       log.e("Email is null, cannot proceed with contract flag update.");
  //       throw Exception("Email not found in secure storage");
  //     }

  //     log.i(
  //         'Ini Link nya : https://api-app.niaga-logistics.com/ad-users/validate-wa/$email');

  //     final response = await dio.put(
  //       // 'https://api-app.niaga-logistics.com/ad-users/validate-wa/superuser',
  //       'https://api-app.niaga-logistics.com/ad-users/validate-wa/$email',
  //       // options: Options(
  //       //   headers: {
  //       //     'Content-Type': 'application/json',
  //       //   },
  //       // ),
  //     );

  //     log.i("WA Verified flag update response: ${response.data}");
  //     return response;
  //   } on DioException catch (e) {
  //     log.e("Error update wa verified flag: $e");
  //     rethrow;
  //   }
  // }
}
