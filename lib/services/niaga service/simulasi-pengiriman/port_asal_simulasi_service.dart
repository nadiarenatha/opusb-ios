import '../../../model/niaga/port_asal_fcl.dart';

abstract class PortAsalHargaService {
  Future<List<PortAsalFCLAccesses>> getPortAsalHarga(String jenisPengiriman);
}
