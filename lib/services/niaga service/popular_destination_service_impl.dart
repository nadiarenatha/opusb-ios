import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/popular_destination_service.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';
import 'package:intl/intl.dart';

import '../../model/niaga/log_niaga.dart';
import '../../model/niaga/popular_destination.dart';
import '../../shared/constants.dart';

class PopularDestinationServiceImpl implements PopularDestinationService {
  final log = getLogger('PopularDestinationServiceImpl');
  final Dio dio;
  final FlutterSecureStorage storage;

  PopularDestinationServiceImpl({
    required this.dio,
    required this.storage,
  });

  // Future<String> getFullUrl() async {
  //   final ownerCode = await storage.read(
  //         key: AuthKey.ownerCode.toString(),
  //         aOptions: const AndroidOptions(encryptedSharedPreferences: true),
  //       ) ??
  //       ''; // Assign empty string if null

  //   final email = await storage.read(
  //         key: AuthKey.email.toString(),
  //         aOptions: const AndroidOptions(encryptedSharedPreferences: true),
  //       ) ??
  //       ''; // Assign empty string if null

  //   final endpoint =
  //       'api/v1/popular/destination?owner_code=$ownerCode&email=$email';
  //   return '${dio.options.baseUrl}$endpoint';
  // }

  @override
  Future<List<PopularDestinationAccesses>> getPopularDestination() async {
    List<PopularDestinationAccesses> listPopularDestination = [];

    try {
      final ownerCode = await storage.read(
            key: AuthKey.ownerCode.toString(),
            aOptions: const AndroidOptions(encryptedSharedPreferences: true),
          ) ??
          ''; // Assign empty string if null

      final email = await storage.read(
        key: AuthKey.email.toString(),
        aOptions: const AndroidOptions(encryptedSharedPreferences: true),
      );

      log.i(
          'Making API request to get popular destination complete with ownerCode: $ownerCode');
      log.i(
          'Making API request to get popular destination complete with email: $email');

      log.i('Making API request to get popular destination complete...');
      log.i('api/v1/popular/destination?owner_code=$ownerCode&email=$email');

      final response = await dio
          .get('api/v1/popular/destination?owner_code=$ownerCode&email=$email');

      // Log the entire response
      log.i("Full Response: ${response.toString()}");
      log.i("Response status code: ${response.statusCode}");

      if (response.statusCode == 200) {
        // Deserialize the JSON response to PopularDestinationAccesses model
        if (response.data is List) {
          // Map the response data to your model
          listPopularDestination = (response.data as List)
              .map((jsonItem) => PopularDestinationAccesses.fromJson(jsonItem))
              .toList();
        } else {
          log.e('Unexpected response format: ${response.data}');
        }
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

    return listPopularDestination;
  }
}

class LogNiagaServiceImpl implements LogNiagaService {
  Future<String> getFullUrl() async {
    final ownerCode = await storage.read(
          key: AuthKey.ownerCode.toString(),
          aOptions: const AndroidOptions(encryptedSharedPreferences: true),
        ) ?? ''; // Assign empty string if null

    final email = await storage.read(
          key: AuthKey.email.toString(),
          aOptions: const AndroidOptions(encryptedSharedPreferences: true),
        ) ?? ''; // Assign empty string if null

    final endpoint =
        'v1/popular/destination?owner_code=$ownerCode&email=$email';
    return '${dio.options.baseUrl}$endpoint';
  }
  final log = getLogger('LogNiagaServiceImpl');
  final Dio dio;
  final FlutterSecureStorage storage;

  LogNiagaServiceImpl({
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
      log.i('Full URL Log Popular Destination: $fullUrl');

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