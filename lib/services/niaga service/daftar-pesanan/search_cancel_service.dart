import '../../../model/niaga/daftar-pesanan/data_pesanan.dart';

abstract class SearchCancelService {
  Future<List<DataPesananAccesses>> getSearchCancel(
      {int? page,
      String? orderNumber,
      String? orderService,
      String? shipmentType,
      String? originalCity,
      String? destinationCity,
      String? cargoReadyDate,
      String? firstName});
}
