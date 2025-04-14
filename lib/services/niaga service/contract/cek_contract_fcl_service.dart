import '../../../model/niaga/contract.dart';
import '../../../model/niaga/log_niaga.dart';

abstract class ContractFCLService {
  Future<List<ContractAccesses>> getContractFCL(String portAsal, String portTujuan,
      String uocAsal, String uocTujuan);
}

abstract class LogNiagaService28 {
  Future<LogNiagaAccesses> logNiaga(String portAsal, String portTujuan,
      String uocAsal, String uocTujuan);
}
