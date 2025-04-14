import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:niaga_apps_mobile/model/niaga/packing_detail_niaga.dart';

part 'popular_destination.g.dart';

@JsonSerializable()
class PopularDestinationAccesses extends Equatable {
  @JsonKey(name: 'POPULER')
  final String? populer;

  @JsonKey(name: 'KOTA')
  final String? kota;

  @JsonKey(name: 'FCL')
  final int? fcl;

  @JsonKey(name: 'LCL')
  final double? lcl;

  const PopularDestinationAccesses({
    this.populer = '',
    this.kota = '',
    this.fcl = 0,
    this.lcl = 0,
  });

  factory PopularDestinationAccesses.fromJson(Map<String, dynamic> json) =>
      _$PopularDestinationAccessesFromJson(json);
  Map<String, dynamic> toJson() => _$PopularDestinationAccessesToJson(this);

  @override
  List<Object?> get props => [populer, kota, fcl, lcl];
}
