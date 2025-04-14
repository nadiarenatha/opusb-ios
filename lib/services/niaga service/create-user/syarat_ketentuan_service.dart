import '../../../model/niaga/syarat_create_user.dart';

abstract class SyaratCreateUserService {
  Future<List<SyaratCreateUserAccesses>> getSyaratCreateUser(bool active);
}
