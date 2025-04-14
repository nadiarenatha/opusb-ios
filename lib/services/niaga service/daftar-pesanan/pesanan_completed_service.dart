import '../../../model/niaga/daftar-pesanan/data_pesanan.dart';

abstract class PesananCompletedService {
  Future<List<DataPesananAccesses>> getPesananCompleted({int? page});
}
