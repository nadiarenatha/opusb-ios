// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tracking_ptd_cosl.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TrackingPtdCoslAccesses _$TrackingPtdCoslAccessesFromJson(
        Map<String, dynamic> json) =>
    TrackingPtdCoslAccesses(
      header: (json['header'] as List<dynamic>)
          .map((e) =>
              TrackingItemHeaderAccesses.fromJson(e as Map<String, dynamic>))
          .toList(),
      muatPelabuhan: TrackingItemMuatPelabuhanAccesses.fromJson(
          json['muat_pelabuhan'] as Map<String, dynamic>),
      bongkarPelabuhan: TrackingItemBongkarPelabuhanAccesses.fromJson(
          json['bongkar_pelabuhan'] as Map<String, dynamic>),
      tiba: TrackingItemTibaAccesses.fromJson(
          json['tiba'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TrackingPtdCoslAccessesToJson(
        TrackingPtdCoslAccesses instance) =>
    <String, dynamic>{
      'header': instance.header,
      'muat_pelabuhan': instance.muatPelabuhan,
      'bongkar_pelabuhan': instance.bongkarPelabuhan,
      'tiba': instance.tiba,
    };
