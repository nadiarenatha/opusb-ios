// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'uoc_list_search.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UOCListSearchAccesses _$UOCListSearchAccessesFromJson(
        Map<String, dynamic> json) =>
    UOCListSearchAccesses(
      kota: json['KOTA'] as String? ?? '',
      distrik: json['DISTRIK'] as String? ?? '',
      portCode: json['PORT_CODE'] as String? ?? '',
      locId: json['LOC_ID'] as String? ?? '',
    );

Map<String, dynamic> _$UOCListSearchAccessesToJson(
        UOCListSearchAccesses instance) =>
    <String, dynamic>{
      'KOTA': instance.kota,
      'DISTRIK': instance.distrik,
      'PORT_CODE': instance.portCode,
      'LOC_ID': instance.locId,
    };
