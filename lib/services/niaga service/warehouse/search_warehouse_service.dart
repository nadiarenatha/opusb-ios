import '../../../model/niaga/log_niaga.dart';
import '../../../model/niaga/warehouse_niaga.dart';

abstract class SearchWarehouseService {
  // Future<List<OpenInvoiceAccesses>> getopeninvoice();
  Future<List<WarehouseNiagaAccesses>> searchwarehouse(
      // {String? email, int? page, int? size}
      {int? page,
      String? customerDistribusi,
      String? tujuan,
      // String? tanggalMasuk
      String? tglAwal,
      String? tglAkhir
      });
}

abstract class LogNiagaService6 {
  Future<LogNiagaAccesses> logNiaga(int? page,
      String? customerDistribusi,
      String? tujuan,
      String? tglAwal,
      String? tglAkhir);
}