import '../../../model/change_password.dart';
import '../../../model/forgot_password.dart';

abstract class ChangePasswordService {
  Future<void> changePasswordNiaga(ChangePassword credential);

}
