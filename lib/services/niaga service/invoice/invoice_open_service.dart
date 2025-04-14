import '../../../model/niaga/log_niaga.dart';
import '../../../model/niaga/open_invoice_niaga.dart';

abstract class InvoiceOpenService {
  Future<List<OpenInvoiceAccesses>> getopeninvoice(
      {int? page, String? invoiceNumber, String? noJob});
}

abstract class LogNiagaService13 {
  Future<LogNiagaAccesses> logNiaga(
      int? page, String? invoiceNumber, String? noJob);
}
