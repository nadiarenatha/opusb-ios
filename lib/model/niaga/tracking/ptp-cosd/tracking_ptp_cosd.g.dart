// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tracking_ptp_cosd.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TrackingPtpCosdAccesses _$TrackingPtpCosdAccessesFromJson(
        Map<String, dynamic> json) =>
    TrackingPtpCosdAccesses(
      header: (json['header'] as List<dynamic>)
          .map((e) =>
              TrackingItemHeaderAccesses.fromJson(e as Map<String, dynamic>))
          .toList(),
      masukNiaga: TrackingItemMasukNiagaAccesses.fromJson(
          json['masuk_niaga'] as Map<String, dynamic>),
      keluarNiaga: TrackingItemKeluarNiagaAccesses.fromJson(
          json['keluar_niaga'] as Map<String, dynamic>),
      menujuPelabuhan: TrackingItemMenujuPelabuhanAccesses.fromJson(
          json['menuju_pelabuhan'] as Map<String, dynamic>),
      muatPelabuhan: TrackingItemMuatPelabuhanAccesses.fromJson(
          json['muat_pelabuhan'] as Map<String, dynamic>),
      bongkarPelabuhan: TrackingItemBongkarPelabuhanAccesses.fromJson(
          json['bongkar_pelabuhan'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TrackingPtpCosdAccessesToJson(
        TrackingPtpCosdAccesses instance) =>
    <String, dynamic>{
      'header': instance.header,
      'masuk_niaga': instance.masukNiaga,
      'keluar_niaga': instance.keluarNiaga,
      'menuju_pelabuhan': instance.menujuPelabuhan,
      'muat_pelabuhan': instance.muatPelabuhan,
      'bongkar_pelabuhan': instance.bongkarPelabuhan,
    };
