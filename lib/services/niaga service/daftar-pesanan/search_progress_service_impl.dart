import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/daftar-pesanan/search_progresss_service.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';
import '../../../model/niaga/daftar-pesanan/data_pesanan.dart';
import '../../../shared/constants.dart';

class SearchProgressServiceImpl implements SearchProgressService {
  final log = getLogger('SearchProgressServiceImpl');
  final Dio dio;
  final FlutterSecureStorage storage;

  SearchProgressServiceImpl({
    required this.dio,
    required this.storage,
  });

  @override
  Future<List<DataPesananAccesses>> getSearchProgress(
      {int? page,
      String? orderNumber,
      String? orderService,
      String? shipmentType,
      String? originalCity,
      String? destinationCity,
      String? cargoReadyDate,
      String? firstName}) async {
    List<DataPesananAccesses> listSearchProgress = [];

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

      log.i('Making API request to get search Daftar Pesanan On Progress...');
      log.i(
          'Making API request to get search Daftar Pesanan On Progress with email = $email');
      log.i(
          'order-summary?email=$email&orderNumber=$orderNumber&statusId=ON_PROGRESS&page=$page&size=5&jasa=$orderService&jenisPengiriman=$shipmentType&kotaAsal=$originalCity&kotaTujuan=$destinationCity&tanggalCargo=$cargoReadyDate&ownerName=$firstName');

      final response = await dio.get(
        'order-summary?email=$email&orderNumber=$orderNumber&statusId=ON_PROGRESS&page=$page&size=5&jasa=$orderService&jenisPengiriman=$shipmentType&kotaAsal=$originalCity&kotaTujuan=$destinationCity&tanggalCargo=$cargoReadyDate&ownerName=$firstName',
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

        listSearchProgress.add(data); // Add the sorted data to the list
      } else {
        throw Exception('Failed to load search Daftar Pesanan In Progress');
      }
    } on DioException catch (e) {
      log.e('DioException occurred: $e');
      if (e.response != null) {
        log.e('Dio response: ${e.response}');
      }
    } catch (e) {
      log.e('Unexpected error: $e');
    }

    return listSearchProgress;
  }
}
