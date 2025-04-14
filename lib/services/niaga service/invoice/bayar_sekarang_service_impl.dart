import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';
import '../../../model/niaga/delete_invoice.dart';
import 'bayar_sekarang_service.dart';

class BayarSekarangServiceImpl implements BayarSekarangService {
  final log = getLogger('BayarSekarangServiceImpl');
  final Dio dio;
  final FlutterSecureStorage storage;

  BayarSekarangServiceImpl({
    required this.dio,
    required this.storage,
  });

  @override
  Future<DeleteInvoiceAccess?> bayarSekarang(String? noInvoiceGroup) async {
    DeleteInvoiceAccess? invoicegroup;

    try {
      log.i('Making API request to klik bayar sekarang...');

      final response = await dio.post(
          'api/v1/invoice/klikbayar/espay?no_invoice_group=$noInvoiceGroup');

      // Log the entire response
      log.i("Full Response: ${response.toString()}");
      log.i("Response status code: ${response.statusCode}");
      log.i("Response Data: ${response.data}");

      if (response.statusCode == 200) {
        if (response.data is String) {
          log.i("API returned a string response: ${response.data}");
          if (response.data.toLowerCase() == 'success') {
            log.i("Payment was successful");
            return null; // or handle success differently if needed
          } else {
            throw Exception('Unexpected string response: ${response.data}');
          }
        } else if (response.data is Map<String, dynamic>) {
          // Parse JSON response
          invoicegroup = DeleteInvoiceAccess.fromJson(response.data);
          log.i('Parsed invoice group: ${invoicegroup.toString()}');
        } else {
          log.e('Unexpected response data type: ${response.data.runtimeType}');
          throw Exception('Unexpected response format');
        }
      } else {
        throw Exception('Failed to load invoice summary');
      }
    } on DioException catch (e) {
      log.e('DioException occurred: $e');
      if (e.response != null) {
        log.e('Dio response: ${e.response}');
      }
    } catch (e) {
      log.e('Unexpected error: $e');
    }

    return invoicegroup;
  }
}
