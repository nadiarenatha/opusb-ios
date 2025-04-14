import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'kebijakan.g.dart';

@JsonSerializable()
class KebijakanAccesses extends Equatable {
  final String? name, description;
  final bool? active;
  final int? id;

  const KebijakanAccesses({
    this.name = '',
    this.description = '',
    this.id = 0,
    this.active = false,
  });

  factory KebijakanAccesses.fromJson(Map<String, dynamic> json) =>
      _$KebijakanAccessesFromJson(json);
  Map<String, dynamic> toJson() => _$KebijakanAccessesToJson(this);

  @override
  List<Object> get props => [];
}
