
import '../../model/niaga/address.dart';

abstract class AddressService {
  Future<List<AddressAccesses>> getAddress();
}
