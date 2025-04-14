import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'uom.g.dart';

@JsonSerializable()
class UOMAccesses extends Equatable {

  @JsonKey(name: 'UOM_CODE')
  final String? uomCode;

  const UOMAccesses({
    this.uomCode = '',
  });

  factory UOMAccesses.fromJson(Map<String, dynamic> json) =>
      _$UOMAccessesFromJson(json);
  Map<String, dynamic> toJson() => _$UOMAccessesToJson(this);

  @override
  List<Object> get props => [];
}
