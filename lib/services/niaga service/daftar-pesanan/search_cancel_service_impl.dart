import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/daftar-pesanan/search_cancel_service.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';
import '../../../model/niaga/daftar-pesanan/data_pesanan.dart';
import '../../../shared/constants.dart';

class SearchCancelServiceImpl implements SearchCancelService {
  final log = getLogger('SearchCancelServiceImpl');
  final Dio dio;
  final FlutterSecureStorage storage;

  SearchCancelServiceImpl({
    required this.dio,
    required this.storage,
  });

  @override
  Future<List<DataPesananAccesses>> getSearchCancel(
      {int? page,
      String? orderNumber,
      String? orderService,
      String? shipmentType,
      String? originalCity,
      String? destinationCity,
      String? cargoReadyDate,
      String? firstName}) async {
    List<DataPesananAccesses> listSearchCancel = [];

    orderNumber ??= '';
    orderService ??= '';
    shipmentType ??= '';
    originalCity ??= '';
    destinationCity ??= '';
    cargoReadyDate ??= '';
    firstName ??= '';

    try {
      final email = await storage.read(
        key: AuthKey.email.toString(),
        aOptions: const AndroidOptions(encryptedSharedPreferences: true),
      );

      log.i('Making API request to get search Daftar Pesanan Cancel...');
      log.i(
          'Making API request to get search Daftar Pesanan Cancel with email = $email');
      log.i(
          'order-summary?email=$email&orderNumber=$orderNumber&statusId=SO08&page=$page&size=5&jasa=$orderService&jenisPengiriman=$shipmentType&kotaAsal=$originalCity&kotaTujuan=$destinationCity&tanggalCargo=$cargoReadyDate&ownerName=$firstName');

      final response = await dio.get(
        'order-summary?email=$email&orderNumber=$orderNumber&statusId=SO08&page=$page&size=5&jasa=$orderService&jenisPengiriman=$shipmentType&kotaAsal=$originalCity&kotaTujuan=$destinationCity&tanggalCargo=$cargoReadyDate&ownerName=$firstName',
      );

      // Log the entire response
      log.i("Full Response: ${response.toString()}");
      log.i("Response status code: ${response.statusCode}");

      if (response.statusCode == 200) {
        // Deserialize the JSON response to DataPesananAccesses model
        final DataPesananAccesses data =
            DataPesananAccesses.fromJson(response.data);

        // Sort the content list inside the data object
        data.content.sort((a, b) => b.orderNumber!.compareTo(a.orderNumber!));

        listSearchCancel.add(data); // Add the sorted data to the list
      } else {
        throw Exception('Failed to load search Daftar Pesanan Cancel');
      }
    } on DioException catch (e) {
      log.e('DioException occurred: $e');
      if (e.response != null) {
        log.e('Dio response: ${e.response}');
      }
    } catch (e) {
      log.e('Unexpected error: $e');
    }

    return listSearchCancel;
  }
}
