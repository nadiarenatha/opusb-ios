import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';
import '../../model/niaga/invoice_summary.dart';
import '../../model/niaga/log_niaga.dart';
import '../../shared/constants.dart';
import 'invoice_summary_service.dart';
import 'package:intl/intl.dart';

class InvoiceSummaryServiceImpl implements InvoiceSummaryService {
  final log = getLogger('InvoiceSummaryServiceImpl');
  final Dio dio;
  final FlutterSecureStorage storage;

  InvoiceSummaryServiceImpl({
    required this.dio,
    required this.storage,
  });

  @override
  Future<InvoiceSummaryAccesses?> getInvoiceSummary() async {
    InvoiceSummaryAccesses? invoiceSummary; 

    try {
      // final ownerCode = await storage.read(
      //   key: AuthKey.ownerCode.toString(),
      //   aOptions: const AndroidOptions(encryptedSharedPreferences: true),
      // );
      final ownerCode = await storage.read(
            key: AuthKey.ownerCode.toString(),
            aOptions: const AndroidOptions(encryptedSharedPreferences: true),
          ) ??
          ''; // Assign empty string if null

      final email = await storage.read(
        key: AuthKey.email.toString(),
        aOptions: const AndroidOptions(encryptedSharedPreferences: true),
      );

      log.i(
          'Making API request to get invoice summary with ownerCode: $ownerCode');

      log.i('Making API request to get invoice summary with Email: $email');

      log.i('Making API request to get invoice summary...');
      log.i('api/v1/dashboard_invoice?owner_code=$ownerCode&email=$email');

      // Correct the URL to include `=`
      final response =
          await dio.get('api/v1/dashboard_invoice?owner_code=$ownerCode&email=$email');

      // Log the entire response
      log.i("Full Response: ${response.toString()}");
      log.i("Response status code: ${response.statusCode}");

      if (response.statusCode == 200) {
        // Map the JSON response to the InvoiceSummaryAccesses model
        invoiceSummary = InvoiceSummaryAccesses.fromJson(response.data);
        log.i('Parsed invoice summary: ${invoiceSummary.toString()}');
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

    return invoiceSummary;
  }
}

//LOG
class LogNiagaServiceImpl12 implements LogNiagaService12 {
  Future<String> getFullUrl() async {
    final ownerCode = await storage.read(
          key: AuthKey.ownerCode.toString(),
          aOptions: const AndroidOptions(encryptedSharedPreferences: true),
        ) ??
        ''; // Assign empty string if null

    final email = await storage.read(
          key: AuthKey.email.toString(),
          aOptions: const AndroidOptions(encryptedSharedPreferences: true),
        ); // Assign empty string if null

    final endpoint = 'v1/dashboard_invoice?owner_code=$ownerCode&email=$email';
    return '${dio.options.baseUrl}$endpoint';
  }

  final log = getLogger('LogNiagaServiceImpl12');
  final Dio dio;
  final FlutterSecureStorage storage;

  LogNiagaServiceImpl12({
    required this.dio,
    required this.storage,
  });

  @override
  Future<LogNiagaAccesses> logNiaga() async {
    final sysdate =
        DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(DateTime.now().toUtc());

    log.i('Formatted sysdate: $sysdate');

    try {
      final fullUrl = await getFullUrl();
      log.i('Full URL Log Invoice Dashboard: $fullUrl');

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
