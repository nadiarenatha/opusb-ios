import '../../../model/niaga/contract_lcl.dart';
import '../../../model/niaga/log_niaga.dart';

abstract class ContractLCLService {
  Future<List<ContractLCLAccesses>> getContractLCL(
      String portAsal, String portTujuan, String uocTujuan);
}

abstract class LogNiagaService27 {
  Future<LogNiagaAccesses> logNiaga(
      String portAsal, String portTujuan, String uocTujuan);
}
