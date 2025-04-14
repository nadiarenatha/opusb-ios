// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'jenis_barang.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JenisBarangAccesses _$JenisBarangAccessesFromJson(Map<String, dynamic> json) =>
    JenisBarangAccesses(
      head: TrackHeadAccesses.fromJson(json['head'] as Map<String, dynamic>),
      data: JenisBarangData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$JenisBarangAccessesToJson(
        JenisBarangAccesses instance) =>
    <String, dynamic>{
      'head': instance.head,
      'data': instance.data,
    };
