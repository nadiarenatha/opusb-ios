import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/daftar-pesanan/ulasan_service.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';

import '../../../model/niaga/daftar-pesanan/ulasan.dart';
import 'package:intl/intl.dart';

class UlasanServiceImpl implements UlasanService {
  final log = getLogger('UlasanServiceImpl');
  final Dio dio;
  final FlutterSecureStorage storage;

  UlasanServiceImpl({
    required this.dio,
    required this.storage,
  });

  @override
  Future<UlasanAccesses> ulasanPesanan(
      int userId,
      String orderNumber,
      String email,
      int rating,
      String customerFeedback,
      String createdDate,
      String createdBy) async {
    final sysdate =
        DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(DateTime.now().toUtc());
    log.i('Formatted sysdate: $sysdate');

    try {
      log.i('Making API request to post ulasan...');

      final response = await dio.post('bhp-order-feedbacks', data: {
        'userId': userId,
        'orderNumber': orderNumber,
        'email': email,
        'rating': rating,
        'customerFeedback': customerFeedback,
        'niagaFeedback': null,
        'createdBy': createdBy,
        'createdDate': sysdate,
        'activated': true,
      });

      log.i("Full Response: ${response.toString()}");
      log.i("Response status code: ${response.statusCode}");

      if (response.statusCode == 201) {
        // Parse response data into UlasanAccesses object
        final ulasanAccesses = UlasanAccesses.fromJson(response.data);
        return ulasanAccesses;
      } else {
        throw Exception(
            'Failed to load ulasan. Status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      log.e('DioException occurred: $e');
      if (e.response != null) {
        log.e('Dio response: ${e.response}');
        throw Exception('API Error: ${e.response?.data['message']}');
      }
      throw Exception('Unexpected network error occurred');
    } catch (e) {
      log.e('Unexpected error: $e');
      throw Exception('Unexpected error: $e');
    }
  }
}
