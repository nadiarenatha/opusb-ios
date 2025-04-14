import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';

import '../../../model/niaga/kebijakan.dart';
import 'kebijakan_service.dart';

class KebijakanPrivasiServiceImpl implements KebijakanPrivasiService {
  final log = getLogger('KebijakanPrivasiServiceImpl');
  final Dio dio;
  final FlutterSecureStorage storage;

  KebijakanPrivasiServiceImpl({
    required this.dio,
    required this.storage,
  });

  @override
  Future<List<KebijakanAccesses>> getKebijakan(bool active) async {
    List<KebijakanAccesses> listKebijakan = [];

    try {
      log.i('Making API request to get kebijakan privasi...');
      log.i(
          'ad-reference-lists/find-by-value/kebijakanPrivasi?active.equals=${active.toString()}');

      final response = await dio.post(
          'ad-reference-lists/find-by-value/kebijakanPrivasi?active.equals=${active.toString()}');

      log.i("Full Response: ${response.toString()}");
      log.i("Response status code: ${response.statusCode}");

      if (response.statusCode == 200) {
        final List<dynamic> responseData = response.data;
        listKebijakan =
            responseData.map((json) => KebijakanAccesses.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load kebijakan privasi');
      }
    } on DioException catch (e) {
      log.e('DioException occurred: ${e.type} - ${e.message}');
      if (e.response != null) {
        log.e('Dio response: ${e.response}');
      }
    } catch (e) {
      log.e('Unexpected error: $e');
    }

    return listKebijakan;
  }
}
