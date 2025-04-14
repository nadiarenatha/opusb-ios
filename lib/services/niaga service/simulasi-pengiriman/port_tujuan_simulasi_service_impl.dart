import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/simulasi-pengiriman/port_tujuan_simulasi_service.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';
import '../../../model/niaga/port_tujuan_fcl.dart';

class PortTujuanHargaServiceImpl implements PortTujuanHargaService {
  final log = getLogger('PortTujuanHargaServiceImpl');
  final Dio dio;
  final FlutterSecureStorage storage;

  PortTujuanHargaServiceImpl({
    required this.dio,
    required this.storage,
  });

  @override
  Future<List<PortTujuanFCLAccesses>> getPortTujuanHarga(String portAsal, String jenisPengiriman) async {
    List<PortTujuanFCLAccesses> listPortTujuan = [];

    try {
      log.i('Making API request to get port tujuan FCL based on $portAsal...');
      log.i('api/v1/port/order?jenis_port=TUJUAN&port_asal=$portAsal&jenis_pengiriman=$jenisPengiriman');

      final response = await dio
          .get('api/v1/port/order?jenis_port=TUJUAN&port_asal=$portAsal&jenis_pengiriman=$jenisPengiriman');

     
      log.i("Full Response: ${response.toString()}");
      log.i("Response status code: ${response.statusCode}");

      if (response.statusCode == 200) {
        final dynamic responseData = response.data;

        if (responseData is List) {
          listPortTujuan = responseData
              .map((json) => PortTujuanFCLAccesses.fromJson(json))
              .toList();
          log.i('portAsal value: $portAsal');
          log.i('Parsed Port Tujuan List: $listPortTujuan');
        } else if (responseData is String) {
          throw Exception('API returned a string: $responseData');
        } else {
          throw Exception(
              'Unexpected response format: ${responseData.runtimeType}');
        }
      } else {
        throw Exception(
            'Failed to load port tujuan with status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      log.e('DioException occurred: $e');
      if (e.response != null) {
        // log.e('Dio response: ${e.response}');
        log.e('Dio response status code: ${e.response?.statusCode}');
        log.e('Dio response data: ${e.response?.data}');
      }
    } catch (e) {
      log.e('Unexpected error: $e');
    }

    return listPortTujuan;
  }
}
