import '../../../model/niaga/cari-barang-profil/detail_data_barang.dart';
import '../../../model/niaga/log_niaga.dart';

abstract class DetailPencarianBarangService {
  // Future<List<OpenInvoiceAccesses>> getopeninvoice();
  Future<List<DetailJenisBarangAccesses>> getDetailCariBarang(
      // {String? email, int? page, int? size}
      {String? noResi});
}

abstract class LogNiagaService9 {
  Future<LogNiagaAccesses> logNiaga(String? noResi);
}
