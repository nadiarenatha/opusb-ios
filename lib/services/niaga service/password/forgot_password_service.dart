import '../../../model/change_password.dart';
import '../../../model/forgot_password.dart';

abstract class ForgotPasswordService {
  Future<void> forgotPasswordNiaga(ForgotPassword credential);
}