import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/invoice/search_invoice_service.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';
import 'package:niaga_apps_mobile/shared/constants.dart';
import '../../../model/niaga/open_invoice_niaga.dart';
import 'dart:convert';

class SearchInvoiceServiceImpl implements SearchInvoiceService {
  final log = getLogger('SearchInvoiceServiceImpl');
  final Dio dio;
  final FlutterSecureStorage storage;

  SearchInvoiceServiceImpl({
    required this.dio,
    required this.storage,
  });

  @override
  Future<List<OpenInvoiceAccesses>> searchInvoice(
      {int? page, String? invoiceNumber, String? noJob}) async {
    List<OpenInvoiceAccesses> listSearchInvoice = [];

    invoiceNumber ??= '';
    noJob ??= '';

    try {
      final email = await storage.read(
        key: AuthKey.email.toString(),
        aOptions: const AndroidOptions(encryptedSharedPreferences: true),
      );
      final ownerCode = await storage.read(
            key: AuthKey.ownerCode.toString(),
            aOptions: const AndroidOptions(encryptedSharedPreferences: true),
          ) ??
          'ONLINE';

      log.i('Making API request to get search invoices with email: $email');
      log.i('Making API request to get search invoices with email: $ownerCode');
      // Log before making the request
      log.i('Making API request to get search invoices...');
      // log.i(
      //     'api/v1/summary_invoice?email=$email&page=$page&size=5&owner_code=$ownerCode&invoice_number=$invoiceNumber&no_order=$noJob');
      log.i(
          'api/v1/summary_invoice?email=$email&page=$page&size=5&owner_code=C20200853&invoice_number=$invoiceNumber&no_order=$noJob');

      final response = await dio.get(
        // 'api/v1/summary_invoice?email=$email&page=$page&size=5&owner_code=$ownerCode&invoice_number=$invoiceNumber&no_order=$noJob',
        'api/v1/summary_invoice?email=$email&page=$page&size=5&owner_code=C20200853&invoice_number=$invoiceNumber&no_order=$noJob',
      );

      // Log the entire response
      log.i("Full Response: ${response.toString()}");
      log.i("Response status code: ${response.statusCode}");
      // log.i("Response data: ${response.data}");
      final prettyJson =
          const JsonEncoder.withIndent('  ').convert(response.data);
      log.i('Response data: $prettyJson');

      if (response.statusCode == 200) {
        // Deserialize the JSON response to OpenInvoiceAccesses model
        final OpenInvoiceAccesses data =
            OpenInvoiceAccesses.fromJson(response.data);
        listSearchInvoice.add(data); // Add new data to the list
      } else {
        throw Exception('Failed to load open invoices');
      }
    } on DioException catch (e) {
      log.e('DioException occurred: $e');
      if (e.response != null) {
        log.e('Dio response: ${e.response}');
      }
    } catch (e) {
      log.e('Unexpected error: $e');
    }

    return listSearchInvoice;
  }
}
