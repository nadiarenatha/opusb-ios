import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/contract/uom_service.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';
import 'package:intl/intl.dart';

import '../../../model/niaga/log_niaga.dart';
import '../../../model/niaga/uom.dart';
import '../../../shared/constants.dart';

class UOMServiceImpl implements UOMService {
  final log = getLogger('UOMServiceImpl');
  final Dio dio;
  final FlutterSecureStorage storage;

  UOMServiceImpl({
    required this.dio,
    required this.storage,
  });

  @override
  Future<List<UOMAccesses>> getUOM() async {
    List<UOMAccesses> listUOM = [];

    try {
      final ownerCode = await storage.read(
        key: AuthKey.ownerCode.toString(),
        aOptions: const AndroidOptions(encryptedSharedPreferences: true),
      );

      log.i('Making API request to get uom...');
      log.i('Making API request to get uom with owner code: $ownerCode');

      final response = await dio.get('api/v1/jenis/satuan?owner=$ownerCode');

      log.i("Full Response: ${response.toString()}");
      log.i("Response status code: ${response.statusCode}");

      if (response.statusCode == 200) {
        if (response.data is List) {
          // Map the response data to your model
          listUOM = (response.data as List)
              .map((jsonItem) => UOMAccesses.fromJson(jsonItem))
              .toList();
        } else {
          log.e('Unexpected response format: ${response.data}');
        }
      } else {
        throw Exception('Failed to load uom');
      }
    } on DioException catch (e) {
      log.e('DioException occurred: $e');
      if (e.response != null) {
        log.e('Dio response: ${e.response}');
      }
    } catch (e) {
      log.e('Unexpected error: $e');
    }

    return listUOM;
  }
}

class LogNiagaServiceImpl17 implements LogNiagaService17 {
  Future<String> getFullUrl() async {
    final ownerCode = await storage.read(
      key: AuthKey.ownerCode.toString(),
      aOptions: const AndroidOptions(encryptedSharedPreferences: true),
    );

    final endpoint = 'v1/jenis/satuan?owner=$ownerCode';
    return '${dio.options.baseUrl}$endpoint';
  }

  final log = getLogger('LogNiagaServiceImpl17');
  final Dio dio;
  final FlutterSecureStorage storage;

  LogNiagaServiceImpl17({
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
      log.i('Full URL Log UOM: $fullUrl');

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
