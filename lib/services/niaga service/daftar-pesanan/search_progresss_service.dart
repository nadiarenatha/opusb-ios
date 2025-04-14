import '../../../model/niaga/daftar-pesanan/data_pesanan.dart';

abstract class SearchProgressService {
  Future<List<DataPesananAccesses>> getSearchProgress(
      {int? page,
      String? orderNumber,
      String? orderService,
      String? shipmentType,
      String? originalCity,
      String? destinationCity,
      String? cargoReadyDate,
      String? firstName});
}
