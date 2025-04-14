import 'package:json_annotation/json_annotation.dart';

part 'login_credential_niaga.g.dart';

@JsonSerializable()
class LoginCredentialNiaga {
  final String? username;
  final String? password;

  @JsonKey(name: 'access_token')
  final String? accessToken;

  @JsonKey(name: 'refresh_token')
  final String? refreshToken;

  // @JsonKey(name: 'expired_at')
  // final int? expiredAt;

  LoginCredentialNiaga({
    this.username = '',
    this.password = '',
    this.accessToken = '',
    this.refreshToken = '',
  });

  factory LoginCredentialNiaga.fromJson(Map<String, dynamic> json) =>
      _$LoginCredentialNiagaFromJson(json);

  Map<String, dynamic> toJson() => _$LoginCredentialNiagaToJson(this);

  @override
  String toString() {
    return 'LoginCredentialNiaga[username: $username, accessToken: $accessToken, refreshToken: $refreshToken]';
  }
}
