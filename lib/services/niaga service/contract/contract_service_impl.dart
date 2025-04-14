import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';

import '../../../model/niaga/contract.dart';
import '../../../model/niaga/log_niaga.dart';
import '../../../shared/constants.dart';
import 'contract_service.dart';
import 'package:intl/intl.dart';

class ContractServiceImpl implements ContractService {
  final log = getLogger('ContractServiceImpl');
  final Dio dio;
  final FlutterSecureStorage storage;

  ContractServiceImpl({
    required this.dio,
    required this.storage,
  });

  @override
  Future<List<ContractAccesses>> getContract(String portAsal, String portTujuan,
      String uocAsal, String uocTujuan, int containerSize) async {
    List<ContractAccesses> listContract = [];

    try {
      final ownerCode = await storage.read(
        key: AuthKey.ownerCode.toString(),
        aOptions: const AndroidOptions(encryptedSharedPreferences: true),
      );

      log.i('Making API request to get contract with owner code: $ownerCode');
      log.i('Making API request to get contract...');
      log.i(
          'api/v1/contract?owner_code=$ownerCode&jenis_pengiriman=FCL&port_asal=$portAsal&port_tujuan=$portTujuan&uoc_asal=$uocAsal&uoc_tujuan=$uocTujuan&container_size=$containerSize');

      final response = await dio.get(
          'api/v1/contract?owner_code=$ownerCode&jenis_pengiriman=FCL&port_asal=$portAsal&port_tujuan=$portTujuan&uoc_asal=$uocAsal&uoc_tujuan=$uocTujuan&container_size=$containerSize');
      // final response = await dio.get(
      //     'api/v1/contract?owner_code=$ownerCode&jenis_pengiriman=FCL&port_asal=$portAsal&port_tujuan=$portTujuan&uoc_asal=$kotaAsal&uoc_tujuan=$kotaTujuan&container_size=$containerSize');
      // Log the entire response
      log.i("Full Response: ${response.toString()}");
      log.i("Response status code: ${response.statusCode}");

      if (response.statusCode == 200) {
        if (response.data is List) {
          // Map the response data to your model
          listContract = (response.data as List)
              .map((jsonItem) => ContractAccesses.fromJson(jsonItem))
              .toList();
        } else {
          log.e('Unexpected response format: ${response.data}');
        }
      } else {
        throw Exception('Failed to load container size');
      }
    } on DioException catch (e) {
      log.e('DioException occurred: $e');
      if (e.response != null) {
        log.e('Dio response: ${e.response}');
      }
    } catch (e) {
      log.e('Unexpected error: $e');
    }

    return listContract;
  }
}

//LOG
class LogNiagaServiceImpl15 implements LogNiagaService15 {
  Future<String> getFullUrl(String portAsal, String portTujuan, String uocAsal,
      String uocTujuan, int containerSize) async {
    final ownerCode = await storage.read(
          key: AuthKey.ownerCode.toString(),
          aOptions: const AndroidOptions(encryptedSharedPreferences: true),
        ) ??
        ''; // Assign empty string if null

    final endpoint =
        'api/v1/contract?owner_code=$ownerCode&jenis_pengiriman=FCL&port_asal=$portAsal&port_tujuan=$portTujuan&uoc_asal=$uocAsal&uoc_tujuan=$uocTujuan&container_size=$containerSize';
    return '${dio.options.baseUrl}$endpoint';
  }

  final log = getLogger('LogNiagaServiceImpl15');
  final Dio dio;
  final FlutterSecureStorage storage;

  LogNiagaServiceImpl15({
    required this.dio,
    required this.storage,
  });

  @override
  Future<LogNiagaAccesses> logNiaga(String portAsal, String portTujuan,
      String uocAsal, String uocTujuan, int containerSize) async {
    final sysdate =
        DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(DateTime.now().toUtc());

    log.i('Formatted sysdate: $sysdate');

    try {
      final fullUrl = await getFullUrl(
          portAsal, portTujuan, uocAsal, uocTujuan, containerSize);
      log.i('Full URL Log Contract FCL: $fullUrl');

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
