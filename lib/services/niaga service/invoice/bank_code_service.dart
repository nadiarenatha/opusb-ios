import '../../../model/niaga/bank_code.dart';

abstract class BankCodeService {
  Future<List<BankCodeAccesses>> getBankCode(String name, String value);
}
