import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
part 'login_accesses.g.dart';

@JsonSerializable()
class LoginAccesses extends Equatable {
  final int? id, adOrganizationId;
  final String? accessType;
  const LoginAccesses({
    this.id = 0,
    this.adOrganizationId = 0,
    this.accessType = '',
  });

  factory LoginAccesses.fromJson(Map<String, dynamic> json) =>
      _$LoginAccessesFromJson(json);
  Map<String, dynamic> toJson() => _$LoginAccessesToJson(this);

  @override
  List<Object> get props => [];
}
