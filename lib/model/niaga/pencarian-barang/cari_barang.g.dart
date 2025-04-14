// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cari_barang.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CariBarangAccesses _$CariBarangAccessesFromJson(Map<String, dynamic> json) =>
    CariBarangAccesses(
      totalRow: json['total_row'] as int? ?? 0,
      page: json['page'] as int? ?? 0,
      size: json['size'] as int? ?? 0,
      totalPage: json['total_page'] as int? ?? 0,
      header: (json['header'] as List<dynamic>)
          .map((e) => DetailHeaderAccesses.fromJson(e as Map<String, dynamic>))
          .toList(),
      data: (json['data'] as List<dynamic>)
          .map((e) => DetailDataAccesses.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CariBarangAccessesToJson(CariBarangAccesses instance) =>
    <String, dynamic>{
      'total_row': instance.totalRow,
      'page': instance.page,
      'size': instance.size,
      'total_page': instance.totalPage,
      'header': instance.header,
      'data': instance.data,
    };
