import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'email_account.g.dart';

@JsonSerializable()
class EmailAccountAccesses extends Equatable {
  final String? email, status;

  const EmailAccountAccesses({
    this.email = '',
    this.status = '',
  });

  factory EmailAccountAccesses.fromJson(Map<String, dynamic> json) =>
      _$EmailAccountAccessesFromJson(json);
  Map<String, dynamic> toJson() => _$EmailAccountAccessesToJson(this);

  @override
  List<Object> get props => [];
}
