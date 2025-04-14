import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';
import '../../../model/niaga/jadwal-kapal/jadwal_kapal.dart';
import '../../../model/niaga/log_niaga.dart';
import 'jadwal_kapal_service.dart';
import 'package:intl/intl.dart';

class JadwalKapalNiagaServiceImpl implements JadwalKapalNiagaService {
  final log = getLogger('JadwalKapalNiagaServiceImpl');
  final Dio dio;
  final FlutterSecureStorage storage;

  JadwalKapalNiagaServiceImpl({
    required this.dio,
    required this.storage,
  });

  @override
  Future<List<JadwalKapalNiagaAccesses>> getJadwalKapalNiaga(
      String portAsal, String portTujuan, String etdFrom) async {
    List<JadwalKapalNiagaAccesses> listJadwalKapal = [];

    portAsal = portAsal.isEmpty ? '' : portAsal;
    portTujuan = portTujuan.isEmpty ? '' : portTujuan;
    etdFrom = etdFrom.isEmpty ? '' : etdFrom;

    try {
      log.i(
          'Making API request to get jadwal Kapal Niaga based on Port Asal = $portAsal, Port Tujuan = $portTujuan, ETD From = $etdFrom...');

      log.i(
          'Ini link url nya : api/v1/jadwal/kapal?port_asal=$portAsal&port_tujuan=$portTujuan&etd_from=$etdFrom');

      final response = await dio
          // .get('api/v1/jadwal/kapal?port_asal=SBY&port_tujuan=MKS&etd_from=14%2F10%2F2024');
          .get(
              'api/v1/jadwal/kapal?port_asal=$portAsal&port_tujuan=$portTujuan&etd_from=$etdFrom');

      // Log the full response for debugging
      log.i("Full Response: ${response.toString()}");
      log.i("Response status code: ${response.statusCode}");

      // Check if response is successful
      if (response.statusCode == 200) {
        listJadwalKapal = (response.data as List)
            .map((json) => JadwalKapalNiagaAccesses.fromJson(json))
            .toList();

        log.i('Parsed ${listJadwalKapal.length} jadwal kapal niaga.');
      } else {
        throw Exception('Failed to load jadwal Kapal Niaga');
      }
    } on DioException catch (e) {
      log.e('DioException occurred: $e');
      if (e.response != null) {
        log.e('Dio response: ${e.response}');
      }
    } catch (e) {
      log.e('Unexpected error: $e');
    }

    return listJadwalKapal;
  }
}

class LogNiagaServiceImpl5 implements LogNiagaService5 {
  final log = getLogger('LogNiagaServiceImpl5');
  final Dio dio;
  final FlutterSecureStorage storage;

  LogNiagaServiceImpl5({
    required this.dio,
    required this.storage,
  });

  Future<String> getFullUrl(
      String portAsal, String portTujuan, String etdFrom) async {
    portAsal = portAsal.isEmpty ? '' : portAsal;
    portTujuan = portTujuan.isEmpty ? '' : portTujuan;
    etdFrom = etdFrom.isEmpty ? '' : etdFrom;

    final endpoint =
        'api/v1/jadwal/kapal?port_asal=$portAsal&port_tujuan=$portTujuan&etd_from=$etdFrom';
    return '${dio.options.baseUrl}$endpoint';
  }

  @override
  Future<LogNiagaAccesses> logNiaga(
      String portAsal, String portTujuan, String etdFrom) async {
    final sysdate =
        DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(DateTime.now().toUtc());

    log.i('Formatted sysdate: $sysdate');

    try {
      final fullUrl = await getFullUrl(portAsal, portTujuan, etdFrom);
      log.i('Full URL Log Jadwal Kapal: $fullUrl');

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
