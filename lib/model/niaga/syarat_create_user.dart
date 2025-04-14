import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'syarat_create_user.g.dart';

@JsonSerializable()
class SyaratCreateUserAccesses extends Equatable {
  final String? name, description;
  final bool? active;

  const SyaratCreateUserAccesses({
    this.name = '',
    this.description = '',
    this.active = false,
  });

  factory SyaratCreateUserAccesses.fromJson(Map<String, dynamic> json) =>
      _$SyaratCreateUserAccessesFromJson(json);
  Map<String, dynamic> toJson() => _$SyaratCreateUserAccessesToJson(this);

  @override
  List<Object> get props => [];
}
