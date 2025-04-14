import '../../../model/niaga/open_invoice_niaga.dart';

abstract class SearchInvoiceService {
  Future<List<OpenInvoiceAccesses>> searchInvoice(
      {int? page, String? invoiceNumber, String? noJob});
}
