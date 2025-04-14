// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tracking_astra.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TrackingAstraAccesses _$TrackingAstraAccessesFromJson(
        Map<String, dynamic> json) =>
    TrackingAstraAccesses(
      header: (json['header'] as List<dynamic>)
          .map((e) =>
              TrackingItemHeaderAccesses.fromJson(e as Map<String, dynamic>))
          .toList(),
      dariGudangAstra: TrackingItemDariGudangAstraAccesses.fromJson(
          json['dari_gudang_astra'] as Map<String, dynamic>),
      gudangSby: TrackingItemGudangSbyAccesses.fromJson(
          json['gudang_sby'] as Map<String, dynamic>),
      pembagianMotor: json['pembagian_motor'] as String?,
      keluarGudang: json['keluar_gudang'] as String?,
      menujuPelabuhan: json['menuju_pelabuhan'] as String?,
      muatPelabuhan: json['muat_pelabuhan'] as String?,
      bongkarPelabuhan: TrackingItemBongkarPelabuhanAccesses.fromJson(
          json['bongkar_pelabuhan'] as Map<String, dynamic>),
      tiba: TrackingItemTibaAccesses.fromJson(
          json['tiba'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TrackingAstraAccessesToJson(
        TrackingAstraAccesses instance) =>
    <String, dynamic>{
      'header': instance.header,
      'dari_gudang_astra': instance.dariGudangAstra,
      'gudang_sby': instance.gudangSby,
      'pembagian_motor': instance.pembagianMotor,
      'keluar_gudang': instance.keluarGudang,
      'menuju_pelabuhan': instance.menujuPelabuhan,
      'muat_pelabuhan': instance.muatPelabuhan,
      'bongkar_pelabuhan': instance.bongkarPelabuhan,
      'tiba': instance.tiba,
    };
