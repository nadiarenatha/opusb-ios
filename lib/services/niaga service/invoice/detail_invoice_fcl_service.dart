import '../../../model/niaga/detail-invoice/detail_invoice_fcl.dart';
import '../../../model/niaga/log_niaga.dart';

abstract class DetailInvoiceFCLService {
  Future<DetailInvoiceFCLAccesses> getDetailInvoiceFCL(String? invoiceNumber);
}

abstract class LogNiagaService25 {
  Future<LogNiagaAccesses> logNiaga(String invoiceNumber);
}
