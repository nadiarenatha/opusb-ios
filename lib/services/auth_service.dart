// import 'package:niaga_apps_mobile/model/account_m.dart';
import 'package:niaga_apps_mobile/model/auth_response.dart';
import 'package:niaga_apps_mobile/model/login/login_accesses.dart';
import 'package:niaga_apps_mobile/model/login/login_account.dart';
import 'package:niaga_apps_mobile/model/login/login_organizations.dart';
import 'package:niaga_apps_mobile/model/login_credential.dart';

abstract class AuthService {
  // Future<bool> logout();
  // ------ NEW ------
  Future<AuthResponse> authenticate(LoginCredential credential);
  // Future<AccountM> getAccount();
  // Future<List<IdNamePair>> getRoles(int clientId);

//get account
  // Future<LoginAccount> getAccount();
  Future<List<LoginAccesses>> getListAccesses();
  Future<List<LoginOrganizations>> getListAdOrganizations(
    List<LoginAccesses> loginAccesses,
  );
  Future<List<LoginOrganizations>> getListScAuthorities(
    LoginAccount loginAccount,
  );
}
