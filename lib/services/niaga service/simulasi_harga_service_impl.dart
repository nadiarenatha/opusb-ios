import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/simulasi_harga_service.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';
import '../../model/niaga/log_niaga.dart';
import '../../model/niaga/simulasi_harga.dart';
import 'package:intl/intl.dart';

class SimulasiHargaServiceImpl implements SimulasiHargaService {
  final log = getLogger('SimulasiHargaServiceImpl');
  final Dio dio;
  final FlutterSecureStorage storage;

  SimulasiHargaServiceImpl({
    required this.dio,
    required this.storage,
  });

  @override
  Future<List<SimulasiHargaAccesses>> getSimulasiHarga(
      String portAsal, String portTujuan, String jenisPengiriman) async {
    List<SimulasiHargaAccesses> listSimulasiHarga = [];

    try {
      log.i('Making API request to get simulasi harga...');
      log.i(
          'api/v1/simulasi/harga?port_asal=$portAsal&port_tujuan=$portTujuan&jenis_pengiriman=$jenisPengiriman');

      final response = await dio.get(
          'api/v1/simulasi/harga?port_asal=$portAsal&port_tujuan=$portTujuan&jenis_pengiriman=$jenisPengiriman');

      // Log the full response for debugging
      log.i("Full Response: ${response.toString()}");
      log.i("Response status code: ${response.statusCode}");

      // Check if response is successful
      if (response.statusCode == 200) {
        // Ensure the response data is a list
        if (response.data is List) {
          // Convert the response data into a list of SimulasiHargaAccesses
          final List<dynamic> responseData = response.data;

          // Parse JSON into a list of SimulasiHargaAccesses objects
          listSimulasiHarga = responseData
              .map((json) => SimulasiHargaAccesses.fromJson(json))
              .toList();

          // Log the parsed data
          log.i('Simulasi Harga List: $listSimulasiHarga');
        } else {
          throw Exception('Unexpected response data format');
        }
      } else {
        throw Exception('Failed to load simulasi harga');
      }
    } on DioException catch (e) {
      log.e('DioException occurred: $e');
      if (e.response != null) {
        log.e('Dio response: ${e.response}');
      }
    } catch (e) {
      log.e('Unexpected error: $e');
    }

    return listSimulasiHarga;
  }
}

class LogNiagaServiceImpl3 implements LogNiagaService3 {
  Future<String> getFullUrl(
      String portAsal, String portTujuan, String jenisPengiriman) async {
    final endpoint =
        'v1/simulasi/harga?port_asal=$portAsal&port_tujuan=$portTujuan&jenis_pengiriman=$jenisPengiriman';
    return '${dio.options.baseUrl}$endpoint';
  }
  
  final log = getLogger('LogNiagaServiceImpl2');
  final Dio dio;
  final FlutterSecureStorage storage;

  LogNiagaServiceImpl3({
    required this.dio,
    required this.storage,
  });

   @override
  Future<LogNiagaAccesses> logNiaga(
      String portAsal, String portTujuan, String jenisPengiriman) async {
    final sysdate =
        DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(DateTime.now().toUtc());

    log.i('Formatted sysdate: $sysdate');

    try {
      final fullUrl = await getFullUrl(portAsal, portTujuan, jenisPengiriman);
      log.i('Full URL Log Simulasi Harga: $fullUrl');

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