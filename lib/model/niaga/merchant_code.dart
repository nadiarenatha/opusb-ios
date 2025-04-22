import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'merchant_code.g.dart';

@JsonSerializable()
class MerchantCodeAccesses extends Equatable {
  final String? name, value, description;

  const MerchantCodeAccesses({
    this.name = '',
    this.value = '',
    this.description = '',
  });

  factory MerchantCodeAccesses.fromJson(Map<String, dynamic> json) =>
      _$MerchantCodeAccessesFromJson(json);
  Map<String, dynamic> toJson() => _$MerchantCodeAccessesToJson(this);

  @override
  List<Object> get props => [];
}
