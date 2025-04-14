import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';
import 'dart:convert';

import '../../../shared/constants.dart';
import '../../model/niaga/alamat.dart';
import 'alamat_muat_service.dart';

class AlamatMuatServiceImpl implements AlamatMuatService {
  final log = getLogger('AlamatMuatServiceImpl');
  final Dio dio;
  final FlutterSecureStorage storage;

  AlamatMuatServiceImpl({
    required this.dio,
    required this.storage,
  });

  @override
  Future<List<AlamatAccesses>> getalamatMuat(String port, String kota) async {
    List<AlamatAccesses> listalamat = [];

    try {
      final accessToken = await storage.read(
        key: AuthKey.accessToken.toString(),
        aOptions: const AndroidOptions(encryptedSharedPreferences: true),
      );

      final email = await storage.read(
        key: AuthKey.email.toString(),
        aOptions: const AndroidOptions(encryptedSharedPreferences: true),
      );

      // final ownerCode = await storage.read(
      //   key: AuthKey.ownerCode.toString(),
      //   aOptions: const AndroidOptions(encryptedSharedPreferences: true),
      // ) ?? "ONLINE";

      String? ownerCode = await storage.read(
        key: AuthKey.ownerCode.toString(),
        aOptions: const AndroidOptions(encryptedSharedPreferences: true),
      );
      ownerCode = ownerCode?.trim().isEmpty ?? true ? "ONLINE" : ownerCode;

      log.i('Resolved ownerCode Muat: $ownerCode');

      log.i(
          'Making API request to get alamat muat with access token: $accessToken');
      log.i('Making API request to get alamat muat with email: $email');
      log.i(
          'Making API request to get alamat muat with owner code: $ownerCode');
      log.i('Making API request to get alamat muat...');

      final response = await dio.post(
        'bhp-addresses/get-union-address',
        data: {
          'port': port,
          'kota': kota,
          'ownerCode': ownerCode,
          'email': email,
          'tipe': 'muat',
          'token': accessToken,
        },
      );

      log.i("Full Response: ${response.toString()}");
      log.i("Response status code: ${response.statusCode}");

      if (response.statusCode == 200) {
        final responseData = response.data;

        if (responseData['Status'] == 'Success') {
          final data = responseData['data'] as List;

          listalamat =
              data.map((item) => AlamatAccesses.fromJson(item)).toList();
          log.i("Parsed data length: ${listalamat.length}");
        } else {
          log.w("Failed to get data: ${responseData['Message']}");
        }
      } else {
        log.e("Error: ${response.statusCode} - ${response.statusMessage}");
      }
    } on DioException catch (e) {
      log.e('DioException occurred: $e');
      if (e.response != null) {
        log.e('Dio response: ${e.response}');
      }
    } catch (e) {
      log.e('Unexpected error: $e');
    }

    return listalamat;
  }
}
