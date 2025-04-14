import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ulasan.g.dart';

@JsonSerializable()
class UlasanAccesses extends Equatable {
  final String? orderNumber,
      email,
      customerFeedback,
      niagaFeedback,
      createdBy,
      createdDate,
      updateBy,
      updateDate;

  final int? userId, rating;

  final bool? activated;

  const UlasanAccesses({
    this.orderNumber = '',
    this.email = '',
    this.customerFeedback = '',
    this.niagaFeedback = '',
    this.createdBy = '',
    this.createdDate = '',
    this.updateBy = '',
    this.updateDate = '',
    this.userId = 0,
    this.rating = 0,
    this.activated = true,
  });

  factory UlasanAccesses.fromJson(Map<String, dynamic> json) =>
      _$UlasanAccessesFromJson(json);
  Map<String, dynamic> toJson() => _$UlasanAccessesToJson(this);

  @override
  List<Object> get props => [];
}
