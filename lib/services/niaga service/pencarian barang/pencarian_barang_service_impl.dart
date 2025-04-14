import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/pencarian%20barang/pencarian_barang_service.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';
import 'package:niaga_apps_mobile/shared/constants.dart';
import '../../../model/niaga/cari-barang-profil/pencarian_barang.dart';
import '../../../model/niaga/log_niaga.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

class PencarianBarangServiceImpl implements PencarianBarangService {
  final log = getLogger('PencarianBarangServiceImpl');
  final Dio dio;
  final FlutterSecureStorage storage;

  PencarianBarangServiceImpl({
    required this.dio,
    required this.storage,
  });

  @override
  Future<List<PencarianBarangAccesses>> getcaribarang(
      {int? page,
      String? noResi,
      String? penerima,
      String? tglAwal,
      String? tglAkhir}) async {
    // Future<List<PencarianBarangAccesses>> getopeninvoice() async {
    List<PencarianBarangAccesses> listCariBarang = [];

    try {
      final ownerCode = await storage.read(
            key: AuthKey.ownerCode.toString(),
            aOptions: const AndroidOptions(encryptedSharedPreferences: true),
          ) ??
          'ONLINE'; // Assign empty string if null

      log.i(
          'Making API request to get cari barang with owner code: $ownerCode');
      // Log before making the request
      log.i('Making API request to get cari barang...');
      log.i(
          'api/v1/pencarian/barang?page=$page&size=5&owner_code=$ownerCode&no_resi=$noResi&penerima=$penerima&tgl_awal=$tglAwal&tgl_akhir=$tglAkhir');

      final response = await dio.get(
        // 'api/v1/summary_invoice?email=MM_SBY2000%40YAHOO.CO.ID&page=$page&size=5&status=OPEN',
        'api/v1/pencarian/barang?page=$page&size=5&owner_code=$ownerCode&no_resi=$noResi&penerima=$penerima&tgl_awal=$tglAwal&tgl_akhir=$tglAkhir',
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
        // Deserialize the JSON response to PencarianBarangAccesses model
        final PencarianBarangAccesses data =
            PencarianBarangAccesses.fromJson(response.data);
        listCariBarang.add(data); // Add new data to the list
      } else {
        throw Exception('Failed to load open invoices');
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

class LogNiagaServiceImpl7 implements LogNiagaService7 {
  final log = getLogger('LogNiagaServiceImpl7');
  final Dio dio;
  final FlutterSecureStorage storage;

  LogNiagaServiceImpl7({
    required this.dio,
    required this.storage,
  });

  Future<String> getFullUrl(int? page, String? noResi, String? penerima,
      String? tglAwal, String? tglAkhir) async {
    final ownerCode = await storage.read(
          key: AuthKey.ownerCode.toString(),
          aOptions: const AndroidOptions(encryptedSharedPreferences: true),
        ) ??
        'ONLINE';

    noResi = noResi ?? '';
    penerima = penerima ?? '';
    tglAwal = tglAwal ?? '';
    tglAkhir = tglAkhir ?? '';

    if (tglAwal.isNotEmpty) {
      // If searching by tanggalMasuk, set noResi and tujuan to ''
      noResi = '';
      penerima = '';
    } else if (noResi.isNotEmpty) {
      // If searching by noResi, set tanggalMasuk and penerima to ''
      tglAwal = '';
      penerima = '';
    } else if (penerima.isNotEmpty) {
      // If searching by penerima, set tanggalMasuk and noResi to ''
      tglAwal = '';
      noResi = '';
    }

    final endpoint =
        'v1/pencarian/barang?page=$page&size=5&owner_code=$ownerCode&no_resi=$noResi&penerima=$penerima&tgl_awal=$tglAwal&tgl_akhir=$tglAkhir';
    return '${dio.options.baseUrl}$endpoint';
  }

  @override
  Future<LogNiagaAccesses> logNiaga(int? page, String? noResi, String? penerima,
      String? tglAwal, String? tglAkhir) async {
    final sysdate =
        DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(DateTime.now().toUtc());

    log.i('Formatted sysdate: $sysdate');

    try {
      final fullUrl =
          await getFullUrl(page, noResi, penerima, tglAwal, tglAkhir);
      log.i('Full URL Log Pencarian Barang: $fullUrl');

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
