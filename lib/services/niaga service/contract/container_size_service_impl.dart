import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';
import 'package:intl/intl.dart';

import '../../../model/niaga/container_size.dart';
import '../../../model/niaga/log_niaga.dart';
import 'container_size_service.dart';

class ContainerSizeServiceImpl implements ContainerSizeService {
  final log = getLogger('ContainerSizeServiceImpl');
  final Dio dio;
  final FlutterSecureStorage storage;

  ContainerSizeServiceImpl({
    required this.dio,
    required this.storage,
  });

  @override
  Future<List<ContainerSizeAccesses>> getContainerSize() async {
    List<ContainerSizeAccesses> listContainerSize = [];

    try {
      log.i('Making API request to get container size...');

      final response = await dio.get('api/v1/container/size/');
      // Log the entire response
      log.i("Full Response: ${response.toString()}");
      log.i("Response status code: ${response.statusCode}");

      if (response.statusCode == 200) {
        if (response.data is List) {
          // Map the response data to your model
          listContainerSize = (response.data as List)
              .map((jsonItem) => ContainerSizeAccesses.fromJson(jsonItem))
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

    return listContainerSize;
  }
}

//LOG
class LogNiagaServiceImpl14 implements LogNiagaService14 {
  Future<String> getFullUrl() async {
    const endpoint = 'v1/container/size/';
    return '${dio.options.baseUrl}$endpoint';
  }
  final log = getLogger('LogNiagaServiceImpl');
  final Dio dio;
  final FlutterSecureStorage storage;

  LogNiagaServiceImpl14({
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
      log.i('Full URL Log Container Size: $fullUrl');

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