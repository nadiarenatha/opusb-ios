import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:niaga_apps_mobile/model/niaga/tracking/ptp-cosd/tracking_bongkar.dart';
import 'package:niaga_apps_mobile/model/niaga/tracking/ptp-cosd/tracking_header.dart';
import 'package:niaga_apps_mobile/model/niaga/tracking/ptp-cosd/tracking_keluar_niaga.dart';
import 'package:niaga_apps_mobile/model/niaga/tracking/ptp-cosd/tracking_masuk_niaga.dart';
import 'package:niaga_apps_mobile/model/niaga/tracking/ptp-cosd/tracking_menuju_pelabuhan.dart';
import 'package:niaga_apps_mobile/model/niaga/tracking/ptp-cosd/tracking_muat_pelabuhan.dart';

import '../dtd-cosl/tiba.dart';

part 'tracking_ptd_cosl.g.dart';

@JsonSerializable()
class TrackingPtdCoslAccesses extends Equatable {
  final List<TrackingItemHeaderAccesses> header;

  @JsonKey(name: 'muat_pelabuhan')
  final TrackingItemMuatPelabuhanAccesses muatPelabuhan;

  @JsonKey(name: 'bongkar_pelabuhan')
  final TrackingItemBongkarPelabuhanAccesses bongkarPelabuhan;

  final TrackingItemTibaAccesses tiba;

  const TrackingPtdCoslAccesses({
    required this.header,
    required this.muatPelabuhan,
    required this.bongkarPelabuhan,
    required this.tiba,
  });

  factory TrackingPtdCoslAccesses.fromJson(Map<String, dynamic> json) =>
      _$TrackingPtdCoslAccessesFromJson(json);
  Map<String, dynamic> toJson() => _$TrackingPtdCoslAccessesToJson(this);

  @override
  List<Object?> get props => [
        header,
        muatPelabuhan,
        bongkarPelabuhan,
        tiba
      ];
}
