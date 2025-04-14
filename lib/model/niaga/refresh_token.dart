import 'package:json_annotation/json_annotation.dart';

part 'refresh_token.g.dart';

@JsonSerializable()
class RefreshTokenNiaga {
  @JsonKey(name: 'refresh_token')
  final String? refreshToken;

  RefreshTokenNiaga({
    this.refreshToken = '',
  });

  factory RefreshTokenNiaga.fromJson(Map<String, dynamic> json) =>
      _$RefreshTokenNiagaFromJson(json);

  Map<String, dynamic> toJson() => _$RefreshTokenNiagaToJson(this);

  @override
  String toString() {
    return 'RefreshTokenNiaga[refreshToken: $refreshToken]';
  }
}
