import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/order-online/port_asal_fcl_service.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';
import 'dart:convert';
import '../../../model/niaga/log_niaga.dart';
import '../../../model/niaga/port_asal_fcl.dart';
import '../../../shared/constants.dart';
import 'package:intl/intl.dart';

class PortAsalFCLServiceImpl implements PortAsalFCLService {
  final log = getLogger('PortAsalFCLServiceImpl');
  final Dio dio;
  final FlutterSecureStorage storage;

  PortAsalFCLServiceImpl({
    required this.dio,
    required this.storage,
  });

  Future<String> getFullUrlPortAsalFCL() async {
    const endpoint = 'api/v1/port/order?jenis_port=ASAL&jenis_pengiriman=FCL';
    return '${dio.options.baseUrl}$endpoint';
  }

  Future<String> getFullUrlPortAsalLCL() async {
    const endpoint = 'api/v1/port/order?jenis_port=ASAL&jenis_pengiriman=LCL';
    return '${dio.options.baseUrl}$endpoint';
  }

  @override
  Future<List<PortAsalFCLAccesses>> getPortAsalFCL() async {
    List<PortAsalFCLAccesses> listPortAsal = [];

    const endpoint = 'api/v1/port/order?jenis_port=ASAL&jenis_pengiriman=FCL';

    try {
      log.i('Making API request to get port asal fcl...');

      // final fullUrlPortAsalFCL = '${dio.options.baseUrl}$endpoint';
      // log.i('Constructed Full URL hubungi kami: $fullUrlPortAsalFCL');

      // await storage.write(
      //   key: AuthKey.fullUrlPortAsalFCL.toString(),
      //   value: fullUrlPortAsalFCL.toString(),
      //   aOptions: const AndroidOptions(encryptedSharedPreferences: true),
      // );

      final response = await dio
          .get('api/v1/port/order?jenis_port=ASAL&jenis_pengiriman=FCL');

      // final response = await dio.get(endpoint);

      log.i("Full Response: ${response.toString()}");
      log.i("Response status code: ${response.statusCode}");

      if (response.statusCode == 200) {
        final List<dynamic> responseData = response.data;

        listPortAsal = responseData
            .map((json) => PortAsalFCLAccesses.fromJson(json))
            .toList();

        // Log the parsed data
        log.i('Parsed Port Asal FCL List: $listPortAsal');
      } else {
        throw Exception('Failed to load port asal fcl');
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

  Future<List<PortAsalFCLAccesses>> getPortAsalLCL() async {
    List<PortAsalFCLAccesses> listPortAsal = [];

    // const endpoint = 'api/v1/port/order?jenis_port=ASAL&jenis_pengiriman=LCL';

    try {
      log.i('Making API request to get port asal lcl...');

      // final fullUrlPortAsalLCL = '${dio.options.baseUrl}$endpoint';
      // log.i('Constructed Full URL hubungi kami: $fullUrlPortAsalLCL');

      // await storage.write(
      //   key: AuthKey.fullUrlPortAsalLCL.toString(),
      //   value: fullUrlPortAsalLCL.toString(),
      //   aOptions: const AndroidOptions(encryptedSharedPreferences: true),
      // );

      final response = await dio
          .get('api/v1/port/order?jenis_port=ASAL&jenis_pengiriman=LCL');

      // final response = await dio.get(endpoint);

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

  @override
  Future<LogNiagaAccesses> logNiaga(String actionUrl) async {
    final sysdate =
        DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(DateTime.now().toUtc());

    log.i('Formatted sysdate: $sysdate');
    log.i('actionUrl: $actionUrl');

    try {
      final response = await dio.post(
        'bhp-activity-logs',
        data: {
          'actionUrl': actionUrl,
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
