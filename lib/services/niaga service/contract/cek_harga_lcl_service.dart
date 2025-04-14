import '../../../model/niaga/cek-harga/cek_harga_lcl.dart';
import '../../../model/niaga/log_niaga.dart';

abstract class CekHargaLCLService {
  Future<CekHargaLCLAccesses?> getCekHargaLCL(
      String noKontrak, int hargaKontrak, double cbm);
}

abstract class LogNiagaService18 {
  Future<LogNiagaAccesses> logNiaga(
      String noKontrak, int hargaKontrak, double cbm);
}
