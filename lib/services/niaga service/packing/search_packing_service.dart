import '../../../model/niaga/log_niaga.dart';
import '../../../model/niaga/packing_niaga.dart';

abstract class SearchPackingService {
  Future<List<PackingNiagaAccesses>> searchPackingComplete(
      {int? page,
      String? noPL,
      String? containerNo,
      String? asal,
      String? tujuan,
      String? vesselName});
}

abstract class LogNiagaService22 {
  Future<LogNiagaAccesses> logNiaga(int? page, String? noPL,
      String? containerNo, String? asal, String? tujuan, String? vesselName);
}
