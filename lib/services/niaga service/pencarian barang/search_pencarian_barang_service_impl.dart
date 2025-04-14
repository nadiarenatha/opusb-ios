import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/pencarian%20barang/search_pencarian_barang_service.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';
import '../../../model/niaga/cari-barang-profil/pencarian_barang.dart';
import 'dart:convert';

import '../../../shared/constants.dart';

class SearchPencarianBarangServiceImpl implements SearchPencarianBarangService {
  final log = getLogger('SearchPencarianBarangServiceImpl');
  final Dio dio;
  final FlutterSecureStorage storage;

  SearchPencarianBarangServiceImpl({
    required this.dio,
    required this.storage,
  });

  @override
  Future<List<PencarianBarangAccesses>> searchPencarianBarang(
      {int? page,
      String? noResi,
      String? penerima,
      // String? tanggalMasuk
      String? tglAwal,
      String? tglAkhir}) async {
    // Default to empty strings if not provided
    noResi ??= '';
    penerima ??= '';
    tglAwal ??= '';
    // tglAkhir ??= '';
    tglAkhir ??= tglAwal.isEmpty ? '' : tglAwal;

    List<PencarianBarangAccesses> listCariBarang = [];

    try {
      final ownerCode = await storage.read(
            key: AuthKey.ownerCode.toString(),
            aOptions: const AndroidOptions(encryptedSharedPreferences: true),
          ) ??
          'ONLINE';

      final email = await storage.read(
        key: AuthKey.email.toString(),
        aOptions: const AndroidOptions(encryptedSharedPreferences: true),
      );

      log.i(
          'Making API request to get search pencarian barang with owner code: $ownerCode');
      // Log before making the request
      log.i('Making API request to get search pencarian barang...');
      // log.i(
      //   'api/v1/pencarian/barang?page=$page&size=5&owner_code=$ownerCode&no_resi=$noResi&penerima=$penerima&tgl_awal=$tglAwal&tgl_akhir=$tglAkhir',
      // );

      String url =
          'api/v1/pencarian/barang?page=$page&size=5&email=$email&no_resi=$noResi&penerima=$penerima&tgl_awal=$tglAwal&tgl_akhir=$tglAkhir';

      if (ownerCode != null && ownerCode != "ONLINE") {
        url += '&owner_code=$ownerCode';
      }

      log.i('url pencarian barang nya: $url');

      // final response = await dio.get(
      //   'api/v1/pencarian/barang?page=$page&size=5&owner_code=$ownerCode&no_resi=$noResi&penerima=$penerima&tgl_awal=$tglAwal&tgl_akhir=$tglAkhir',
      //   options: Options(
      //     responseType: ResponseType.json,
      //   ),
      // );

      final response = await dio.get(
        url,
        options: Options(
          responseType: ResponseType.json,
        ),
      );

      // Log the entire response
      log.i("Full Response: ${response.toString()}");
      // Log after receiving the response
      log.i("Response status code: ${response.statusCode}");

      if (response.statusCode == 200) {
        // Deserialize the JSON response to PencarianBarangAccesses model
        final PencarianBarangAccesses data =
            PencarianBarangAccesses.fromJson(response.data);
        listCariBarang.add(data); // Add new data to the list
      } else {
        throw Exception('Failed to load search warehouse');
      }
    } on DioException catch (e) {
      log.e('DioException occurred: $e');
      if (e.response != null) {
        log.e('Dio response: ${e.response}');
      }
    } catch (e) {
      log.e('Unexpected error: $e');
    }

    return listCariBarang;
  }
}
