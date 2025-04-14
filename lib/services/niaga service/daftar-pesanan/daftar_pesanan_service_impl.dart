import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';
import '../../../model/niaga/daftar-pesanan/data_pesanan.dart';
import '../../../shared/constants.dart';
import 'daftar_pesanan_service.dart';

class DaftarPesananServiceImpl implements DaftarPesananService {
  final log = getLogger('DaftarPesananServiceImpl');
  final Dio dio;
  final FlutterSecureStorage storage;

  DaftarPesananServiceImpl({
    required this.dio,
    required this.storage,
  });

  @override
  Future<List<DataPesananAccesses>> getDaftarPesanan(
      {int? page,
      String? orderNumber,
      String? orderService,
      String? shipmentType,
      String? originalCity,
      String? destinationCity,
      String? cargoReadyDate,
      String? firstName}) async {
    List<DataPesananAccesses> listDaftarPesanan = [];

    orderNumber = (orderNumber ?? '').isEmpty ? '' : orderNumber;
    orderService = (orderService ?? '').isEmpty ? '' : orderService;
    shipmentType = (shipmentType ?? '').isEmpty ? '' : shipmentType;
    originalCity = (originalCity ?? '').isEmpty ? '' : originalCity;
    destinationCity = (destinationCity ?? '').isEmpty ? '' : destinationCity;
    cargoReadyDate = (cargoReadyDate ?? '').isEmpty ? '' : cargoReadyDate;
    firstName = (firstName ?? '').isEmpty ? '' : firstName;

    try {
      final email = await storage.read(
        key: AuthKey.email.toString(),
        aOptions: const AndroidOptions(encryptedSharedPreferences: true),
      );

      log.i('Making API request to get daftar pesanan On Progress...');
      log.i('Making API request to get daftar pesanan with email = $email');
      // log.i('order-summary?email=$email&statusId=ON_PROGRESS&page=$page&size=5');
      log.i(
          'order-summary?email=$email&orderNumber=$orderNumber&statusId=ON_PROGRESS&page=$page&size=5&jasa=$orderService&jenisPengiriman=$shipmentType&kotaAsal=$originalCity&kotaTujuan=$destinationCity&tanggalCargo=$cargoReadyDate&ownerName=$firstName');

      final response = await dio.get(
        // 'order-summary?email=$email&statusId=ON_PROGRESS&page=$page&size=5',
        'order-summary?email=$email&orderNumber=$orderNumber&statusId=ON_PROGRESS&page=$page&size=5&jasa=$orderService&jenisPengiriman=$shipmentType&kotaAsal=$originalCity&kotaTujuan=$destinationCity&tanggalCargo=$cargoReadyDate&ownerName=$firstName',
      );

      // Log the entire response
      log.i("Full Response: ${response.toString()}");
      log.i("Response status code: ${response.statusCode}");

      if (response.statusCode == 200) {
        // Deserialize the JSON response to DataPesananAccesses model
        final DataPesananAccesses data =
            DataPesananAccesses.fromJson(response.data);
        listDaftarPesanan.add(data); // Add new data to the list
      } else {
        throw Exception('Failed to load daftar pesanan');
      }
    } on DioException catch (e) {
      log.e('DioException occurred: $e');
      if (e.response != null) {
        log.e('Dio response: ${e.response}');
      }
    } catch (e) {
      log.e('Unexpected error: $e');
    }

    return listDaftarPesanan;
  }
}
