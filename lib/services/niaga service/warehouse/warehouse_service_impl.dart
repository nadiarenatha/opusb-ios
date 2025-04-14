import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/warehouse/warehouse_service.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';
import '../../../model/niaga/warehouse_niaga.dart';
import 'dart:convert';

import '../../../shared/constants.dart';

class WarehouseNiagaServiceImpl implements WarehouseService {
  final log = getLogger('WarehouseNiagaServiceImpl');
  final Dio dio;
  final FlutterSecureStorage storage;

  WarehouseNiagaServiceImpl({
    required this.dio,
    required this.storage,
  });

  @override
  Future<List<WarehouseNiagaAccesses>> getwarehouse(
      {int? page,
      String? customerDistribusi,
      String? tujuan,
      String? tglAwal,
      String? tglAkhir}) async {
    List<WarehouseNiagaAccesses> listWarehouse = [];

    customerDistribusi ??= '';
    tujuan ??= '';
    tglAwal ??= '';
    // tglAkhir ??= '';
    tglAkhir ??= tglAwal.isEmpty ? '' : tglAwal;

    try {
      final ownerCode = await storage.read(
            key: AuthKey.ownerCode.toString(),
            aOptions: const AndroidOptions(encryptedSharedPreferences: true),
          ) ??
          'ONLINE'; // Assign empty string if null

      log.i('Making API request to get warehouse with owner code: $ownerCode');

      // Log before making the request
      log.i('Making API request to get warehouse...');
      // log.i('api/v1/stock/gudang?owner_code=$ownerCode&page=$page&size=5');
      log.i(
          'api/v1/stock/gudang?owner_code=$ownerCode&page=$page&size=5&penerima=$customerDistribusi&tujuan=$tujuan&tgl_awal=$tglAwal&tgl_akhir=$tglAkhir');

      final response = await dio.get(
        // 'api/v1/stock/gudang?owner_code=$ownerCode&page=$page&size=5',
        'api/v1/stock/gudang?owner_code=$ownerCode&page=$page&size=5&penerima=$customerDistribusi&tujuan=$tujuan&tgl_awal=$tglAwal&tgl_akhir=$tglAkhir',
        options: Options(
          responseType: ResponseType.json,
        ),
      );
      // Log the entire response
      log.i("Full Response: ${response.toString()}");
      // Log after receiving the response
      log.i("Response status code: ${response.statusCode}");

      final prettyJson =
          const JsonEncoder.withIndent('  ').convert(response.data);
      log.i('Response data: $prettyJson');

      if (response.statusCode == 200) {
        // Deserialize the JSON response to WarehouseNiagaAccesses model
        final WarehouseNiagaAccesses data =
            WarehouseNiagaAccesses.fromJson(response.data);
        listWarehouse.add(data); // Add new data to the list
      } else {
        throw Exception('Failed to load invoices');
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
