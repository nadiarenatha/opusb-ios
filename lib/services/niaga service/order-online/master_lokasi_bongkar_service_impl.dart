import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';
import '../../../model/niaga/master_lokasi_bongkar.dart';
import '../../../shared/constants.dart';
import 'master_lokasi_bongkar_service.dart';

class MasterLokasiBongkarServiceImpl implements MasterLokasiBongkarService {
  final log = getLogger('MasterLokasiBongkarServiceImpl');
  final Dio dio;
  final FlutterSecureStorage storage;

  MasterLokasiBongkarServiceImpl({
    required this.dio,
    required this.storage,
  });

  @override
  Future<List<MasterLokasiBongkarAccesses>> getMasterLokasiBongkar(
      String port) async {
    List<MasterLokasiBongkarAccesses> listMasterLokasi = [];

    try {
      final ownerCode = await storage.read(
        key: AuthKey.ownerCode.toString(),
        aOptions: const AndroidOptions(encryptedSharedPreferences: true),
      );

      log.i('Making API request to get master lokasi...');

      log.i(
          'Ini link url nya : api/v1/master/alamat/bongkar?port=$port&owner_code=$ownerCode');

      final response = await dio
          .get('api/v1/master/alamat/bongkar?port=$port&owner_code=$ownerCode');

      // Log the full response for debugging
      log.i("Full Response: ${response.toString()}");
      log.i("Response status code: ${response.statusCode}");

      // Check if response is successful
      if (response.statusCode == 200) {
        listMasterLokasi = (response.data as List)
            .map((json) => MasterLokasiBongkarAccesses.fromJson(json))
            .toList();

        log.i('Parsed ${listMasterLokasi.length} master lokasi bongkar.');
      } else {
        throw Exception('Failed to load master lokasi bongkar');
      }
    } on DioException catch (e) {
      log.e('DioException occurred: $e');
      if (e.response != null) {
        log.e('Dio response: ${e.response}');
      }
    } catch (e) {
      log.e('Unexpected error: $e');
    }

    return listMasterLokasi;
  }
}
