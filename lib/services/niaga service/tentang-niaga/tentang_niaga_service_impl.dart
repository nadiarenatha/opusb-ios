import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/tentang-niaga/tentang_niaga_service.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';
import '../../../model/niaga/tentang_niaga.dart';

class TentangNiagaServiceImpl implements TentangNiagaService {
  final log = getLogger('TentangNiagaServiceImpl');
  final Dio dio;
  final FlutterSecureStorage storage;

  TentangNiagaServiceImpl({
    required this.dio,
    required this.storage,
  });

  @override
  Future<List<TentangNiagaAccesses>> getTentangNiaga(bool active) async {
    List<TentangNiagaAccesses> listTentangNiaga = [];

    try {
      log.i('Making API request to get tentang niaga...');
      log.i(
          'ad-reference-lists/find-by-value/tentangNiagaLogistics?active.equals=${active.toString()}');

      final response = await dio.post(
          'ad-reference-lists/find-by-value/tentangNiagaLogistics?active.equals=${active.toString()}');

      log.i("Full Response: ${response.toString()}");
      log.i("Response status code: ${response.statusCode}");

      if (response.statusCode == 200) {
        final List<dynamic> responseData = response.data;
        listTentangNiaga = responseData
            .map((json) => TentangNiagaAccesses.fromJson(json))
            .toList();
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

    return listTentangNiaga;
  }
}
