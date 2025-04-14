import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:gallery_saver/gallery_saver.dart';

import '../../../shared/widget/logger.dart';
import 'image_jadwal_kapal_service.dart';

class ImageJadwalKapalServiceImpl implements ImageJadwalKapalService {
  final log = getLogger('ImageJadwalKapalServiceImpl');
  final Dio dio;
  final FlutterSecureStorage storage;

  ImageJadwalKapalServiceImpl({
    required this.dio,
    required this.storage,
  });

  @override
  Future<bool> downloadImageJadwalKapal(String kotaAsal, String kotaTujuan,
      String portAsal, String portTujuan, String etdFrom) async {
    try {
      if (await _requestStoragePermissions()) {
        log.i("run API image kotaAsal: $kotaAsal");
        log.i("run API image kotaTujuan: $kotaTujuan");
        log.i("run API image portAsal: $portAsal");
        log.i("run API image portTujuan: $portTujuan");

        // log.i('https://elogistic-dev.opusb.co.id/api/report-jadwal-kapal?kota_asal=$portAsal&kota_tujuan=$portTujuan&port_asal=$kotaAsal&port_tujuan=$kotaTujuan&etd_from=$etdFrom');
        log.i(
            'https://niagaapps.niaga-logistics.com/api/report-jadwal-kapal?kota_asal=$portAsal&kota_tujuan=$portTujuan&port_asal=$kotaAsal&port_tujuan=$kotaTujuan&etd_from=$etdFrom');
        // log.i('https://dev-apps.niaga-logistics.com/api/report-jadwal-kapal?kota_asal=$portAsal&kota_tujuan=$portTujuan&port_asal=$kotaAsal&port_tujuan=$kotaTujuan&etd_from=$etdFrom');

        final response = await dio.get(
          // 'https://elogistic-dev.opusb.co.id/api/report-jadwal-kapal?kota_asal=$portAsal&kota_tujuan=$portTujuan&port_asal=$kotaAsal&port_tujuan=$kotaTujuan&etd_from=$etdFrom',
          'https://niagaapps.niaga-logistics.com/api/report-jadwal-kapal?kota_asal=$portAsal&kota_tujuan=$portTujuan&port_asal=$kotaAsal&port_tujuan=$kotaTujuan&etd_from=$etdFrom',
          // 'https://dev-apps.niaga-logistics.com/api/report-jadwal-kapal?kota_asal=$portAsal&kota_tujuan=$portTujuan&port_asal=$kotaAsal&port_tujuan=$kotaTujuan&etd_from=$etdFrom',
          options: Options(responseType: ResponseType.bytes),
        );

        print("Response received with status code: ${response.statusCode}");
        log.i("Response data type: ${response.data.runtimeType}");

        if (response.statusCode == 200 && response.data is List<int>) {
          Directory appDocDir = await getApplicationDocumentsDirectory();
          String filePath = '${appDocDir.path}/jadwal_kapal.png';
          File file = File(filePath);
          await file.writeAsBytes(response.data);

          // Save to gallery
          final result = await GallerySaver.saveImage(file.path);
          if (result == true) {
            log.i('Download completed! File saved to gallery.');
            return true;
          } else {
            log.e('Failed to save image to gallery.');
            return false;
          }
        } else {
          log.e(
              "Failed to download image, status code: ${response.statusCode}");
          return false;
        }
      } else {
        log.e("Storage permission not granted");
        return false;
      }
    } on DioError catch (e) {
      log.e("Dio error: $e");
      return false;
    } catch (e) {
      log.e("Unexpected error: $e");
      return false;
    }
  }

  // Future<bool> _requestStoragePermissions() async {
  //   if (Platform.isAndroid) {
  //     if (await Permission.storage.isGranted ||
  //         await Permission.manageExternalStorage.isGranted) {
  //       return true;
  //     } else {
  //       var status = await Permission.storage.request();
  //       var manageExternalStatus =
  //           await Permission.manageExternalStorage.request();
  //       return status.isGranted || manageExternalStatus.isGranted;
  //     }
  //   }
  //   return true; // For iOS and other platforms
  // }

  Future<bool> _requestStoragePermissions() async {
    if (Platform.isAndroid) {
      if (await Permission.storage.isGranted ||
          await Permission.manageExternalStorage.isGranted ||
          await Permission.photos.isGranted) {
        return true;
      } else {
        var status = await Permission.storage.request();
        var manageExternalStatus =
            await Permission.manageExternalStorage.request();
        var photosStatus =
            await Permission.photos.request(); // Required for Android 13+

        return status.isGranted ||
            manageExternalStatus.isGranted ||
            photosStatus.isGranted;
      }
    }
    return true; // For iOS and other platforms
  }
}
