import '../../../model/niaga/log_niaga.dart';
import '../../../model/niaga/packing_niaga.dart';

abstract class SearchUncompletedPackingService {
  Future<List<PackingNiagaAccesses>> searchPackingUnComplete({
    int? page,
    String? noPL,
    String? containerNo,
    String? asal,
    String? tujuan,
    String? vesselName,
  });
}

abstract class LogNiagaService23 {
  Future<LogNiagaAccesses> logNiaga(int? page, String? noPL,
      String? containerNo, String? asal, String? tujuan, String? vesselName);
}
