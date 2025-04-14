import '../../../model/niaga/log_niaga.dart';
import '../../../model/niaga/port_asal_fcl.dart';

abstract class PortAsalLCLService {
  Future<List<PortAsalFCLAccesses>> getPortAsalLCL();
}

abstract class LogNiagaService26 {
  Future<LogNiagaAccesses> logNiaga();
}
