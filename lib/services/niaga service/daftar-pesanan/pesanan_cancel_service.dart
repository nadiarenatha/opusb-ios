import '../../../model/niaga/daftar-pesanan/data_pesanan.dart';

abstract class PesananCancelService {
  Future<List<DataPesananAccesses>> getPesananCancel({int? page});
}
