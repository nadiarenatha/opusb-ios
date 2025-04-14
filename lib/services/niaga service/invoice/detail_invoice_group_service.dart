import '../../../model/niaga/detail_espay_invoice_group.dart';

abstract class DetailInvoiceGroupService {
  Future<List<DetailEspayInvoiceGroupAccesses>> getDetailInvoiceGroup(
      String noInvGroup);
}
