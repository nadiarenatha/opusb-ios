import '../../../model/niaga/log_niaga.dart';
import '../../../model/niaga/uom.dart';

abstract class UOMService {
  Future<List<UOMAccesses>> getUOM();
}

abstract class LogNiagaService17 {
  Future<LogNiagaAccesses> logNiaga();
}