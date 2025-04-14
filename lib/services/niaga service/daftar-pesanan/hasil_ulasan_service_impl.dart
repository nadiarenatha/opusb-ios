import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';
import '../../../model/niaga/daftar-pesanan/ulasan.dart';
import 'hasil_ulasan_service.dart';

class HasilUlasanServiceImpl implements HasilUlasanService {
  final log = getLogger('HasilUlasanServiceImpl');
  final Dio dio;
  final FlutterSecureStorage storage;

  HasilUlasanServiceImpl({
    required this.dio,
    required this.storage,
  });

  @override
  Future<List<UlasanAccesses>> hasilUlasanPesanan({String? orderNumber}) async {
    List<UlasanAccesses> listHasilUlasan = [];

    try {
      log.i('Making API request to get Ulasan...');
      log.i('bhp-order-feedbacks?orderNumber.equals=$orderNumber');

      final response = await dio.get(
        'bhp-order-feedbacks?orderNumber.equals=$orderNumber',
      );

      // Log the entire response
      log.i("Full Response: ${response.toString()}");
      log.i("Response status code: ${response.statusCode}");

      if (response.statusCode == 200) {
        if (response.data is List) {
          // Deserialize each item in the list into UlasanAccesses
          listHasilUlasan = (response.data as List)
              .map((item) =>
                  UlasanAccesses.fromJson(item as Map<String, dynamic>))
              .toList();
        } else {
          throw Exception('Unexpected response format');
        }
      } else {
        throw Exception('Failed to load hasil ulasan');
      }
    } on DioException catch (e) {
      log.e('DioException occurred: $e');
      if (e.response != null) {
        log.e('Dio response: ${e.response}');
      }
    } catch (e) {
      log.e('Unexpected error: $e');
    }

    return listHasilUlasan;
  }
}
