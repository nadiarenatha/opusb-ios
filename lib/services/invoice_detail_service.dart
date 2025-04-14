import '../model/invoice_detail.dart';

abstract class InvoiceDetailService {
  // Future<bool> logout();
  // ------ NEW ------
  Future<List<InvoiceDetailAccesses>> getinvoicedetail({int? meInvoiceId});
}
