import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/syarat-ketentuan/syarat_ketentuan_service.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';
import '../../../model/niaga/syarat_ketentuan.dart';

class SyaratKetentuanServiceImpl implements SyaratKetentuanService {
  final log = getLogger('SyaratKetentuanServiceImpl');
  final Dio dio;
  final FlutterSecureStorage storage;

  SyaratKetentuanServiceImpl({
    required this.dio,
    required this.storage,
  });

  @override
  Future<List<SyaratKetentuanAccesses>> getSyaratKetentuan(bool active) async {
    List<SyaratKetentuanAccesses> listSyaratKetentuan = [];

    try {
      log.i('Making API request to get syarat ketentuan...');
      log.i(
          'ad-reference-lists/find-by-value/termCondition?active.equals=${active.toString()}');

      final response = await dio.post(
          'ad-reference-lists/find-by-value/termCondition?active.equals=${active.toString()}');

      log.i("Full Response: ${response.toString()}");
      log.i("Response status code: ${response.statusCode}");

      if (response.statusCode == 200) {
        final List<dynamic> responseData = response.data;
        listSyaratKetentuan = responseData
            .map((json) => SyaratKetentuanAccesses.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to load syarat ketentuan');
      }
    } on DioException catch (e) {
      log.e('DioException occurred: ${e.type} - ${e.message}');
      if (e.response != null) {
        log.e('Dio response: ${e.response}');
      }
    } catch (e) {
      log.e('Unexpected error: $e');
    }

    return listSyaratKetentuan;
  }
}
