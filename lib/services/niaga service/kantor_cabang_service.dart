import '../../model/niaga/dashboard/kantor_cabang.dart';
import '../../model/niaga/log_niaga.dart';

abstract class KantorCabangService {
  Future<List<KantorCabangAccesses>> getKantorCabang();
}

abstract class LogNiagaService2 {
  Future<LogNiagaAccesses> logNiaga();
}