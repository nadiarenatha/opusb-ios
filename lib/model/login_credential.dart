import 'package:json_annotation/json_annotation.dart';
part 'login_credential.g.dart';

@JsonSerializable()
class LoginCredential {
  // final String email;
  final String? username, password;

  LoginCredential({
    this.username = '',
    this.password = '',
  });

  factory LoginCredential.fromJson(Map<String, dynamic> json) =>
      _$LoginCredentialFromJson(json);

  Map<String, dynamic> toJson() => _$LoginCredentialToJson(this);

  @override
  String toString() {
    return 'LoginCredential[username:]';
  }
}
