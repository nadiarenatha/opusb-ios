import '../../model/niaga/log_niaga.dart';
import '../../model/niaga/simulasi_harga.dart';

abstract class SimulasiHargaService {
  Future<List<SimulasiHargaAccesses>> getSimulasiHarga(
    String portAsal,
    String portTujuan,
    String jenisPengiriman,
  );
}

abstract class LogNiagaService3 {
  Future<LogNiagaAccesses> logNiaga(String portAsal, String portTujuan, String jenisPengiriman);
}