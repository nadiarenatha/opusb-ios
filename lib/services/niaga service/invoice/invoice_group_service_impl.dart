import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';
import '../../../model/niaga/detail_invoice_group.dart';
import '../../../model/niaga/invoice_group.dart';
import 'dart:convert';

import 'invoice_group_service.dart';

class InvoiceGroupServiceImpl implements InvoiceGroupService {
  final log = getLogger('InvoiceGroupServiceImpl');
  final Dio dio;
  final FlutterSecureStorage storage;

  InvoiceGroupServiceImpl({
    required this.dio,
    required this.storage,
  });

  //New
  @override
  Future<DetailInvoiceGroupAccess?> getInvoiceGroup(
      List<Map<String, dynamic>> invoiceList) async {
    DetailInvoiceGroupAccess? invoicegroup;

    try {
      log.i('Making API request to get invoices group...');

      final Map<String, dynamic> requestBody = {
        "invoice": invoiceList.map((invoice) {
          return {
            "no_invoice": invoice['no_invoice'] ?? '',
            "total_invoice": invoice['total_invoice'] ?? 0,
            "no_order_boon": invoice['no_order_boon'] ?? 0,
            "no_order_online": invoice['no_order_online'] ?? "NULL",
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
        invoicegroup = DetailInvoiceGroupAccess.fromJson(response.data);
        log.i('Parsed invoice group: ${invoicegroup.toString()}');
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
