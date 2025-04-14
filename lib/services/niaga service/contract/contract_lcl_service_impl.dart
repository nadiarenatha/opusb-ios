import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';

import '../../../model/niaga/contract_lcl.dart';
import '../../../model/niaga/log_niaga.dart';
import '../../../shared/constants.dart';
import 'contract_lcl_service.dart';
import 'package:intl/intl.dart';

class ContractLCLServiceImpl implements ContractLCLService {
  final log = getLogger('ContractLCLServiceImpl');
  final Dio dio;
  final FlutterSecureStorage storage;

  ContractLCLServiceImpl({
    required this.dio,
    required this.storage,
  });

  @override
  Future<List<ContractLCLAccesses>> getContractLCL(
      String portAsal, String portTujuan, String uocTujuan) async {
    List<ContractLCLAccesses> listContractLCL = [];

    try {
      final ownerCode = await storage.read(
        key: AuthKey.ownerCode.toString(),
        aOptions: const AndroidOptions(encryptedSharedPreferences: true),
      );

      print('owner code nya: $ownerCode');

      if (ownerCode == null || ownerCode.isEmpty) {
        log.e('Owner code is null or empty');
        throw Exception('Owner code is null or empty');
      }

      final endpoint =
          'api/v1/contract?owner_code=$ownerCode&jenis_pengiriman=LCL&port_asal=$portAsal&port_tujuan=$portTujuan&uoc_tujuan=$uocTujuan';
      log.i('Making API request to: $endpoint');

      final response = await dio.get(endpoint);
      log.i('response nya: $response');
      log.i('Response status code: ${response.statusCode}');

      if (response.statusCode == 404) {
        final message = (response.data is Map<String, dynamic> &&
                response.data['message'] != null)
            ? response.data['message']
            : 'Not Found';
        log.e('Error 404: $message');
        throw Exception(message);
      } else if (response.statusCode != 200) {
        log.e('Error: ${response.statusCode}');
        throw Exception('Error ${response.statusCode}');
      }

      if (response.data is List) {
        listContractLCL = (response.data as List)
            .map((jsonItem) => ContractLCLAccesses.fromJson(jsonItem))
            .toList();
      } else if (response.data is Map) {
        log.e('Unexpected response format: ${response.data}');
        throw Exception(
            'Unexpected response format: Expected List but got Map');
      } else {
        log.e('Empty or invalid response format');
        throw Exception('Received invalid response from the server');
      }
    } catch (e) {
      log.e('Unexpected error: $e');
      throw Exception('Unexpected error: $e');
    }

    return listContractLCL;
  }
}

//LOG
class LogNiagaServiceImpl27 implements LogNiagaService27 {
  final log = getLogger('LogNiagaServiceImpl27');
  final Dio dio;
  final FlutterSecureStorage storage;

  LogNiagaServiceImpl27({
    required this.dio,
    required this.storage,
  });

  Future<String> getFullUrl(
      String portAsal, String portTujuan, String uocTujuan) async {
    final ownerCode = await storage.read(
          key: AuthKey.ownerCode.toString(),
          aOptions: const AndroidOptions(encryptedSharedPreferences: true),
        ) ??
        'ONLINE';

    String endpoint =
        'v1/contract?owner_code=$ownerCode&jenis_pengiriman=LCL&port_asal=$portAsal&port_tujuan=$portTujuan&uoc_tujuan=$uocTujuan';
    return '${dio.options.baseUrl}$endpoint';
  }

  @override
  Future<LogNiagaAccesses> logNiaga(
      String portAsal, String portTujuan, String uocTujuan) async {
    final sysdate =
        DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(DateTime.now().toUtc());

    log.i('Formatted sysdate: $sysdate');

    try {
      final fullUrl = await getFullUrl(portAsal, portTujuan, uocTujuan);
      log.i('Full URL Log Contract LCL: $fullUrl');

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
