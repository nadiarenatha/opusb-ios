import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'bank_code.g.dart';

@JsonSerializable()
class BankCodeAccesses extends Equatable {
  final String? name, value, description;

  const BankCodeAccesses({
    this.name = '',
    this.value = '',
    this.description = '',
  });

  factory BankCodeAccesses.fromJson(Map<String, dynamic> json) =>
      _$BankCodeAccessesFromJson(json);
  Map<String, dynamic> toJson() => _$BankCodeAccessesToJson(this);

  @override
  List<Object> get props => [];
}
