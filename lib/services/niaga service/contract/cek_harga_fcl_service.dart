import '../../../model/niaga/cek-harga/cek_harga_fcl.dart';
import '../../../model/niaga/log_niaga.dart';

abstract class CekHargaFCLService {
  Future<CekHargaFCLAccesses?> getCekHargaFCL(
      String noKontrak, int hargaKontrak, int qty);
}

abstract class LogNiagaService19 {
  Future<LogNiagaAccesses> logNiaga(
      String noKontrak, int hargaKontrak, int qty);
}