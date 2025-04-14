import '../../../model/niaga/push_order.dart';

abstract class PushOrderService {
  Future<List<PushOrderAccesses>> getPushOrder(String noOrderOnline, int point);
}
