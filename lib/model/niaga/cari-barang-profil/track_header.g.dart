// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'track_header.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TrackHeader _$TrackHeaderFromJson(Map<String, dynamic> json) => TrackHeader(
      noPl: json['no_pl'] as String? ?? '',
      noResi: json['no_resi'] as int? ?? 0,
      asnNo: json['asn_no'] as int? ?? 0,
      ownerCode: json['owner_code'] as String? ?? '',
      ownerName: json['owner_name'] as String? ?? '',
      whsCode: json['whs_code'] as String? ?? '',
      container: json['container'] as String? ?? '',
      keterangan: json['keterangan'] as String? ?? '',
    );

Map<String, dynamic> _$TrackHeaderToJson(TrackHeader instance) =>
    <String, dynamic>{
      'no_pl': instance.noPl,
      'no_resi': instance.noResi,
      'asn_no': instance.asnNo,
      'owner_code': instance.ownerCode,
      'owner_name': instance.ownerName,
      'whs_code': instance.whsCode,
      'container': instance.container,
      'keterangan': instance.keterangan,
    };
