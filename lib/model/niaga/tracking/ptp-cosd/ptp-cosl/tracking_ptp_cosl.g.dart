// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tracking_ptp_cosl.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TrackingPtpCoslAccesses _$TrackingPtpCoslAccessesFromJson(
        Map<String, dynamic> json) =>
    TrackingPtpCoslAccesses(
      header: (json['header'] as List<dynamic>)
          .map((e) =>
              TrackingItemHeaderAccesses.fromJson(e as Map<String, dynamic>))
          .toList(),
      muatPelabuhan: TrackingItemMuatPelabuhanAccesses.fromJson(
          json['muat_pelabuhan'] as Map<String, dynamic>),
      bongkarPelabuhan: TrackingItemBongkarPelabuhanAccesses.fromJson(
          json['bongkar_pelabuhan'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TrackingPtpCoslAccessesToJson(
        TrackingPtpCoslAccesses instance) =>
    <String, dynamic>{
      'header': instance.header,
      'muat_pelabuhan': instance.muatPelabuhan,
      'bongkar_pelabuhan': instance.bongkarPelabuhan,
    };
