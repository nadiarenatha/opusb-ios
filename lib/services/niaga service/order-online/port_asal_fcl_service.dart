import '../../../model/niaga/log_niaga.dart';
import '../../../model/niaga/port_asal_fcl.dart';

abstract class PortAsalFCLService {
  Future<List<PortAsalFCLAccesses>> getPortAsalFCL();
  Future<List<PortAsalFCLAccesses>> getPortAsalLCL();
  Future<LogNiagaAccesses> logNiaga(String actionUrl);
}
