import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';
import '../../model/niaga/dashboard/kantor_cabang.dart';
import '../../model/niaga/log_niaga.dart';
import 'package:intl/intl.dart';
import '../../shared/constants.dart';
import 'kantor_cabang_service.dart';

class KantorCabangServiceImpl implements KantorCabangService {
  final log = getLogger('KantorCabangServiceImpl');
  final Dio dio;
  final FlutterSecureStorage storage;

  KantorCabangServiceImpl({
    required this.dio,
    required this.storage,
  });

  @override
  Future<List<KantorCabangAccesses>> getKantorCabang() async {
    List<KantorCabangAccesses> listKantorCabang = [];

    try {
      log.i('Making API request to get Kantor Cabang...');

      final response = await dio.get(
          'api/v1/dashboard/cabang');

      // Log the full response for debugging
      log.i("Full Response: ${response.toString()}");
      log.i("Response status code: ${response.statusCode}");

      // Check if response is successful
      if (response.statusCode == 200) {

        List<dynamic> data = response.data;

        listKantorCabang =
            data.map((json) => KantorCabangAccesses.fromJson(json)).toList();

        log.i('Successfully loaded ${listKantorCabang.length} Kantor Cabang.');
      } else {
        throw Exception('Failed to load kantor cabang');
      }
    } on DioException catch (e) {
      log.e('DioException occurred: $e');
      if (e.response != null) {
        log.e('Dio response: ${e.response}');
      }
    } catch (e) {
      log.e('Unexpected error: $e');
    }

    return listKantorCabang;
  }
}

class LogNiagaServiceImpl2 implements LogNiagaService2 {
  Future<String> getFullUrl() async {

    final endpoint =
        'v1/dashboard/cabang';
    return '${dio.options.baseUrl}$endpoint';
  }
  final log = getLogger('LogNiagaServiceImpl2');
  final Dio dio;
  final FlutterSecureStorage storage;

  LogNiagaServiceImpl2({
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
      log.i('Full URL Log Kantor Cabang: $fullUrl');

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