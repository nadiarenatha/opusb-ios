import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';
import '../../../model/niaga/log_niaga.dart';
import '../../../model/niaga/open_invoice_niaga.dart';
import '../../../shared/constants.dart';
import 'invoice_close_service.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class InvoiceCloseServiceImpl implements InvoiceCloseService {
  final log = getLogger('InvoiceCloseServiceImpl');
  final Dio dio;
  final FlutterSecureStorage storage;

  InvoiceCloseServiceImpl({
    required this.dio,
    required this.storage,
  });

  @override
  Future<List<OpenInvoiceAccesses>> getcloseinvoice(
      {int? page, String? invoiceNumber, String? noJob}) async {
    List<OpenInvoiceAccesses> listCloseInvoice = [];

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

      String url =
          'api/v1/summary_invoice?email=$email&page=$page&size=5&status=CLOSE&invoice_number=$invoiceNumber&no_order=$noJob';

      if (ownerCode != null && ownerCode != "ONLINE") {
        url += '&owner_code=$ownerCode';
      }

      log.i('Constructed API request URL close invoice: $url');
      log.i('Making API request to get close invoices with email: $email');
      log.i('Making API request to get close invoices with email: $ownerCode');
      // Log before making the request
      log.i('Making API request to get Close invoices...');

      final response = await dio.get(
        url,
        options: Options(
          responseType: ResponseType.json,
        ),
      );

      // final queryParams = {
      //   'email': email,
      //   'page': page,
      //   'size': '5',
      //   'status': 'CLOSE',
      //   // if (ownerCode != null && ownerCode.isNotEmpty) 'owner_code': ownerCode,
      //   if (ownerCode != null && ownerCode.isNotEmpty)
      //     'owner_code': 'C20200853',
      // };

      // final response = await dio.get(
      //   'api/v1/summary_invoice?email=$email&page=$page&size=5&status=CLOSE&owner_code=$ownerCode',
      // );

      log.i("Full Response: ${response.toString()}");
      // Log after receiving the response
      log.i("Response status code: ${response.statusCode}");
      // log.i("Response data: ${response.data}");
      final prettyJson =
          const JsonEncoder.withIndent('  ').convert(response.data);
      log.i('Response data: $prettyJson');

      if (response.statusCode == 200) {
        // Deserialize the JSON response to OpenInvoiceAccesses model
        final OpenInvoiceAccesses data =
            OpenInvoiceAccesses.fromJson(response.data);
        listCloseInvoice.add(data); // Add new data to the list
      } else {
        throw Exception('Failed to load close invoices');
      }
    } on DioException catch (e) {
      log.e('DioException occurred: $e');
      if (e.response != null) {
        log.e('Dio response: ${e.response}');
      }
    } catch (e) {
      log.e('Unexpected error: $e');
    }

    return listCloseInvoice;
  }
}

//LOG
class LogNiagaServiceImpl20 implements LogNiagaService20 {
  final log = getLogger('LogNiagaServiceImpl20');
  final Dio dio;
  final FlutterSecureStorage storage;

  LogNiagaServiceImpl20({
    required this.dio,
    required this.storage,
  });

  Future<String> getFullUrl(int? page, String? invoiceNumber, String? noJob) async {
    invoiceNumber ??= '';
    noJob ??= '';

    final email = await storage.read(
        key: AuthKey.email.toString(),
        aOptions: const AndroidOptions(encryptedSharedPreferences: true),
      );

      final ownerCode = await storage.read(
            key: AuthKey.ownerCode.toString(),
            aOptions: const AndroidOptions(encryptedSharedPreferences: true),
          ) ??
          'ONLINE';

    String endpoint = 'v1/summary_invoice?email=$email&page=$page&size=5&status=CLOSE&invoice_number=$invoiceNumber&no_order=$noJob';
    if (ownerCode != 'ONLINE') {
      endpoint += '&owner_code=$ownerCode';
    }
    return '${dio.options.baseUrl}$endpoint';
  }

  @override
  Future<LogNiagaAccesses> logNiaga(int? page, String? invoiceNumber, String? noJob) async {
    final sysdate =
        DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(DateTime.now().toUtc());

    log.i('Formatted sysdate: $sysdate');

    try {
      final fullUrl = await getFullUrl(page, invoiceNumber, noJob);
      log.i('Full URL Log Paid Invoice: $fullUrl');

      final response = await dio.post(
        'https://dev-apps.niaga-logistics.com/api/bhp-activity-logs',
        data: {
          'actionUrl': fullUrl,
          'requestBy': 'mobile',
          'activityLogTime': sysdate,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      log.i("Response data: ${response.data.toString()}");
      log.i("Response status code: ${response.statusCode}");

      if (response.statusCode == 201) {
        log.i("Log successfully created!");
        // Convert response data to model
        final logNiagaAccess = LogNiagaAccesses.fromJson(response.data);
        return logNiagaAccess;
      } else {
        throw Exception(
            'Failed to log niaga: Unexpected status code ${response.statusCode}');
      }
    } on DioException catch (e) {
      log.e(e);
      if (e.message != null) {
        log.e(e.message!);
      }
      if (e.error != null) {
        throw e.error!;
      }
      throw Exception('Failed to get log niaga');
    }
  }
}
