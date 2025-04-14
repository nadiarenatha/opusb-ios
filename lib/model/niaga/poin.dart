import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'poin.g.dart';

@JsonSerializable()
class PoinAccesses extends Equatable {

  final int? point;

  const PoinAccesses({
    this.point = 0,
  });

  factory PoinAccesses.fromJson(Map<String, dynamic> json) =>
      _$PoinAccessesFromJson(json);
  Map<String, dynamic> toJson() => _$PoinAccessesToJson(this);

  @override
  List<Object> get props => [];
}
