import '../../../model/niaga/contract.dart';
import '../../../model/niaga/log_niaga.dart';

abstract class ContractService {
  Future<List<ContractAccesses>> getContract(String portAsal, String portTujuan,
      String uocAsal, String uocTujuan, int containerSize);
}

abstract class LogNiagaService15 {
  Future<LogNiagaAccesses> logNiaga(String portAsal, String portTujuan,
      String uocAsal, String uocTujuan, int containerSize);
}
