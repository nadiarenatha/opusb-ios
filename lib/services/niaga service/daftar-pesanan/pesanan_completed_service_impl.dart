import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/daftar-pesanan/pesanan_completed_service.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';
import '../../../model/niaga/daftar-pesanan/data_pesanan.dart';
import '../../../shared/constants.dart';

class PesananCompletedServiceImpl implements PesananCompletedService {
  final log = getLogger('PesananCompletedServiceImpl');
  final Dio dio;
  final FlutterSecureStorage storage;

  PesananCompletedServiceImpl({
    required this.dio,
    required this.storage,
  });

  @override
  Future<List<DataPesananAccesses>> getPesananCompleted({int? page}) async {
    List<DataPesananAccesses> listPesananCompleted = [];

    try {
      final email = await storage.read(
        key: AuthKey.email.toString(),
        aOptions: const AndroidOptions(encryptedSharedPreferences: true),
      );

      log.i('Making API request to get daftar pesanan Completed...');
      log.i(
          'Making API request to get daftar pesanan Completed with email = $email');
      log.i('order-summary?email=$email&statusId=SO06&page=$page&size=5');

      final response = await dio.get(
        // 'order-summary?&page=$page&size=5',
        'order-summary?email=$email&statusId=SO06&page=$page&size=5',
      );

      // Log the entire response
      log.i("Full Response: ${response.toString()}");
      log.i("Response status code: ${response.statusCode}");

      if (response.statusCode == 200) {
        // Deserialize the JSON response to DataPesananAccesses model
        final DataPesananAccesses data =
            DataPesananAccesses.fromJson(response.data);
        listPesananCompleted.add(data); // Add new data to the list
      } else {
        throw Exception('Failed to load daftar pesanan completed');
      }
    } on DioException catch (e) {
      log.e('DioException occurred: $e');
      if (e.response != null) {
        log.e('Dio response: ${e.response}');
      }
    } catch (e) {
      log.e('Unexpected error: $e');
    }

    return listPesananCompleted;
  }
}
