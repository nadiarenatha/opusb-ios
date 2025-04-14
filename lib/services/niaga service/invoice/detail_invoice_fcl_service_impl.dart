import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';
import '../../../model/niaga/detail-invoice/detail_invoice_fcl.dart';
import '../../../model/niaga/log_niaga.dart';
import 'detail_invoice_fcl_service.dart';
import 'package:intl/intl.dart';

class DetailInvoiceFCLServiceImpl implements DetailInvoiceFCLService {
  final log = getLogger('DetailInvoiceFCLServiceImpl');
  final Dio dio;
  final FlutterSecureStorage storage;

  DetailInvoiceFCLServiceImpl({
    required this.dio,
    required this.storage,
  });

  @override
  Future<DetailInvoiceFCLAccesses> getDetailInvoiceFCL(
      String? invoiceNumber) async {
    try {
      log.i('Making API request to get detail invoices FCL...');
      log.i('api/v1/summary_invoice?invoice_number=$invoiceNumber');

      final response = await dio.get(
        // 'api/v1/summary_invoice?invoice_number=$invoiceNumber&type_pengiriman=FCL',
        'api/v1/summary_invoice?invoice_number=$invoiceNumber',
      );

      log.i("Full Response: ${response.toString()}");
      log.i("Response status code: ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = response.data['data'];

        if (data != null && data.isNotEmpty) {
          final invoiceDetail = DetailInvoiceFCLAccesses.fromJson(data[0]);
          return invoiceDetail;
        } else {
          throw Exception('No data found in the response');
        }
      } else {
        throw Exception('Failed to load invoice details');
      }
    } on DioException catch (e) {
      log.e('DioException occurred: $e');
      if (e.response != null) {
        log.e('Dio response: ${e.response}');
      }
    } catch (e) {
      log.e('Unexpected error: $e');
    }

    throw Exception(
        'Failed to load detail invoice fcl'); // Throwing exception when the invoice cannot be loaded
  }
}

class LogNiagaServiceImpl25 implements LogNiagaService25 {
  final log = getLogger('LogNiagaServiceImpl25');
  final Dio dio;
  final FlutterSecureStorage storage;

  LogNiagaServiceImpl25({
    required this.dio,
    required this.storage,
  });

  Future<String> getFullUrl(String invoiceNumber) async {
    final endpoint = 'api/v1/summary_invoice?invoice_number=$invoiceNumber';
    return '${dio.options.baseUrl}$endpoint';
  }

  @override
  Future<LogNiagaAccesses> logNiaga(String invoiceNumber) async {
    final sysdate =
        DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(DateTime.now().toUtc());

    log.i('Formatted sysdate: $sysdate');

    try {
      final fullUrl = await getFullUrl(invoiceNumber);
      log.i('Full URL Log Detail Invoice FCL: $fullUrl');

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
