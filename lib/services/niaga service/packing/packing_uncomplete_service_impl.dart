import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/packing/packing_uncomplete_service.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';
import 'dart:convert';

import '../../../model/niaga/packing_niaga.dart';
import '../../../shared/constants.dart';

class PackingNiagaUnCompleteServiceImpl implements PackingNiagaUnCompleteService {
  final log = getLogger('PackingNiagaUnCompleteServiceImpl');
  final Dio dio;
  final FlutterSecureStorage storage;

  PackingNiagaUnCompleteServiceImpl({
    required this.dio,
    required this.storage,
  });

  @override
  Future<List<PackingNiagaAccesses>> getPackingNiagaUnComplete({int? page}) async {
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

      String url =
          'api/v1/packing-list/?email=$email&page=$page&size=5&status=UN_COMPLETE';

      if (ownerCode != null && ownerCode != "ONLINE") {
        url += '&owner_code=$ownerCode';
      }

      log.i('Constructed API request URL packing complete: $url');

      log.i('Making API request to get packing Uncomplete with ownerCode: $ownerCode');
      log.i('Making API request to get Packing Uncomplete...');

      // final response = await dio.get(
      //     'api/v1/packing-list/?owner_code=$ownerCode&page=$page&size=5&status=UN_COMPLETE'
      //     );

      final response = await dio.get(
        url,
        options: Options(
          responseType: ResponseType.json,
        ),
      );

      log.i("Full Response: ${response.toString()}");
      log.i("Response status code: ${response.statusCode}");

      if (response.statusCode == 200) {
        // Deserialize the JSON response to PackingNiagaAccesses model
        final PackingNiagaAccesses data =
            PackingNiagaAccesses.fromJson(response.data);
        listPackingNiagaUncomplete.add(data); // Add new data to the list
      } else {
        throw Exception('Failed to load packing uncompleted');
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
