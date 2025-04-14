// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tracking_muat_pelabuhan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TrackingItemMuatPelabuhanAccesses _$TrackingItemMuatPelabuhanAccessesFromJson(
        Map<String, dynamic> json) =>
    TrackingItemMuatPelabuhanAccesses(
      pelabuhanAsal: json['pelabuhan_asal'] as String? ?? '',
      etd: json['ETD'] as String? ?? '',
    );

Map<String, dynamic> _$TrackingItemMuatPelabuhanAccessesToJson(
        TrackingItemMuatPelabuhanAccesses instance) =>
    <String, dynamic>{
      'pelabuhan_asal': instance.pelabuhanAsal,
      'ETD': instance.etd,
    };
