// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tracking_header.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TrackingItemHeaderAccesses _$TrackingItemHeaderAccessesFromJson(
        Map<String, dynamic> json) =>
    TrackingItemHeaderAccesses(
      nopl: json['no_pl'] as String? ?? '',
      noresi: json['no_resi'] as String? ?? '',
      asnNo: json['asn_no'] as String? ?? '',
      ownerCode: json['owner_code'] as String? ?? '',
      ownerName: json['owner_name'] as String? ?? '',
      whsCode: json['whs_code'] as String? ?? '',
      container: json['container'] as String? ?? '',
      keterangan: json['keterangan'] as String? ?? '',
    );

Map<String, dynamic> _$TrackingItemHeaderAccessesToJson(
        TrackingItemHeaderAccesses instance) =>
    <String, dynamic>{
      'no_pl': instance.nopl,
      'no_resi': instance.noresi,
      'asn_no': instance.asnNo,
      'owner_code': instance.ownerCode,
      'owner_name': instance.ownerName,
      'whs_code': instance.whsCode,
      'container': instance.container,
      'keterangan': instance.keterangan,
    };
