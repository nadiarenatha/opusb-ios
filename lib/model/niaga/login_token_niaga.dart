import 'package:json_annotation/json_annotation.dart';

part 'login_token_niaga.g.dart';

@JsonSerializable()
class LoginTokenNiaga {
  final String? refreshToken;
  final String? accessToken;
  final int? expiredAt;

  LoginTokenNiaga({
    this.refreshToken = '',
    this.accessToken = '',
    this.expiredAt = 0,
  });

  factory LoginTokenNiaga.fromJson(Map<String, dynamic> json) =>
      _$LoginTokenNiagaFromJson(json);

  Map<String, dynamic> toJson() => _$LoginTokenNiagaToJson(this);

  @override
  String toString() {
    return 'LoginTokenNiaga[refreshToken: $refreshToken, accessToken: $accessToken, expiredAt: $expiredAt]';
  }
}
