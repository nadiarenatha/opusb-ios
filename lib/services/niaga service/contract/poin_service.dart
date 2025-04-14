import '../../../model/niaga/log_niaga.dart';
import '../../../model/niaga/poin.dart';

abstract class PoinService {
  Future<PoinAccesses?> getPoin();
}

abstract class LogNiagaService8 {
  Future<LogNiagaAccesses> logNiaga();
}