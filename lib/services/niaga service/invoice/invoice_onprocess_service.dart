import '../../../model/niaga/log_niaga.dart';
import '../../../model/niaga/open_invoice_niaga.dart';

abstract class InvoiceOnProcessService {
  Future<List<OpenInvoiceAccesses>> getInvoiceOnProcess(
      {int? page, String? invoiceNumber, String? noJob});
}

abstract class LogNiagaService21 {
  Future<LogNiagaAccesses> logNiaga(
      int? page, String? invoiceNumber, String? noJob);
}
