import '../../../model/niaga/detail-warehouse/data_barang_gudang.dart';
import '../../../model/niaga/log_niaga.dart';

abstract class DetailWarehouseService {
  Future<List<BarangGudangDataAccesses>> getDetailWarehouse({String? asnNo});
}

abstract class LogNiagaService10 {
  Future<LogNiagaAccesses> logNiaga(String? asnNo);
}