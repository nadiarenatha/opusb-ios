import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'container_size.g.dart';

@JsonSerializable()
class ContainerSizeAccesses extends Equatable {

  @JsonKey(name: 'CONTAINER_SIZE')
  final String? containerSize;

  const ContainerSizeAccesses({
    this.containerSize = '',
  });

  factory ContainerSizeAccesses.fromJson(Map<String, dynamic> json) =>
      _$ContainerSizeAccessesFromJson(json);
  Map<String, dynamic> toJson() => _$ContainerSizeAccessesToJson(this);

  @override
  List<Object> get props => [];
}
