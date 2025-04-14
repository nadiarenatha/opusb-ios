import '../../../model/niaga/port_tujuan_fcl.dart';

abstract class PortTujuanFCLService {
  Future<List<PortTujuanFCLAccesses>> getPortTujuanFCL(String portAsal);
  Future<List<PortTujuanFCLAccesses>> getPortTujuanLCL(String portAsal);
}
