import '../../../model/niaga/container_size.dart';
import '../../../model/niaga/log_niaga.dart';

abstract class ContainerSizeService {
  Future<List<ContainerSizeAccesses>> getContainerSize();
}

abstract class LogNiagaService14 {
  Future<LogNiagaAccesses> logNiaga();
}
