import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:niaga_apps_mobile/model/niaga/tracking/ptp-cosd/tracking_bongkar.dart';
import 'package:niaga_apps_mobile/model/niaga/tracking/ptp-cosd/tracking_header.dart';
import 'package:niaga_apps_mobile/model/niaga/tracking/ptp-cosd/tracking_keluar_niaga.dart';
import 'package:niaga_apps_mobile/model/niaga/tracking/ptp-cosd/tracking_masuk_niaga.dart';
import 'package:niaga_apps_mobile/model/niaga/tracking/ptp-cosd/tracking_menuju_pelabuhan.dart';
import 'package:niaga_apps_mobile/model/niaga/tracking/ptp-cosd/tracking_muat_pelabuhan.dart';

import '../dtd-cosl/tiba.dart';

part 'tracking_ptp_cosl.g.dart';

@JsonSerializable()
class TrackingPtpCoslAccesses extends Equatable {
  final List<TrackingItemHeaderAccesses> header;

  @JsonKey(name: 'muat_pelabuhan')
  final TrackingItemMuatPelabuhanAccesses muatPelabuhan;

  @JsonKey(name: 'bongkar_pelabuhan')
  final TrackingItemBongkarPelabuhanAccesses bongkarPelabuhan;

  const TrackingPtpCoslAccesses({
    required this.header,
    required this.muatPelabuhan,
    required this.bongkarPelabuhan,
  });

  factory TrackingPtpCoslAccesses.fromJson(Map<String, dynamic> json) =>
      _$TrackingPtpCoslAccessesFromJson(json);
  Map<String, dynamic> toJson() => _$TrackingPtpCoslAccessesToJson(this);

  @override
  List<Object?> get props => [
        header,
        muatPelabuhan,
        bongkarPelabuhan,
      ];
}
