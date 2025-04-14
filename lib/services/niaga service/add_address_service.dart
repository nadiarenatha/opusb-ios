import '../../model/niaga/address.dart';

abstract class AddAddressService {
  Future<AddressAccesses> getAddresses(
      String addressType,
      String email,
      String addressName,
      String picName,
      String picPhone,
      String city,
      String createdDate,
      String createdBy,
      String address1,
      String locationId);
}
