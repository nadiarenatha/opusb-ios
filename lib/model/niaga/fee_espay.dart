import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'fee_espay.g.dart';

@JsonSerializable()
class FeeEspayAccesses extends Equatable {
  final String? name, value;

  const FeeEspayAccesses({
    this.name = '',
    this.value = '',
  });

  factory FeeEspayAccesses.fromJson(Map<String, dynamic> json) =>
      _$FeeEspayAccessesFromJson(json);
  Map<String, dynamic> toJson() => _$FeeEspayAccessesToJson(this);

  @override
  List<Object> get props => [];
}
