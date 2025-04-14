import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/warehouse/search_warehouse_service.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/warehouse/warehouse_service.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';
import '../../../model/niaga/log_niaga.dart';
import '../../../model/niaga/warehouse_niaga.dart';
import 'package:intl/intl.dart';

import '../../../shared/constants.dart';

class SearchWarehouseNiagaServiceImpl implements SearchWarehouseService {
  final log = getLogger('SearchWarehouseNiagaServiceImpl');
  final Dio dio;
  final FlutterSecureStorage storage;

  SearchWarehouseNiagaServiceImpl({
    required this.dio,
    required this.storage,
  });

  @override
  Future<List<WarehouseNiagaAccesses>> searchwarehouse(
      {int? page,
      String? customerDistribusi,
      String? tujuan,
      // String? tanggalMasuk
      String? tglAwal,
      String? tglAkhir}) async {
    // Default to empty strings if not provided
    customerDistribusi ??= '';
    tujuan ??= '';
    tglAwal ??= '';
    // tglAkhir ??= '';
    tglAkhir ??= tglAwal.isEmpty ? '' : tglAwal;

    List<WarehouseNiagaAccesses> listWarehouse = [];

    try {
      final ownerCode = await storage.read(
            key: AuthKey.ownerCode.toString(),
            aOptions: const AndroidOptions(encryptedSharedPreferences: true),
          ) ??
          'ONLINE'; // Assign empty string if null

      final email = await storage.read(
        key: AuthKey.email.toString(),
        aOptions: const AndroidOptions(encryptedSharedPreferences: true),
      ); // Assign empty string if null

      log.i(
          'Making API request to get search warehouse with owner code: $ownerCode');
      // Log before making the request
      log.i('Making API request to get warehouse...');
      // log.i(
      //     'api/v1/stock/gudang?owner_code=$ownerCode&page=$page&size=5&penerima=$customerDistribusi&tujuan=$tujuan&tgl_awal=$tglAwal&tgl_akhir=$tglAkhir');
      String url =
          'api/v1/stock/gudang?email=$email&page=$page&size=5&penerima=$customerDistribusi&tujuan=$tujuan&tgl_awal=$tglAwal&tgl_akhir=$tglAkhir';

      if (ownerCode != null && ownerCode != "ONLINE") {
        url += '&owner_code=$ownerCode';
      }

      log.i('url Warehouse nya: $url');

      // final response = await dio.get(
      //   // 'api/v1/stock/gudang?owner_code=C20200163&page=1&size=5',
      //   'api/v1/stock/gudang?owner_code=$ownerCode&page=$page&size=5&penerima=$customerDistribusi&tujuan=$tujuan&tgl_awal=$tglAwal&tgl_akhir=$tglAkhir',
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
        // Deserialize the JSON response to WarehouseNiagaAccesses model
        final WarehouseNiagaAccesses data =
            WarehouseNiagaAccesses.fromJson(response.data);
        listWarehouse.add(data); // Add new data to the list
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

    return listWarehouse;
  }
}

class LogNiagaServiceImpl6 implements LogNiagaService6 {
  final log = getLogger('LogNiagaServiceImpl6');
  final Dio dio;
  final FlutterSecureStorage storage;

  LogNiagaServiceImpl6({
    required this.dio,
    required this.storage,
  });

  Future<String> getFullUrl(
      int? page,
      String? customerDistribusi,
      String? tujuan,
      // String? tanggalMasuk
      String? tglAwal,
      String? tglAkhir) async {
    final ownerCode = await storage.read(
          key: AuthKey.ownerCode.toString(),
          aOptions: const AndroidOptions(encryptedSharedPreferences: true),
        ) ??
        'ONLINE';

    customerDistribusi ??= '';
    tujuan ??= '';
    tglAwal ??= '';
    tglAkhir ??= tglAwal.isEmpty ? '' : tglAwal;

    final endpoint =
        'v1/stock/gudang?owner_code=$ownerCode&page=$page&size=5&penerima=$customerDistribusi&tujuan=$tujuan&tgl_awal=$tglAwal&tgl_akhir=$tglAkhir';
    return '${dio.options.baseUrl}$endpoint';
  }

  @override
  Future<LogNiagaAccesses> logNiaga(int? page, String? customerDistribusi,
      String? tujuan, String? tglAwal, String? tglAkhir) async {
    final sysdate =
        DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(DateTime.now().toUtc());

    log.i('Formatted sysdate: $sysdate');

    try {
      final fullUrl =
          await getFullUrl(page, customerDistribusi, tujuan, tglAwal, tglAkhir);
      log.i('Full URL Log Warehouse: $fullUrl');

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
