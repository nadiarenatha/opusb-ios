import '../../../model/niaga/warehouse_niaga.dart';

abstract class WarehouseService {
  // Future<List<OpenInvoiceAccesses>> getopeninvoice();
  Future<List<WarehouseNiagaAccesses>> getwarehouse(
      {int? page,
      String? customerDistribusi,
      String? tujuan,
      // String? tanggalMasuk
      String? tglAwal,
      String? tglAkhir});
}
