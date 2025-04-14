import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';
import '../../../model/niaga/cari-barang-profil/detail_data_barang.dart';
import '../../../model/niaga/cari-barang-profil/jenis_barang_data.dart';
import '../../../model/niaga/log_niaga.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

import 'detail_pencarian_barang_service.dart';

class DetailPencarianBarangServiceImpl implements DetailPencarianBarangService {
  final log = getLogger('DetailPencarianBarangServiceImpl');
  final Dio dio;
  final FlutterSecureStorage storage;

  DetailPencarianBarangServiceImpl({
    required this.dio,
    required this.storage,
  });

  @override
  Future<List<DetailJenisBarangAccesses>> getDetailCariBarang(
      {String? noResi}) async {
    // Future<List<PencarianBarangAccesses>> getopeninvoice() async {
    List<DetailJenisBarangAccesses> listDetailCariBarang = [];

    try {
      // Log before making the request
      log.i('Making API request to get cari barang...');
      log.i('api/v1/tracking?no=$noResi');

      final response = await dio.get(
        'api/v1/tracking?no=$noResi',
        // 'api/v1/tracking?no=2442500264419',
        options: Options(
          responseType: ResponseType.json,
        ),
      );
      // Log the entire response
      log.i("Full Response: ${response.toString()}");
      log.i("Response status code: ${response.statusCode}");
      // log.i("Response data: ${response.data}");
      final prettyJson =
          const JsonEncoder.withIndent('  ').convert(response.data);
      log.i('Response data: $prettyJson');

      if (response.statusCode == 200) {
        final responseMap =
            response.data; // Assuming this is your JSON response
        final trackDetailResponse =
            JenisBarangData.fromJson(responseMap['data']);

        if (trackDetailResponse.trackDetail != null) {
          listDetailCariBarang = trackDetailResponse.trackDetail!;
          log.i('Number of details found: ${listDetailCariBarang.length}');
        } else {
          log.e('No track details found.');
        }
      } else {
        throw Exception(
            'Failed to load detail cari barang: ${response.statusCode}');
      }
    } on DioException catch (e) {
      log.e('DioException occurred: $e');
      if (e.response != null) {
        log.e('Dio response: ${e.response}');
      }
    } catch (e) {
      log.e('Unexpected error: $e');
    }

    return listDetailCariBarang;
  }
}

class LogNiagaServiceImpl9 implements LogNiagaService9 {
  final log = getLogger('LogNiagaServiceImpl9');
  final Dio dio;
  final FlutterSecureStorage storage;

  LogNiagaServiceImpl9({
    required this.dio,
    required this.storage,
  });

  Future<String> getFullUrl(String? noResi) async {
    final endpoint = 'v1/tracking?no=$noResi';
    return '${dio.options.baseUrl}$endpoint';
  }

  @override
  Future<LogNiagaAccesses> logNiaga(String? noResi) async {
    final sysdate =
        DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(DateTime.now().toUtc());

    log.i('Formatted sysdate: $sysdate');

    try {
      final fullUrl = await getFullUrl(noResi);
      log.i('Full URL Log Detail Pencarian Barang: $fullUrl');

      final response = await dio.post(
        'https://dev-apps.niaga-logistics.com/api/bhp-activity-logs',
        data: {
          'actionUrl': fullUrl,
          'requestBy': 'mobile',
          'activityLogTime': sysdate,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      log.i("Response data: ${response.data.toString()}");
      log.i("Response status code: ${response.statusCode}");

      if (response.statusCode == 201) {
        log.i("Log successfully created!");
        // Convert response data to model
        final logNiagaAccess = LogNiagaAccesses.fromJson(response.data);
        return logNiagaAccess;
      } else {
        throw Exception(
            'Failed to log niaga: Unexpected status code ${response.statusCode}');
      }
    } on DioException catch (e) {
      log.e(e);
      if (e.message != null) {
        log.e(e.message!);
      }
      if (e.error != null) {
        throw e.error!;
      }
      throw Exception('Failed to get log niaga');
    }
  }
}
