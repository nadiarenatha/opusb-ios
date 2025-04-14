import 'package:niaga_apps_mobile/model/invoice.dart';

abstract class InvoiceService {
  // Future<bool> logout();
  // ------ NEW ------
  Future<List<InvoiceAccesses>> getinvoice();
  // Future<List<InvoiceAccesses>> getinvoice(
  //     {required int page, required int limit});
}
