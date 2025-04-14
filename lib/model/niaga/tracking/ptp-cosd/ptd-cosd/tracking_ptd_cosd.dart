import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:niaga_apps_mobile/model/niaga/tracking/ptp-cosd/tracking_bongkar.dart';
import 'package:niaga_apps_mobile/model/niaga/tracking/ptp-cosd/tracking_header.dart';
import 'package:niaga_apps_mobile/model/niaga/tracking/ptp-cosd/tracking_keluar_niaga.dart';
import 'package:niaga_apps_mobile/model/niaga/tracking/ptp-cosd/tracking_masuk_niaga.dart';
import 'package:niaga_apps_mobile/model/niaga/tracking/ptp-cosd/tracking_menuju_pelabuhan.dart';
import 'package:niaga_apps_mobile/model/niaga/tracking/ptp-cosd/tracking_muat_pelabuhan.dart';

import '../dtd-cosl/tiba.dart';

part 'tracking_ptd_cosd.g.dart';

@JsonSerializable()
class TrackingPtdCosdAccesses extends Equatable {
  final List<TrackingItemHeaderAccesses> header;

  @JsonKey(name: 'masuk_niaga')
  final TrackingItemMasukNiagaAccesses masukNiaga;

  @JsonKey(name: 'keluar_niaga')
  final TrackingItemKeluarNiagaAccesses keluarNiaga;

  @JsonKey(name: 'menuju_pelabuhan')
  final TrackingItemMenujuPelabuhanAccesses menujuPelabuhan;

  @JsonKey(name: 'muat_pelabuhan')
  final TrackingItemMuatPelabuhanAccesses muatPelabuhan;

  @JsonKey(name: 'bongkar_pelabuhan')
  final TrackingItemBongkarPelabuhanAccesses bongkarPelabuhan;

  final TrackingItemTibaAccesses tiba;

  const TrackingPtdCosdAccesses({
    required this.header,
    required this.masukNiaga,
    required this.keluarNiaga,
    required this.menujuPelabuhan,
    required this.muatPelabuhan,
    required this.bongkarPelabuhan,
    required this.tiba,
  });

  factory TrackingPtdCosdAccesses.fromJson(Map<String, dynamic> json) =>
      _$TrackingPtdCosdAccessesFromJson(json);
  Map<String, dynamic> toJson() => _$TrackingPtdCosdAccessesToJson(this);

  @override
  List<Object?> get props => [
        header,
        masukNiaga,
        keluarNiaga,
        menujuPelabuhan,
        muatPelabuhan,
        bongkarPelabuhan,
        tiba
      ];
}
