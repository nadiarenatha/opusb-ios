import 'package:niaga_apps_mobile/model/niaga/merchant_code.dart';

abstract class MerchantCodeService {
  Future<List<MerchantCodeAccesses>> getMerchantCode();
}
