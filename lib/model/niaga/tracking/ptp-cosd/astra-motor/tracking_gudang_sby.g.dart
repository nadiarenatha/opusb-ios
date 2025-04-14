// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tracking_gudang_sby.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TrackingItemGudangSbyAccesses _$TrackingItemGudangSbyAccessesFromJson(
        Map<String, dynamic> json) =>
    TrackingItemGudangSbyAccesses(
      pertamaGudangNiaga: json['pertama_gudang_niaga'] as String? ?? '',
      terakhirGudangNiaga: json['terakhir_gudang_niaga'] as String? ?? '',
    );

Map<String, dynamic> _$TrackingItemGudangSbyAccessesToJson(
        TrackingItemGudangSbyAccesses instance) =>
    <String, dynamic>{
      'pertama_gudang_niaga': instance.pertamaGudangNiaga,
      'terakhir_gudang_niaga': instance.terakhirGudangNiaga,
    };
