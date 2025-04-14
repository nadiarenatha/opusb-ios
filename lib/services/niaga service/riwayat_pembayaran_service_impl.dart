import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/riwayat_pembayaran_service.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';
import 'dart:convert';

import '../../../shared/constants.dart';
import '../../model/niaga/riwayat_pembayaran.dart';

class RiwayatPembayaranServiceImpl implements RiwayatPembayaranService {
  final log = getLogger('RiwayatPembayaranServiceImpl');
  final Dio dio;
  final FlutterSecureStorage storage;

  RiwayatPembayaranServiceImpl({
    required this.dio,
    required this.storage,
  });

  @override
  Future<List<RiwayatPembayaranAccesses>> getRiwayatPembayaran() async {
    List<RiwayatPembayaranAccesses> listRiwayatPembayaran = [];

    try {
      log.i('Making API request to get riwayat pembayaran...');

      final email = await storage.read(
        key: AuthKey.email.toString(),
        aOptions: const AndroidOptions(encryptedSharedPreferences: true),
      );

      String? ownerCode = await storage.read(
        key: AuthKey.ownerCode.toString(),
        aOptions: const AndroidOptions(encryptedSharedPreferences: true),
      );

      String url =
          'bhp-order-payments?email.equals=$email&statusPayment.in=S,F';

      if (ownerCode != null && ownerCode != "ONLINE") {
        url += '&owner_code=$ownerCode';
      }

      log.i('url nya: $url');

      // final response = await dio
      //     .get('bhp-order-payments?email.equals=$email&statusPayment.in=S,F');

      final response = await dio.get(
        url,
      );

      log.i("Full Response: ${response.toString()}");
      log.i("Response status code: ${response.statusCode}");

      if (response.statusCode == 200) {
        if (response.data is List) {
          // Map the response data to your model
          listRiwayatPembayaran = (response.data as List)
              .map((jsonItem) => RiwayatPembayaranAccesses.fromJson(jsonItem))
              .toList();
          log.i(
              "Parsed Riwayat Pembayaran List: ${listRiwayatPembayaran.toString()}");
        } else {
          log.e('Unexpected response format: ${response.data}');
        }
      } else {
        throw Exception('Failed to load riwayat pembayaran');
      }
    } on DioException catch (e) {
      log.e('DioException occurred: $e');
      if (e.response != null) {
        log.e('Dio response: ${e.response}');
      }
    } catch (e) {
      log.e('Unexpected error: $e');
    }

    return listRiwayatPembayaran;
  }
}
