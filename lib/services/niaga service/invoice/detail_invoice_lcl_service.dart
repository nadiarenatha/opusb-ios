import '../../../model/niaga/detail-invoice/detail_invoice_lcl.dart';
import '../../../model/niaga/log_niaga.dart';

abstract class DetailInvoiceLCLService {
  Future<DetailInvoiceLCLAccesses> getDetailInvoiceLCL(String? invoiceNumber);
}

abstract class LogNiagaService24 {
  Future<LogNiagaAccesses> logNiaga(String invoiceNumber);
}
