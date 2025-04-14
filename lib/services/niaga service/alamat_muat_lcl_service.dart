import '../../model/niaga/alamat_muat_lcl.dart';
import '../../model/niaga/log_niaga.dart';

abstract class AlamatMuatLCLService {
  Future<List<AlamatMuatLCLAccesses>> getalamatMuatLCL(String portCode);
}

abstract class LogNiagaService16 {
  Future<LogNiagaAccesses> logNiaga(String portCode);
}
