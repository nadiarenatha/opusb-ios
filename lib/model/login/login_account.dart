import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
part 'login_account.g.dart';

@JsonSerializable()
class LoginAccount extends Equatable {
  final int? id;
  final List<String>? authorities;
  const LoginAccount({
    this.id = 0,
    this.authorities = const [],
  });

  factory LoginAccount.fromJson(Map<String, dynamic> json) =>
      _$LoginAccountFromJson(json);
  Map<String, dynamic> toJson() => _$LoginAccountToJson(this);

  @override
  List<Object> get props => [];
}
