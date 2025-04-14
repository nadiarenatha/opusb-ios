import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';
import '../../model/niaga/alamat_muat_lcl.dart';
import '../../model/niaga/log_niaga.dart';
import 'alamat_muat_lcl_service.dart';
import 'package:intl/intl.dart';

class AlamatMuatLCLServiceImpl implements AlamatMuatLCLService {
  final log = getLogger('AlamatMuatLCLServiceImpl');
  final Dio dio;
  final FlutterSecureStorage storage;

  AlamatMuatLCLServiceImpl({
    required this.dio,
    required this.storage,
  });

  @override
  Future<List<AlamatMuatLCLAccesses>> getalamatMuatLCL(String portCode) async {
    List<AlamatMuatLCLAccesses> listalamatMuatLCL = [];

    try {
      log.i('Making API request to get alamat muat LCL...');

      log.i('api/v1/warehouse?port_code=$portCode');

      final response = await dio.get('api/v1/warehouse/?port_code=$portCode');

      log.i("Full Response: ${response.toString()}");
      log.i("Response status code: ${response.statusCode}");

      if (response.statusCode == 200) {
        if (response.data is List) {
          // Map the response data to your model
          listalamatMuatLCL = (response.data as List)
              .map((jsonItem) => AlamatMuatLCLAccesses.fromJson(jsonItem))
              .toList();
        } else {
          log.e('Unexpected response format: ${response.data}');
        }
      } else {
        throw Exception('Failed to load alamat muat lcl');
      }
    } on DioException catch (e) {
      log.e('DioException occurred: $e');
      if (e.response != null) {
        log.e('Dio response: ${e.response}');
      }
    } catch (e) {
      log.e('Unexpected error: $e');
    }

    return listalamatMuatLCL;
  }
}

//LOG
class LogNiagaServiceImpl16 implements LogNiagaService16 {
  Future<String> getFullUrl(String portCode) async {

    final endpoint = 'v1/warehouse?port_code=$portCode';
    return '${dio.options.baseUrl}$endpoint';
  }

  final log = getLogger('LogNiagaServiceImpl16');
  final Dio dio;
  final FlutterSecureStorage storage;

  LogNiagaServiceImpl16({
    required this.dio,
    required this.storage,
  });

  @override
  Future<LogNiagaAccesses> logNiaga(String portCode) async {
    final sysdate =
        DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(DateTime.now().toUtc());

    log.i('Formatted sysdate: $sysdate');

    try {
      final fullUrl = await getFullUrl(portCode);
      log.i('Full URL Log Alamat Muat LCL: $fullUrl');

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
