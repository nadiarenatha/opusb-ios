import 'package:niaga_apps_mobile/model/niaga/check-email/email_account.dart';

abstract class CheckEmailService {
  Future<EmailAccountAccesses> checkEmail(String email);
}
