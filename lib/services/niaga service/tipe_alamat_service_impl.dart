import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/tipe_alamat_service.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';

import '../../model/niaga/tipe_alamat.dart';

class TipeAlamatServiceImpl implements TipeAlamatService {
  final log = getLogger('TipeAlamatServiceImpl');
  final Dio dio;
  final FlutterSecureStorage storage;

  TipeAlamatServiceImpl({
    required this.dio,
    required this.storage,
  });

  @override
  Future<List<TipeAlamatAccesses>> getTipeAlamat() async {
    List<TipeAlamatAccesses> listTipeAlamat = [];

    try {
      final response = await dio.post(
        'ad-reference-lists/find-by-value/addressType',
      );

      print("Response: ${response.statusCode} - ${response.data}");

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        listTipeAlamat =
            data.map((json) => TipeAlamatAccesses.fromJson(json)).toList();

        print('Filtered tipe alamat List: $listTipeAlamat');
      } else {
        log.e('Failed to fetch tipe alamat list');
      }
    } on DioException catch (e) {
      log.e('Error fetching tipe alamat list: $e');
      // Handle Dio errors here
      throw e;
    }

    return listTipeAlamat;
  }
}
