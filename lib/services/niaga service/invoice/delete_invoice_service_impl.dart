import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';
import '../../../model/niaga/delete_invoice.dart';

import 'delete_invoice_service.dart';

class DeleteInvoiceServiceImpl implements DeleteInvoiceService {
  final log = getLogger('DeleteInvoiceServiceImpl');
  final Dio dio;
  final FlutterSecureStorage storage;

  DeleteInvoiceServiceImpl({
    required this.dio,
    required this.storage,
  });

  @override
  Future<DeleteInvoiceAccess?> deleteInvoice(String? noInvoiceGroup) async {
    DeleteInvoiceAccess? invoicegroup;

    try {
      log.i('Making API request to delete invoices group...');

      final response = await dio.delete(
          'api/v1/invoice_group/delete?no_invoice_group=$noInvoiceGroup');

      // Log the entire response
      log.i("Full Response: ${response.toString()}");
      log.i("Response status code: ${response.statusCode}");
      log.i("Response Data: ${response.data}");

      // if (response.statusCode == 200) {
      //   // Map the JSON response to the InvoiceSummaryAccesses model
      //   invoicegroup = DeleteInvoiceAccess.fromJson(response.data);
      //   log.i('Parsed invoice group: ${invoicegroup.toString()}');
      // }
      if (response.statusCode == 200) {
        if (response.data is String) {
          log.i("API returned a string response: ${response.data}");
          if (response.data.toLowerCase() == 'success') {
            log.i("Delete was successful");
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
