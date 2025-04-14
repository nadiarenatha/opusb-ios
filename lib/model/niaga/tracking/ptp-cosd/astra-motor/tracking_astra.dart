import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:niaga_apps_mobile/model/niaga/tracking/ptp-cosd/astra-motor/tracking_gudang_astra.dart';
import 'package:niaga_apps_mobile/model/niaga/tracking/ptp-cosd/astra-motor/tracking_gudang_sby.dart';
import 'package:niaga_apps_mobile/model/niaga/tracking/ptp-cosd/tracking_bongkar.dart';
import 'package:niaga_apps_mobile/model/niaga/tracking/ptp-cosd/tracking_header.dart';

import '../dtd-cosl/tiba.dart';

part 'tracking_astra.g.dart';

@JsonSerializable()
class TrackingAstraAccesses extends Equatable {
  final List<TrackingItemHeaderAccesses> header;

  @JsonKey(name: 'dari_gudang_astra')
  final TrackingItemDariGudangAstraAccesses dariGudangAstra;

  @JsonKey(name: 'gudang_sby')
  final TrackingItemGudangSbyAccesses gudangSby;

  @JsonKey(name: 'pembagian_motor')
  final String? pembagianMotor;

  @JsonKey(name: 'keluar_gudang')
  final String? keluarGudang;

  @JsonKey(name: 'menuju_pelabuhan')
  final String? menujuPelabuhan;

  @JsonKey(name: 'muat_pelabuhan')
  final String? muatPelabuhan;

  @JsonKey(name: 'bongkar_pelabuhan')
  final TrackingItemBongkarPelabuhanAccesses bongkarPelabuhan;

  final TrackingItemTibaAccesses tiba;

  const TrackingAstraAccesses({
    required this.header,
    required this.dariGudangAstra,
    required this.gudangSby,
    required this.pembagianMotor,
    required this.keluarGudang,
    required this.menujuPelabuhan,
    required this.muatPelabuhan,
    required this.bongkarPelabuhan,
    required this.tiba,
  });

  factory TrackingAstraAccesses.fromJson(Map<String, dynamic> json) =>
      _$TrackingAstraAccessesFromJson(json);
  Map<String, dynamic> toJson() => _$TrackingAstraAccessesToJson(this);

  String get formattedTimeBagiMotor {
    if (pembagianMotor != null && pembagianMotor!.isNotEmpty) {
      try {
        final dateTime = DateTime.parse(pembagianMotor!);
        // Format to "YYYY-MM-DD HH:MM"
        return "${dateTime.year.toString().padLeft(4, '0')}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
      } catch (e) {
        // Handle parsing errors
        return '';
      }
    }
    return '';
  }

  String get formattedTimeKeluarGudang {
    if (keluarGudang != null && keluarGudang!.isNotEmpty) {
      try {
        final dateTime = DateTime.parse(keluarGudang!);
        // Format to "YYYY-MM-DD HH:MM"
        return "${dateTime.year.toString().padLeft(4, '0')}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
      } catch (e) {
        // Handle parsing errors
        return '';
      }
    }
    return '';
  }

  String get formattedTimeMenujuPelabuhan {
    if (menujuPelabuhan != null && menujuPelabuhan!.isNotEmpty) {
      try {
        final dateTime = DateTime.parse(menujuPelabuhan!);
        // Format to "YYYY-MM-DD HH:MM"
        return "${dateTime.year.toString().padLeft(4, '0')}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
      } catch (e) {
        // Handle parsing errors
        return '';
      }
    }
    return '';
  }

  String get formattedTimeMuatPelabuhan {
    if (muatPelabuhan != null && muatPelabuhan!.isNotEmpty) {
      try {
        final dateTime = DateTime.parse(muatPelabuhan!);
        // Format to "YYYY-MM-DD HH:MM"
        return "${dateTime.year.toString().padLeft(4, '0')}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
      } catch (e) {
        // Handle parsing errors
        return '';
      }
    }
    return '';
  }

  @override
  List<Object?> get props => [
        header,
        dariGudangAstra,
        gudangSby,
        pembagianMotor,
        keluarGudang,
        menujuPelabuhan,
        muatPelabuhan,
        bongkarPelabuhan,
        tiba
      ];
}
