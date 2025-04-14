import 'package:dio/dio.dart';

import '../../../model/niaga/otp/wa_verifikasi.dart';

abstract class WAVerifikasiService {
  // Future<WAVerifikasiNiaga> waVerifikasi(WAVerifikasiNiaga credential);
  Future<Response> waVerifikasi(WAVerifikasiNiaga credential);
  // Future<Response> updateupdateWAVerfied();
}
