import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/simulasi-pengiriman/port_asal_simulasi_service.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';
import '../../../model/niaga/port_asal_fcl.dart';

class PortAsalHargaServiceImpl implements PortAsalHargaService {
  final log = getLogger('PortAsalHargaServiceImpl');
  final Dio dio;
  final FlutterSecureStorage storage;

  PortAsalHargaServiceImpl({
    required this.dio,
    required this.storage,
  });

  @override
  Future<List<PortAsalFCLAccesses>> getPortAsalHarga(String jenisPengiriman) async {
    List<PortAsalFCLAccesses> listPortAsal = [];

    try {
      log.i('Making API request to get port asal...');
      log.i('api/v1/port/order?jenis_port=ASAL&jenis_pengiriman=$jenisPengiriman');

      final response = await dio
          .get('api/v1/port/order?jenis_port=ASAL&jenis_pengiriman=$jenisPengiriman');

      // Log the full response for debugging
      log.i("Full Response: ${response.toString()}");
      log.i("Response status code: ${response.statusCode}");

      // Check if response is successful
      if (response.statusCode == 200) {
        final List<dynamic> responseData = response.data;

        listPortAsal = responseData
            .map((json) => PortAsalFCLAccesses.fromJson(json))
            .toList();

        log.i('Parsed Port Asal LCL List: $listPortAsal');
      } else {
        throw Exception('Failed to load port asal lcl');
      }
    } on DioException catch (e) {
      log.e('DioException occurred: $e');
      if (e.response != null) {
        log.e('Dio response: ${e.response}');
      }
    } catch (e) {
      log.e('Unexpected error: $e');
    }

    return listPortAsal;
  }
}
