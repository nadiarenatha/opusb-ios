import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
part 'login_organizations.g.dart';

@JsonSerializable()
class LoginOrganizations extends Equatable {
  final int? id;
  final String? name, code, description;
  const LoginOrganizations({
    this.id = 0,
    this.name = '',
    this.code = '',
    this.description = '',
  });

  factory LoginOrganizations.fromJson(Map<String, dynamic> json) =>
      _$LoginOrganizationsFromJson(json);
  Map<String, dynamic> toJson() => _$LoginOrganizationsToJson(this);

  @override
  List<Object> get props => [];
}
