import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'push_order.g.dart';

@JsonSerializable()
class PushOrderAccesses extends Equatable {
  @JsonKey(name: 'no_order_online')
  final String? noOrderOnline;

  final int? point;

  const PushOrderAccesses({
    this.noOrderOnline = '',
    this.point = 0,
  });

  factory PushOrderAccesses.fromJson(Map<String, dynamic> json) =>
      _$PushOrderAccessesFromJson(json);
  Map<String, dynamic> toJson() => _$PushOrderAccessesToJson(this);

  @override
  List<Object?> get props => [noOrderOnline, point];
}
