import 'package:niaga_apps_mobile/model/niaga/cari-barang-profil/pencarian_barang.dart';

import '../../../model/niaga/log_niaga.dart';

abstract class PencarianBarangService {
  // Future<List<OpenInvoiceAccesses>> getopeninvoice();
  Future<List<PencarianBarangAccesses>> getcaribarang(
      // {String? email, int? page, int? size}
      {int? page,
      String? noResi,
      String? penerima,
      // String? tanggalMasuk
      String? tglAwal,
      String? tglAkhir});
}

abstract class LogNiagaService7 {
  Future<LogNiagaAccesses> logNiaga(
      int? page,
      String? noResi,
      String? penerima,
      String? tglAwal,
      String? tglAkhir);
}
