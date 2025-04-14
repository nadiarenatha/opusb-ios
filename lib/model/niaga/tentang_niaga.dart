import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tentang_niaga.g.dart';

@JsonSerializable()
class TentangNiagaAccesses extends Equatable {
  final String? name, description;
  final bool? active;
  final int? id;

  const TentangNiagaAccesses({
    this.name = '',
    this.description = '',
    this.id = 0,
    this.active = false,
  });

  factory TentangNiagaAccesses.fromJson(Map<String, dynamic> json) =>
      _$TentangNiagaAccessesFromJson(json);
  Map<String, dynamic> toJson() => _$TentangNiagaAccessesToJson(this);

  @override
  List<Object> get props => [];
}
