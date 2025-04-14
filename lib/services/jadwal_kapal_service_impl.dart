import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:niaga_apps_mobile/model/jadwal_kapal.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';

import 'jadwal_kapal_service.dart';

class JadwalKapalServiceImpl implements JadwalKapalService {
  final log = getLogger('JadwalKapalServiceImpl');
  final Dio dio;
  final FlutterSecureStorage storage;

  JadwalKapalServiceImpl({
    required this.dio,
    required this.storage,
  });

  @override
  Future<List<JadwalKapalAccesses>> getjadwalkapal() async {
    List<JadwalKapalAccesses> listKapal = [];
    try {
      final response = await dio.get(
        'me-schedules',
        data: {},
      );
      print("ini res nya: " + response.data.toString());

      if (response.statusCode == 200) {
        var data = response.data as List;
        listKapal = data.map((i) => JadwalKapalAccesses.fromJson(i)).toList();
        // listKapal = listKapal.reversed.toList();
        // listKapal.sort((a, b) => a.id!.compareTo(b.id!));
        print('Jadwal Kapal: $listKapal');
      } else {
        log.e('Failed to fetch jadwal kapal');
      }
    } on DioException catch (e) {
      log.e('Error fetching jadwal kapal: $e');
      // Throw or handle the error as needed
    }

    // print(listKapal[0].toString());
    return listKapal;
  }
}
