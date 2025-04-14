import '../../model/niaga/login_credential_niaga.dart';
import '../../model/niaga/login_token_niaga.dart';

abstract class AuthNiagaService {
  // Future<LoginCredentialNiaga> authenticateNiaga(
  //     LoginCredentialNiaga credential);
  Future<LoginTokenNiaga> authenticateNiaga(
      LoginTokenNiaga credential);
}
