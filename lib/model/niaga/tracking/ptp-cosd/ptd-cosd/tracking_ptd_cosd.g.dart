// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tracking_ptd_cosd.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TrackingPtdCosdAccesses _$TrackingPtdCosdAccessesFromJson(
        Map<String, dynamic> json) =>
    TrackingPtdCosdAccesses(
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
      tiba: TrackingItemTibaAccesses.fromJson(
          json['tiba'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TrackingPtdCosdAccessesToJson(
        TrackingPtdCosdAccesses instance) =>
    <String, dynamic>{
      'header': instance.header,
      'masuk_niaga': instance.masukNiaga,
      'keluar_niaga': instance.keluarNiaga,
      'menuju_pelabuhan': instance.menujuPelabuhan,
      'muat_pelabuhan': instance.muatPelabuhan,
      'bongkar_pelabuhan': instance.bongkarPelabuhan,
      'tiba': instance.tiba,
    };
