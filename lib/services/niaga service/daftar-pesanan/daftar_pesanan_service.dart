import '../../../model/niaga/daftar-pesanan/daftar_pesanan.dart';
import '../../../model/niaga/daftar-pesanan/data_pesanan.dart';

abstract class DaftarPesananService {
  Future<List<DataPesananAccesses>> getDaftarPesanan(
      {int? page,
      String? orderNumber,
      String? orderService,
      String? shipmentType,
      String? originalCity,
      String? destinationCity,
      String? cargoReadyDate,
      String? firstName});
}
