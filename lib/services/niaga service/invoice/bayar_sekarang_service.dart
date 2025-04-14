import '../../../model/niaga/delete_invoice.dart';

abstract class BayarSekarangService {
  Future<DeleteInvoiceAccess?> bayarSekarang(String? noInvoiceGroup);
}
