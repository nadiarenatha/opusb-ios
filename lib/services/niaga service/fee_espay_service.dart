import '../../model/niaga/fee_espay.dart';

abstract class FeeEspayService {
  Future<List<FeeEspayAccesses>> getFeeEspay();
}
