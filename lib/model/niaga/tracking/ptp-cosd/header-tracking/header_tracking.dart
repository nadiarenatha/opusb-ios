import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'detail_header.dart';

part 'header_tracking.g.dart';

@JsonSerializable()
class HeaderTrackingAccesses extends Equatable {
  final List<HeaderItemTrackingAccesses> header;

  const HeaderTrackingAccesses({
    required this.header,
  });

  factory HeaderTrackingAccesses.fromJson(Map<String, dynamic> json) =>
      _$HeaderTrackingAccessesFromJson(json);
  Map<String, dynamic> toJson() => _$HeaderTrackingAccessesToJson(this);

  @override
  List<Object?> get props => [
        header,
      ];
}
