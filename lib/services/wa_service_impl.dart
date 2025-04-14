import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:niaga_apps_mobile/services/wa_service.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';

class WAServiceImpl implements WAService {
  final log = getLogger('WAServiceImpl');
  final Dio dio;
  final FlutterSecureStorage storage;

  WAServiceImpl({
    required this.dio,
    required this.storage,
  });

  // @override
  // Future<bool> sendwhatsapp() async {
  //   log.i('sendwhatsapp()');
  //   log.i(dio.options.baseUrl);
  //   bool response = false;
  //   try {
  //     // d
  //     // final response =
  //     //     await dio.post('sendwhatsapp-email', data: credential.toJson());
  //     final res = await dio.post(
  //       'messages',
  //       data: {
  //         "phone": "+6289523089127",
  //         "message":
  //             "Halo! Terima Kasih telah menggunakan Niaga Logistics. Berikut adalah Jadwal Kapal Anda.",
  //         "media": {
  //           "url":
  //               'https://ontheline.trincoll.edu/images/bookdown/sample-local-pdf.pdf',
  //           "expiration": "7d",
  //           "viewOnce": false
  //         }
  //       },
  //     );
  //     // print(response);
  //     print("ini res nya: " + res.data.toString());

  //     if (res.statusCode == 201) {
  //       print('Message sent successfully');
  //       // return true; // Indicate success
  //       response = true;
  //     } else {
  //       print('Failed to send message: ');
  //       // return false; // Indicate failure
  //       response = false;
  //     }
  //   } on DioException catch (e) {
  //     // throw e.error;
  //     log.e(e);
  //     if (e.message != null) {
  //       log.e(e.message!);
  //     }
  //     if (e.error != null) {
  //       throw e.error!;
  //     }
  //   }
  //   return response;
  // }

  //NEW
  @override
  Future<bool> sendwhatsapp(
      {String? portAsal,
      String? portTujuan,
      String? shippingLine,
      String? vesselName,
      String? voyageNo,
      String? rutePanjang,
      String? tglClosing,
      String? etd,
      String? eta}) async {
    log.i('sendwhatsapp()');
    log.i(dio.options.baseUrl);
    bool response = false;
    try {
      final res = await dio.post(
        'send?text=*JADWAL%20KAPAL%20NIAGA%20LOGISTICS*%0A%0AUntuk%20Jadwal%20Kapal%20Dengan%20Rute:%0A$portAsal-$portTujuan,%20Meliputi%0A%0A*$shippingLine*%0A$vesselName%20Voy%20$voyageNo%0ARute%20Lengkap%20:%20$rutePanjang%0AClossing%20Cargo%20:%20$tglClosing%0AEst%20Berangkat%20:%20$etd%0AEst%20Tiba%20:%20$eta',
        data: {},
      );
      // print(response);
      print("ini res nya: " + res.data.toString());

      if (res.statusCode == 201) {
        print('Message sent successfully');
        // return true; // Indicate success
        response = true;
      } else {
        print('Failed to send message: ');
        // return false; // Indicate failure
        response = false;
      }
    } on DioException catch (e) {
      // throw e.error;
      log.e(e);
      if (e.message != null) {
        log.e(e.message!);
      }
      if (e.error != null) {
        throw e.error!;
      }
    }
    return response;
  }
}
