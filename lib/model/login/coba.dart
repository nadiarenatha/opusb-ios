import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
part 'coba.g.dart';

@JsonSerializable()
class Coba extends Equatable {
  final int? id, adOrganizationId;
  final String? accessType;
  const Coba({
    this.id = 0,
    this.adOrganizationId = 0,
    this.accessType = '',
  });

  factory Coba.fromJson(Map<String, dynamic> json) => _$CobaFromJson(json);
  Map<String, dynamic> toJson() => _$CobaToJson(this);

  @override
  List<Object> get props => [];
}
