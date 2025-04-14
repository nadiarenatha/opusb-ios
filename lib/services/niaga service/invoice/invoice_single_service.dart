import '../../../model/niaga/detail_invoice_group.dart';

abstract class SingleInvoiceService {
  Future<DetailInvoiceGroupAccess?> getSingleInvoice(
      List<Map<String, dynamic>> invoiceList);
}
