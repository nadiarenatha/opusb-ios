import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:niaga_apps_mobile/model/niaga/detail-warehouse/data_barang_gudang.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';
import '../../../model/niaga/detail-warehouse/barang_gudang.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

import '../../../model/niaga/log_niaga.dart';
import 'detail_warehouse_service.dart';

class DetailWarehouseNiagaServiceImpl implements DetailWarehouseService {
  final log = getLogger('DetailWarehouseNiagaServiceImpl');
  final Dio dio;
  final FlutterSecureStorage storage;

  DetailWarehouseNiagaServiceImpl({
    required this.dio,
    required this.storage,
  });

  @override
  Future<List<BarangGudangDataAccesses>> getDetailWarehouse({String? asnNo}) async {
    List<BarangGudangDataAccesses> listdetailWarehouse = [];

    try {
      log.i('Making API request to get detail warehouse...');
      log.i('api/v1/stock/gudang?asn_no=$asnNo&size=5&page=1');
      
      final response = await dio.get(
        'api/v1/stock/gudang?asn_no=$asnNo&size=5&page=1',
        // 'api/v1/stock/gudang?asn_no=256853&size=5&page=1',
        // 'api/v1/stock/gudang?asn_no=285592&size=5&page=1',
      );

      // Log the entire response
      log.i("Full Response: ${response.toString()}");
      // Log response status code
      log.i("Response status code: ${response.statusCode}");

      final prettyJson =
          const JsonEncoder.withIndent('  ').convert(response.data);
      log.i('Response data: $prettyJson');

      if (response.statusCode == 200) {
        // Parse the JSON into BarangGudangAccesses
        final barangGudangAccesses = BarangGudangAccesses.fromJson(response.data);

        // Extract the 'data' list
        listdetailWarehouse = barangGudangAccesses.data;

        log.i('Parsed data: ${listdetailWarehouse.length} items');
      } else {
        log.w('Failed to load detail barang: ${response.statusCode}');
        throw Exception('Failed to load detail barang');
      }
    } on DioException catch (e) {
      log.e('DioException occurred: $e');
      if (e.response != null) {
        log.e('Dio response: ${e.response}');
      }
      throw Exception('DioException: ${e.message}');
    } catch (e) {
      log.e('Unexpected error: $e');
      throw Exception('Unexpected error: $e');
    }

    return listdetailWarehouse;
  }
}

//LOG DETAIL WAREHOUSE
class LogNiagaServiceImpl10 implements LogNiagaService10 {
  final log = getLogger('LogNiagaServiceImpl10');
  final Dio dio;
  final FlutterSecureStorage storage;

  LogNiagaServiceImpl10({
    required this.dio,
    required this.storage,
  });

  Future<String> getFullUrl(String? asnNo) async {
    final endpoint = 'v1/stock/gudang?asn_no=$asnNo&size=5&page=1';
    return '${dio.options.baseUrl}$endpoint';
  }

  @override
  Future<LogNiagaAccesses> logNiaga(String? asnNo) async {
    final sysdate =
        DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(DateTime.now().toUtc());

    log.i('Formatted sysdate: $sysdate');

    try {
      final fullUrl = await getFullUrl(asnNo);
      log.i('Full URL Log Detail Warehouse: $fullUrl');

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