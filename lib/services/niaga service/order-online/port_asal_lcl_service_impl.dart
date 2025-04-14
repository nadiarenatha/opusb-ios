import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/order-online/port_asal_lcl_service.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';
import '../../../model/niaga/log_niaga.dart';
import '../../../model/niaga/port_asal_fcl.dart';
import 'package:intl/intl.dart';

class PortAsalLCLServiceImpl implements PortAsalLCLService {
  final log = getLogger('PortAsalLCLServiceImpl');
  final Dio dio;
  final FlutterSecureStorage storage;

  PortAsalLCLServiceImpl({
    required this.dio,
    required this.storage,
  });

  @override
  Future<List<PortAsalFCLAccesses>> getPortAsalLCL() async {
    List<PortAsalFCLAccesses> listPortAsal = [];

    try {
      log.i('Making API request to get port asal lcl...');
      log.i('api/v1/port/order?jenis_port=ASAL&jenis_pengiriman=LCL');

      final response = await dio
          .get('api/v1/port/order?jenis_port=ASAL&jenis_pengiriman=LCL');

      // Log the full response for debugging
      log.i("Full Response: ${response.toString()}");
      log.i("Response status code: ${response.statusCode}");

      // Check if response is successful
      if (response.statusCode == 200) {
        final List<dynamic> responseData = response.data;

        listPortAsal = responseData
            .map((json) => PortAsalFCLAccesses.fromJson(json))
            .toList();

        log.i('Parsed Port Asal LCL List: $listPortAsal');
      } else {
        throw Exception('Failed to load port asal lcl');
      }
    } on DioException catch (e) {
      log.e('DioException occurred: $e');
      if (e.response != null) {
        log.e('Dio response: ${e.response}');
      }
    } catch (e) {
      log.e('Unexpected error: $e');
    }

    return listPortAsal;
  }
}

class LogNiagaServiceImpl26 implements LogNiagaService26 {
  Future<String> getFullUrl() async {
    const endpoint = 'v1/port/order?jenis_port=ASAL&jenis_pengiriman=LCL';
    return '${dio.options.baseUrl}$endpoint';
  }

  final log = getLogger('LogNiagaServiceImpl26');
  final Dio dio;
  final FlutterSecureStorage storage;

  LogNiagaServiceImpl26({
    required this.dio,
    required this.storage,
  });

  @override
  Future<LogNiagaAccesses> logNiaga() async {
    final sysdate =
        DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(DateTime.now().toUtc());

    log.i('Formatted sysdate: $sysdate');

    try {
      final fullUrl = await getFullUrl();
      log.i('Full URL Log Port Asal LCL: $fullUrl');

      final response = await dio.post(
        'https://dev-apps.niaga-logistics.com/api/bhp-activity-logs',
        data: {
          'actionUrl': fullUrl,
          'requestBy': 'mobile',
          'activityLogTime': sysdate,
        },
        options: Options(
          headers: {'Content-Type': 'application/json'},
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
