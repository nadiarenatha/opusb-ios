import '../../model/niaga/login_token_niaga.dart';

abstract class LogOutService {
  Future<LoginTokenNiaga> logOut(LoginTokenNiaga credential);
}
