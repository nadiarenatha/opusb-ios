// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pencarian_barang.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PencarianBarangAccesses _$PencarianBarangAccessesFromJson(
        Map<String, dynamic> json) =>
    PencarianBarangAccesses(
      totalRow: json['total_row'] as int? ?? 0,
      page: json['page'] as int? ?? 0,
      size: json['size'] as int? ?? 0,
      totalPage: json['total_page'] as int? ?? 0,
      data: (json['data'] as List<dynamic>)
          .map((e) =>
              DetailDataBarangAccesses.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PencarianBarangAccessesToJson(
        PencarianBarangAccesses instance) =>
    <String, dynamic>{
      'total_row': instance.totalRow,
      'page': instance.page,
      'size': instance.size,
      'total_page': instance.totalPage,
      'data': instance.data,
    };
