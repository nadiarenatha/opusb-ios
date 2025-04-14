import '../../../model/niaga/kebijakan.dart';

abstract class KebijakanPrivasiService {
  Future<List<KebijakanAccesses>> getKebijakan(bool active);
}
