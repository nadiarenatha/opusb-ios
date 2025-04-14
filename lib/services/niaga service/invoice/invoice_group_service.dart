import '../../../model/niaga/detail_invoice_group.dart';
import '../../../model/niaga/invoice_group.dart';

abstract class InvoiceGroupService {
  // Future<List<InvoiceGroupAccesses>> getInvoiceGroup(
  Future<DetailInvoiceGroupAccess?> getInvoiceGroup(
       List<Map<String, dynamic>> invoiceList);
}
