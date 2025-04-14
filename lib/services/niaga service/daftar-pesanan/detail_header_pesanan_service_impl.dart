import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';
import '../../../model/niaga/daftar-pesanan/detail_header.dart';
import 'detail_header_pesanan_service.dart';

class DetailPesananHeaderServiceImpl implements DetailPesananHeaderService {
  final log = getLogger('DetailPesananHeaderServiceImpl');
  final Dio dio;
  final FlutterSecureStorage storage;

  DetailPesananHeaderServiceImpl({
    required this.dio,
    required this.storage,
  });

  @override
  Future<List<DetailHeaderAccesses>> getDetailHeader({int? id}) async {
    List<DetailHeaderAccesses> listHeaderDetail = [];

    try {
      log.i('bhp-order-headers?&id.equals=$id');

      final response = await dio.get(
        'bhp-order-headers?&id.equals=$id',
      );

      print("Response: ${response.statusCode} - ${response.data}");

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        listHeaderDetail =
            data.map((json) => DetailHeaderAccesses.fromJson(json)).toList();

        print('Filtered header Detail List: $listHeaderDetail');
      } else {
        log.e('Failed to fetch header detail list');
      }
    } on DioException catch (e) {
      log.e('Error fetching header detail list: $e');
      // Handle Dio errors here
      throw e;
    }

    return listHeaderDetail;
  }
}
