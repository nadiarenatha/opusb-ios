import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';

import '../../../model/niaga/daftar-pesanan/detail_line.dart';
import 'detail_line_pesanan_service.dart';

class DetailPesananLineServiceImpl implements DetailPesananLineService {
  final log = getLogger('DetailPesananLineServiceImpl');
  final Dio dio;
  final FlutterSecureStorage storage;

  DetailPesananLineServiceImpl({
    required this.dio,
    required this.storage,
  });

  @override
  Future<List<DetailLineAccesses>> getDetailLine({int? id}) async {
    List<DetailLineAccesses> listLineDetail = [];

    try {
      log.i('bhp-order-lines?headerId.equals=$id');

      final response = await dio.get(
        'bhp-order-lines?headerId.equals=$id',
      );

      print("Response: ${response.statusCode} - ${response.data}");

      if (response.statusCode == 200) {

        List<dynamic> data = response.data;
        listLineDetail =
            data.map((json) => DetailLineAccesses.fromJson(json)).toList();

        print('Filtered line Detail List: $listLineDetail');
      } else {
        log.e('Failed to fetch line detail list');
      }
    } on DioException catch (e) {
      log.e('Error fetching line detail list: $e');
      // Handle Dio errors here
      throw e;
    }

    return listLineDetail;
  }
}
