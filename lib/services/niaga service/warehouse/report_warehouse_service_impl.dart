import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:niaga_apps_mobile/services/niaga%20service/warehouse/report_warehouse_service.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import '../../../shared/constants.dart';

class ReportWarehouseServiceImpl implements ReportWarehouseService {
  final log = getLogger('ReportWarehouseServiceImpl');
  final Dio dio;
  final FlutterSecureStorage storage;

  ReportWarehouseServiceImpl({
    required this.dio,
    required this.storage,
  });

  @override
  Future<bool> downloadReportWarehousePdf() async {
    try {
      final ownerCode = await storage.read(
        key: AuthKey.ownerCode.toString(),
        aOptions: const AndroidOptions(encryptedSharedPreferences: true),
      );

      final email = await storage.read(
        key: AuthKey.email.toString(),
        aOptions: const AndroidOptions(encryptedSharedPreferences: true),
      );

      String fileName =
          'Warehouse_${DateFormat('yyyyMMddHHmmss').format(DateTime.now())}.xlsx';
      String url =
          'https://niagaapps.niaga-logistics.com/api/report-warehouse-stock?email=$email';

      if (ownerCode != null && ownerCode != "ONLINE") {
        url += '&owner_code=$ownerCode';
      }

      if (Platform.isIOS) {
        final dir = await getApplicationDocumentsDirectory();
        final filePath = '${dir.path}/$fileName';

        final response = await dio.get(
          url,
          options: Options(responseType: ResponseType.bytes),
        );

        File file = File(filePath);
        await file.writeAsBytes(response.data);

        // Optional: Open file or share it
        await OpenFile.open(filePath);
        print("iOS: File saved at $filePath");

        return true;
      }

      // Existing Android logic here...
      int sdkInt = await _getAndroidVersion();
      if (sdkInt >= 30) {
        return await _saveFileToDownloadsAndroid11(url, fileName);
      } else {
        Directory directory = Directory('/storage/emulated/0/Download');
        String filePath = '${directory.path}/$fileName';

        await dio.download(url, filePath);
        scanFile(filePath);
        return true;
      }
    } catch (e) {
      log.e("Download error: $e");
      return false;
    }
  }

  Future<bool> _saveFileToDownloadsAndroid11(
      String url, String fileName) async {
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
