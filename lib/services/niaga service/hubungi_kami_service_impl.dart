import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';

import '../../model/niaga/dashboard/hubungi_kami.dart';
import '../../model/niaga/log_niaga.dart';
import '../../shared/constants.dart';
import 'hubungi_kami_service.dart';
import 'package:intl/intl.dart';

class HubungiKamiServiceImpl implements HubungiKamiService {
  final log = getLogger('HubungiKamiServiceImpl');
  final Dio dio;
  final FlutterSecureStorage storage;

  HubungiKamiServiceImpl({
    required this.dio,
    required this.storage,
  });

  

  @override
  Future<List<HubungiKamiAccesses>> getHubungiKami() async {
    List<HubungiKamiAccesses> listHubungiKami = [];

    try {
      log.i('Making API request to get data hubungi kami complete...');

      final response = await dio.get('api/v1/dashboard/hubungi_kami');

      log.i("Full Response: ${response.toString()}");
      log.i("Response status code: ${response.statusCode}");

      if (response.statusCode == 200) {
        final List<dynamic> responseData = response.data;
        listHubungiKami = responseData
            .map((item) => HubungiKamiAccesses.fromJson(item))
            .toList();

        log.i(
            "Parsed ${listHubungiKami.length} records of HubungiKamiAccesses");
      } else {
        throw Exception('Failed to load packing');
      }
    } on DioException catch (e) {
      log.e('DioException occurred: $e');
      if (e.response != null) {
        log.e('Dio response: ${e.response}');
      }
    } catch (e) {
      log.e('Unexpected error: $e');
    }

    return listHubungiKami;
  }
}

class LogNiagaServiceImpl4 implements LogNiagaService4 {
  Future<String> getFullUrl() async {
    const endpoint = 'v1/dashboard/hubungi_kami';
    return '${dio.options.baseUrl}$endpoint';
  }
  final log = getLogger('LogNiagaServiceImpl');
  final Dio dio;
  final FlutterSecureStorage storage;

  LogNiagaServiceImpl4({
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
      log.i('Full URL Log Hubungi Kami: $fullUrl');

      final response = await dio.post(
        'https://dev-apps.niaga-logistics.com/api/bhp-activity-logs',
        data: {
          'actionUrl': fullUrl,
          'requestBy': 'mobile',
          'activityLogTime': sysdate,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json'
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