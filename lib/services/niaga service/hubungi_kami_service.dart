import '../../model/niaga/dashboard/hubungi_kami.dart';
import '../../model/niaga/log_niaga.dart';

abstract class HubungiKamiService {
  Future<List<HubungiKamiAccesses>> getHubungiKami();
}

abstract class LogNiagaService4 {
  Future<LogNiagaAccesses> logNiaga();
}
