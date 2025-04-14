import 'package:json_annotation/json_annotation.dart';

part 'change_password.g.dart';

@JsonSerializable()
class ChangePassword {
  final String? currentPassword, newPassword;

  ChangePassword({
    this.currentPassword = '',
    this.newPassword = '',
  });

  factory ChangePassword.fromJson(Map<String, dynamic> json) =>
      _$ChangePasswordFromJson(json);

  Map<String, dynamic> toJson() => _$ChangePasswordToJson(this);

  @override
  String toString() {
    return 'ChangePassword[currentPassword:]';
  }
}
