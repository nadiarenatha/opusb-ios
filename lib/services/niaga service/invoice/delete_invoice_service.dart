import '../../../model/niaga/delete_invoice.dart';

abstract class DeleteInvoiceService {
  Future<DeleteInvoiceAccess?> deleteInvoice(String? noInvoiceGroup);
}
