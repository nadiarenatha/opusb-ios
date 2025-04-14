import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/packing/report_packing_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:flutter/services.dart';

class ReportPackingServiceImpl implements ReportPackingService {
  final log = getLogger('ReportPackingServiceImpl');
  final Dio dio;
  final FlutterSecureStorage storage;

  ReportPackingServiceImpl({
    required this.dio,
    required this.storage,
  });

  @override
  Future<bool> downloadReportPackingPdf(String noPL, String tipePL) async {
    try {
      // On Android < 30 we still need storage perms; on Android 30+ and iOS no explicit permission
      if (Platform.isAndroid &&
          !(await Permission.storage.request().isGranted)) {
        log.w("Storage permission denied");
        return false;
      }

      // sanitize filename
      final sanitizedNoPL = noPL.replaceAll('/', '_');
      final timestamp = DateFormat('yyyyMMddHHmmss').format(DateTime.now());
      final fileName = 'Packing_List_${sanitizedNoPL}_$timestamp.pdf';

      // build your URL
      final url = Uri.https(
        'niagaapps.niaga-logistics.com',
        '/api/report-packing-list',
        {
          'baseUrl': 'https://api-app.niaga-logistics.com/api/v1/packing-list/',
          'no_pl': noPL,
          'tipe_pl': tipePL,
        },
      ).toString();

      // fetch bytes once
      final response = await dio.get<List<int>>(
        url,
        options: Options(responseType: ResponseType.bytes),
      );
      final bytes = Uint8List.fromList(response.data!);

      String filePath;

      if (Platform.isAndroid) {
        // Android: write into Downloads
        final downloadsDir = Directory('/storage/emulated/0/Download');
        filePath = '${downloadsDir.path}/$fileName';
      } else if (Platform.isIOS) {
        // iOS: write into app Documents
        final docsDir = await getApplicationDocumentsDirectory();
        filePath = '${docsDir.path}/$fileName';
      } else {
        // fallback to temp
        final tempDir = await getTemporaryDirectory();
        filePath = '${tempDir.path}/$fileName';
      }

      final file = File(filePath);
      await file.writeAsBytes(bytes, flush: true);
      log.i("File written to: $filePath");

      // on Android, trigger media scanner so it shows up in Downloads
      if (Platform.isAndroid) {
        final platform = MethodChannel('com.example.app/media_scanner');
        await platform.invokeMethod('scanFile', {"path": filePath});
      }

      // open the PDF in whichever viewer is available
      await OpenFile.open(filePath);

      return true;
    } on DioError catch (e) {
      log.e("Dio error while downloading PDF: $e");
      return false;
    } catch (e) {
      log.e("Unexpected error: $e");
      return false;
    }
  }
}
