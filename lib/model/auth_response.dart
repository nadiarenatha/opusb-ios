import 'package:json_annotation/json_annotation.dart';
// import 'package:opusbhr/models/user.dart';
part 'auth_response.g.dart';

@JsonSerializable()
class AuthResponse {
  @JsonKey(name: 'id_token')
  String? token;

  AuthResponse({
    this.token = '',
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AuthResponseToJson(this);

  @override
  String toString() {
    return 'AuthResponse[ token: $token]';
  }
}
