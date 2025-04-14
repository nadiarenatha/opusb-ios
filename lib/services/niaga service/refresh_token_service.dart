import '../../model/niaga/refresh_token.dart';

abstract class RefreshTokenNiagaService {
  Future<RefreshTokenNiaga> refreshTokenNiaga(String refreshToken);
}
