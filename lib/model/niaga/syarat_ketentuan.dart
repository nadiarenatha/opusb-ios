import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'syarat_ketentuan.g.dart';

@JsonSerializable()
class SyaratKetentuanAccesses extends Equatable {
  final String? value, description, createdDate;
  final bool? active;

  const SyaratKetentuanAccesses({
    this.value = '',
    this.createdDate = '',
    this.description = '',
    this.active = false,
  });

  factory SyaratKetentuanAccesses.fromJson(Map<String, dynamic> json) =>
      _$SyaratKetentuanAccessesFromJson(json);
  Map<String, dynamic> toJson() => _$SyaratKetentuanAccessesToJson(this);

  @override
  List<Object> get props => [];
}
