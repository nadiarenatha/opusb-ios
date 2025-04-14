import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/packing/search_packing_uncomplete_service.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';

import '../../../model/niaga/log_niaga.dart';
import '../../../model/niaga/packing_niaga.dart';
import '../../../shared/constants.dart';
import 'package:intl/intl.dart';

class SearchUncompletedPackingServiceImpl
    implements SearchUncompletedPackingService {
  final log = getLogger('SearchUncompletedPackingServiceImpl');
  final Dio dio;
  final FlutterSecureStorage storage;

  SearchUncompletedPackingServiceImpl({
    required this.dio,
    required this.storage,
  });

  //UN COMPLETE
  @override
  Future<List<PackingNiagaAccesses>> searchPackingUnComplete(
      {int? page,
      String? noPL,
      String? containerNo,
      String? asal,
      String? tujuan,
      String? vesselName}) async {
    noPL ??= '';
    containerNo ??= '';
    asal ??= '';
    tujuan ??= '';
    vesselName ??= '';

    List<PackingNiagaAccesses> listPackingNiagaUncomplete = [];

    try {
      final ownerCode = await storage.read(
        key: AuthKey.ownerCode.toString(),
        aOptions: const AndroidOptions(encryptedSharedPreferences: true),
      );
      final email = await storage.read(
        key: AuthKey.email.toString(),
        aOptions: const AndroidOptions(encryptedSharedPreferences: true),
      );

      log.i(
          'Making API request to get search packing Complete with ownerCode: $ownerCode');
      log.i('Making API request to get search Packing Complete...');
      // log.i('api/v1/packing-list/?owner_code=$ownerCode&page=$page&size=5&status=UN_COMPLETE&search_no_pl=$noPL&no_container=$containerNo&port_asal=$asal&port_tujuan=$tujuan&nama_kapal=$vesselName');

      String url =
          'api/v1/packing-list/?email=$email&page=$page&size=5&status=UN_COMPLETE&search_no_pl=$noPL&no_container=$containerNo&port_asal=$asal&port_tujuan=$tujuan&nama_kapal=$vesselName';

      if (ownerCode != null && ownerCode != "ONLINE") {
        url += '&owner_code=$ownerCode';
      }

      log.i('url Packing UnComplete nya: $url');

      // final response = await dio.get(
      //     'api/v1/packing-list/?owner_code=$ownerCode&page=$page&size=5&status=UN_COMPLETE&search_no_pl=$noPL&no_container=$containerNo&port_asal=$asal&port_tujuan=$tujuan&nama_kapal=$vesselName');

      final response = await dio.get(
        url,
        options: Options(
          responseType: ResponseType.json,
        ),
      );

      // Log the entire response
      log.i("Full Response Uncomplete: ${response.toString()}");
      log.i("Response status code Uncomplete: ${response.statusCode}");

      if (response.statusCode == 200) {
        // Deserialize the JSON response to PackingNiagaAccesses model
        final PackingNiagaAccesses data =
            PackingNiagaAccesses.fromJson(response.data);
        listPackingNiagaUncomplete.add(data); // Add new data to the list
      } else {
        throw Exception('Failed to load search packing completed');
      }
    } on DioException catch (e) {
      log.e('DioException occurred: $e');
      if (e.response != null) {
        log.e('Dio response: ${e.response}');
      }
    } catch (e) {
      log.e('Unexpected error: $e');
    }

    return listPackingNiagaUncomplete;
  }
}

//LOG
class LogNiagaServiceImpl23 implements LogNiagaService23 {
  final log = getLogger('LogNiagaServiceImpl23');
  final Dio dio;
  final FlutterSecureStorage storage;

  LogNiagaServiceImpl23({
    required this.dio,
    required this.storage,
  });

  Future<String> getFullUrl(int? page, String? noPL, String? containerNo,
      String? asal, String? tujuan, String? vesselName) async {
    noPL ??= '';
    containerNo ??= '';
    asal ??= '';
    tujuan ??= '';
    vesselName ??= '';

    final email = await storage.read(
      key: AuthKey.email.toString(),
      aOptions: const AndroidOptions(encryptedSharedPreferences: true),
    );

    final ownerCode = await storage.read(
          key: AuthKey.ownerCode.toString(),
          aOptions: const AndroidOptions(encryptedSharedPreferences: true),
        ) ??
        'ONLINE';

    String endpoint =
        'api/v1/packing-list/?email=$email&page=$page&size=5&status=UN_COMPLETE&search_no_pl=$noPL&no_container=$containerNo&port_asal=$asal&port_tujuan=$tujuan&nama_kapal=$vesselName';
    if (ownerCode != 'ONLINE') {
      endpoint += '&owner_code=$ownerCode';
    }
    return '${dio.options.baseUrl}$endpoint';
  }

  @override
  Future<LogNiagaAccesses> logNiaga(
      int? page,
      String? noPL,
      String? containerNo,
      String? asal,
      String? tujuan,
      String? vesselName) async {
    final sysdate =
        DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(DateTime.now().toUtc());

    log.i('Formatted sysdate: $sysdate');

    try {
      final fullUrl =
          await getFullUrl(page, noPL, containerNo, asal, tujuan, vesselName);
      log.i('Full URL Log Packing UnComplete: $fullUrl');

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
