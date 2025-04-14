import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/create-user/syarat_ketentuan_service.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';
import '../../../model/niaga/syarat_create_user.dart';

class SyaratCreateUserServiceImpl implements SyaratCreateUserService {
  final log = getLogger('SyaratCreateUserServiceImpl');
  final Dio dio;
  final FlutterSecureStorage storage;

  SyaratCreateUserServiceImpl({
    required this.dio,
    required this.storage,
  });

  @override
  Future<List<SyaratCreateUserAccesses>> getSyaratCreateUser(
      bool active) async {
    List<SyaratCreateUserAccesses> listSyaratUser = [];

    try {
      log.i('Making API request to get syarat ketentuan create user...');
      log.i(
          'ad-reference-lists/find-by-value/syaratKetentuan?active.equals=${active.toString()}');

      final response = await dio.post(
          'ad-reference-lists/find-by-value/syaratKetentuan?active.equals=${active.toString()}');

      log.i("Full Response: ${response.toString()}");
      log.i("Response status code: ${response.statusCode}");

      if (response.statusCode == 200) {
        final List<dynamic> responseData = response.data;
        listSyaratUser = responseData
            .map((json) => SyaratCreateUserAccesses.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to load syarat create user');
      }
    } on DioException catch (e) {
      log.e('DioException occurred: ${e.type} - ${e.message}');
      if (e.response != null) {
        log.e('Dio response: ${e.response}');
      }
    } catch (e) {
      log.e('Unexpected error: $e');
    }

    return listSyaratUser;
  }
}
