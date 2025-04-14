import '../../../model/niaga/port_tujuan_fcl.dart';

abstract class PortTujuanHargaService {
  Future<List<PortTujuanFCLAccesses>> getPortTujuanHarga(String portAsal, String jenisPengiriman);
}
