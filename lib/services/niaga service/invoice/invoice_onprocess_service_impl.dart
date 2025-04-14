import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';
import 'package:niaga_apps_mobile/shared/constants.dart';
import '../../../model/niaga/log_niaga.dart';
import '../../../model/niaga/open_invoice_niaga.dart';
import 'invoice_onprocess_service.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class InvoiceOnProcessServiceImpl implements InvoiceOnProcessService {
  final log = getLogger('InvoiceOnProcessServiceImpl');
  final Dio dio;
  final FlutterSecureStorage storage;

  InvoiceOnProcessServiceImpl({
    required this.dio,
    required this.storage,
  });

  @override
  Future<List<OpenInvoiceAccesses>> getInvoiceOnProcess(
      {int? page, String? invoiceNumber, String? noJob}) async {
    List<OpenInvoiceAccesses> listInvoiceOnProcess = [];

    invoiceNumber ??= '';
    noJob ??= '';

    try {
      final email = await storage.read(
        key: AuthKey.email.toString(),
        aOptions: const AndroidOptions(encryptedSharedPreferences: true),
      );
      // String? ownerCode = await storage.read(
      //   key: AuthKey.ownerCode.toString(),
      //   aOptions: const AndroidOptions(encryptedSharedPreferences: true),
      // );

      final ownerCode = await storage.read(
            key: AuthKey.ownerCode.toString(),
            aOptions: const AndroidOptions(encryptedSharedPreferences: true),
          ) ??
          'ONLINE';

      String url =
          'api/v1/summary_invoice?email=$email&page=$page&size=5&status=OPEN&flag_espay=true&invoice_number=$invoiceNumber&no_order=$noJob';

      if (ownerCode != null && ownerCode != "ONLINE") {
        url += '&owner_code=$ownerCode';
      }

      log.i('Constructed API request URL invoice on process: $url');
      log.i('Making API request to get invoices with email on process: $email');
      log.i(
          'Making API request to get invoices with ownercode on process: $ownerCode');
      log.i('Making API request to get invoices on process...');

      final response = await dio.get(
        url,
        options: Options(
          responseType: ResponseType.json,
        ),
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
        listInvoiceOnProcess.add(data); // Add new data to the list
      } else {
        throw Exception('Failed to load invoices on process');
      }
    } on DioException catch (e) {
      log.e('DioException occurred: $e');
      if (e.response != null) {
        log.e('Dio response: ${e.response}');
      }
    } catch (e) {
      log.e('Unexpected error: $e');
    }

    return listInvoiceOnProcess;
  }
}

//LOG
class LogNiagaServiceImpl21 implements LogNiagaService21 {
  final log = getLogger('LogNiagaServiceImpl21');
  final Dio dio;
  final FlutterSecureStorage storage;

  LogNiagaServiceImpl21({
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

    String endpoint = 'api/v1/summary_invoice?email=$email&page=$page&size=5&status=OPEN&flag_espay=true&invoice_number=$invoiceNumber&no_order=$noJob';
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
      log.i('Full URL Log On Process Invoice: $fullUrl');

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
