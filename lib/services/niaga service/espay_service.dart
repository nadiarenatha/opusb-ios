import '../../model/niaga/espay.dart';

abstract class EspayPaymentService {
  Future<EspayResponse> espayPaymentValidation(
      String noInvoice,
      String totalInvoice,
      String name,
      String value,
      int userId,
      String orderNumber,
      String invoiceNumber,
      String packingListNumber,
      String ruteTujuan,
      String tipePengiriman,
      String volume,
      String merchantId,
      String subMerchantId,
      String cabang);
}
