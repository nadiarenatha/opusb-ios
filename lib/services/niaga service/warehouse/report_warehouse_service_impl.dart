import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:niaga_apps_mobile/services/niaga%20service/warehouse/report_warehouse_service.dart';

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
      if (!(await _requestStoragePermissions())) {
        print("Permission denied!");
        return false;
      }

      final ownerCode = await storage.read(
        key: AuthKey.ownerCode.toString(),
        aOptions: const AndroidOptions(encryptedSharedPreferences: true),
      );

      final email = await storage.read(
        key: AuthKey.email.toString(),
        aOptions: const AndroidOptions(encryptedSharedPreferences: true),
      );

      String fileName = 'Warehouse_${DateFormat('yyyyMMddHHmmss').format(DateTime.now())}.xlsx';
      String url = 'https://niagaapps.niaga-logistics.com/api/report-warehouse-stock?email=$email';

      if (ownerCode != null && ownerCode != "ONLINE") {
        url += '&owner_code=$ownerCode';
      }

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