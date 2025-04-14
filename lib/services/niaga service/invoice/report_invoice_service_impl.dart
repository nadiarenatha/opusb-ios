import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'dart:typed_data';

import 'report_invoice_service.dart';

class ReportInvoiceServiceImpl implements ReportInvoiceService {
  final log = getLogger('ReportInvoiceServiceImpl');
  final Dio dio;
  final FlutterSecureStorage storage;

  ReportInvoiceServiceImpl({
    required this.dio,
    required this.storage,
  });

  @override
  Future<bool> downloadReportInvoicePdf(String invoiceNumber, String volume) async {
    try {
      if (!(await _requestStoragePermissions())) {
        print("Permission denied!");
        return false;
      }

      String sanitizedNoPL = invoiceNumber.replaceAll('/', '_');
      String fileName = 'Invoice_${sanitizedNoPL}_${DateFormat('yyyyMMddHHmmss').format(DateTime.now())}.pdf';
      String url = 'https://niagaapps.niaga-logistics.com/api/report-invoice?baseUrl=https://api-app.niaga-logistics.com/api/v1/summary_invoice&invoice_number=$invoiceNumber&type_pengiriman=$volume';

      int sdkInt = await _getAndroidVersion();

      if (sdkInt >= 30) {
        return await _saveFileToDownloadsAndroid11(url, fileName);
      } else {
        Directory directory = Directory('/storage/emulated/0/Download');
        String filePath = '${directory.path}/$fileName';

        try {
          await dio.download(url, filePath);
          print("File downloaded to: $filePath");
          scanFile(filePath);
          return true;
        } catch (e) {
          print("Download error: $e");
          return false;
        }
      }
    } on DioError catch (e) {
      log.e("Dio error: $e");
      return false;
    } catch (e) {
      log.e("Unexpected error: $e");
      return false;
    }
  }

  Future<bool> _saveFileToDownloadsAndroid11(String url, String fileName) async {
    try {
      final response = await dio.get(
        url,
        options: Options(responseType: ResponseType.bytes),
      );

      final Uint8List fileData = Uint8List.fromList(response.data);
      final String downloadsFolder = "/storage/emulated/0/Download/$fileName";

      File file = File(downloadsFolder);
      await file.writeAsBytes(fileData);

      print("File saved to Downloads: $downloadsFolder");
      scanFile(downloadsFolder);
      return true;
    } catch (e) {
      print("Error saving file: $e");
      return false;
    }
  }

  Future<bool> _requestStoragePermissions() async {
    if (Platform.isAndroid) {
      int sdkInt = await _getAndroidVersion();

      if (sdkInt < 30) {
        return await Permission.storage.request().isGranted;
      }

      return true;
    }

    return true;
  }

  Future<int> _getAndroidVersion() async {
    try {
      String version = Platform.operatingSystemVersion;
      return int.tryParse(version.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    } catch (e) {
      return 0;
    }
  }

  void scanFile(String filePath) {
    const platform = MethodChannel('com.example.app/media_scanner');
    platform.invokeMethod('scanFile', {"path": filePath});
  }
}