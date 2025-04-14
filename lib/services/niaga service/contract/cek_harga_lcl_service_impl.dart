import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';
import 'package:intl/intl.dart';

import '../../../model/niaga/cek-harga/cek_harga_lcl.dart';
import '../../../model/niaga/log_niaga.dart';
import '../../../shared/constants.dart';
import 'cek_harga_lcl_service.dart';

class CekHargaLCLServiceImpl implements CekHargaLCLService {
  final log = getLogger('CekHargaLCLServiceImpl');
  final Dio dio;
  final FlutterSecureStorage storage;

  CekHargaLCLServiceImpl({
    required this.dio,
    required this.storage,
  });

  @override
  Future<CekHargaLCLAccesses?> getCekHargaLCL(
      String noKontrak, int hargaKontrak, double cbm) async {
    CekHargaLCLAccesses? listCekHargaLCL;

    try {
      final email = await storage.read(
        key: AuthKey.email.toString(),
        aOptions: const AndroidOptions(encryptedSharedPreferences: true),
      );
      log.i('Making API request to get Cek Harga LCL...');
      log.i('Making API request to get Cek Harga LCL with email: $email...');
      log.i(
          'api/v1/cek/harga?no_kontrak=$noKontrak&harga_kontrak=$hargaKontrak&cbm=$cbm&email=$email');

      // final response = await dio.get(
      //     'api/v1/cek/harga?no_kontrak=C20201190-S%2FFCL%2FSBYMKS-MNGKTN%2FDTD4-KRIAN3%2F07-01-2023-036537&harga_kontrak=15200000&cbm=0.5');
      final response = await dio.get(
          'api/v1/cek/harga?no_kontrak=$noKontrak&harga_kontrak=$hargaKontrak&cbm=$cbm&email=$email');

      log.i("Full Response: ${response.toString()}");
      log.i("Response status code: ${response.statusCode}");

      if (response.statusCode == 200) {
        listCekHargaLCL = CekHargaLCLAccesses.fromJson(response.data);
      } else {
        throw Exception('Failed to load cek Harga FCL');
      }
    } on DioException catch (e) {
      log.e('DioException occurred: $e');
      if (e.response != null) {
        log.e('Dio response: ${e.response}');
      }
    } catch (e) {
      log.e('Unexpected error: $e');
    }

    return listCekHargaLCL;
  }
}

class LogNiagaServiceImpl18 implements LogNiagaService18 {
  Future<String> getFullUrl(
      String noKontrak, int hargaKontrak, double cbm) async {
    final email = await storage.read(
      key: AuthKey.email.toString(),
      aOptions: const AndroidOptions(encryptedSharedPreferences: true),
    );

    final endpoint =
        'v1/cek/harga?no_kontrak=$noKontrak&harga_kontrak=$hargaKontrak&cbm=$cbm&email=$email';
    return '${dio.options.baseUrl}$endpoint';
  }

  final log = getLogger('LogNiagaServiceImpl18');
  final Dio dio;
  final FlutterSecureStorage storage;

  LogNiagaServiceImpl18({
    required this.dio,
    required this.storage,
  });

  @override
  Future<LogNiagaAccesses> logNiaga(
      String noKontrak, int hargaKontrak, double cbm) async {
    final sysdate =
        DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(DateTime.now().toUtc());

    log.i('Formatted sysdate: $sysdate');

    try {
      final fullUrl = await getFullUrl(noKontrak, hargaKontrak, cbm);
      log.i('Full URL Log Cek Harga LCL: $fullUrl');

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
