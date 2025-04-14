import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'forgot_password.g.dart';

@JsonSerializable()
class ForgotPassword extends Equatable {
  final String? email;

  const ForgotPassword({
    this.email = ''
  });

  factory ForgotPassword.fromJson(Map<String, dynamic> json) =>
      _$ForgotPasswordFromJson(json);
  Map<String, dynamic> toJson() => _$ForgotPasswordToJson(this);

  @override
  List<Object?> get props => [
        email
      ];
}
