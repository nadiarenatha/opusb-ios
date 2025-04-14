import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';
import '../../../model/niaga/detail_invoice_group.dart';
import 'dart:convert';

import 'invoice_single_service.dart';

class SingleInvoiceServiceImpl implements SingleInvoiceService {
  final log = getLogger('SingleInvoiceServiceImpl');
  final Dio dio;
  final FlutterSecureStorage storage;

  SingleInvoiceServiceImpl({
    required this.dio,
    required this.storage,
  });

  @override
  Future<DetailInvoiceGroupAccess?> getSingleInvoice(
      List<Map<String, dynamic>> invoiceList) async {
    DetailInvoiceGroupAccess? singleinvoice;

    try {
      log.i('Making API request to get invoices group...');

      final Map<String, dynamic> requestBody = {
        "invoice": invoiceList.map((invoice) {
          return {
            "no_invoice": invoice['no_invoice'] ?? '',
            "total_invoice": invoice['total_invoice'] ?? 0,
            "no_order_boon": invoice['no_order_boon'] ?? 0,
            "no_order_online": invoice['no_order_online'] ?? 0,
          };
        }).toList(),
      };

      log.i("Request Body nya: ${jsonEncode(requestBody)}");

      final response = await dio.post(
        'api/v1/invoice_group',
        data: jsonEncode(requestBody),
      );

      // Log the entire response
      log.i("Full Response: ${response.toString()}"); 
      log.i("Response status code: ${response.statusCode}");
      log.i("Response Data: ${response.data}");

      if (response.statusCode == 200) {
        // Map the JSON response to the InvoiceSummaryAccesses model
        singleinvoice = DetailInvoiceGroupAccess.fromJson(response.data);
        log.i('Parsed invoice group: ${singleinvoice.toString()}');
      } else {
        throw Exception('Failed to load single invoice');
      }
    } on DioException catch (e) {
      log.e('DioException occurred: $e');
      if (e.response != null) {
        log.e('Dio response: ${e.response}');
      }
    } catch (e) {
      log.e('Unexpected error: $e');
    }

    return singleinvoice;
  }
}
