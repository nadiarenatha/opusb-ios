import '../../../model/niaga/close_invoice_niaga.dart';
import '../../../model/niaga/log_niaga.dart';
import '../../../model/niaga/open_invoice_niaga.dart';

abstract class InvoiceCloseService {
  // Future<List<OpenInvoiceAccesses>> getopeninvoice();
  Future<List<OpenInvoiceAccesses>> getcloseinvoice(
      // {String? email, int? page, int? size}
      {int? page,
      String? invoiceNumber,
      String? noJob});
}

abstract class LogNiagaService20 {
  Future<LogNiagaAccesses> logNiaga(
      int? page, String? invoiceNumber, String? noJob);
}
