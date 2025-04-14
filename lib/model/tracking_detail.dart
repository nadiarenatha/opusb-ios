import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
part 'tracking_detail.g.dart';

@JsonSerializable()
class TrackingDetailAccesses extends Equatable {
  final int? id, mePackingListId;
  final String? description, date, location;
  const TrackingDetailAccesses({
    this.id = 0,
    // this.adOrganizationId = 0,
    // this.accessType = '',
    this.description = '',
    this.date = '',
    this.mePackingListId = 0,
    this.location = '',
  });

  factory TrackingDetailAccesses.fromJson(Map<String, dynamic> json) =>
      _$TrackingDetailAccessesFromJson(json);
  Map<String, dynamic> toJson() => _$TrackingDetailAccessesToJson(this);

  @override
  List<Object> get props => [];
}
