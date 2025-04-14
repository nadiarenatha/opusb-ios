import '../../model/niaga/log_niaga.dart';
import '../../model/niaga/popular_destination.dart';

abstract class PopularDestinationService {
  Future<List<PopularDestinationAccesses>> getPopularDestination();
}

abstract class LogNiagaService {
  Future<LogNiagaAccesses> logNiaga();
}
