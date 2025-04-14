// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'packing_niaga.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PackingNiagaAccesses _$PackingNiagaAccessesFromJson(
        Map<String, dynamic> json) =>
    PackingNiagaAccesses(
      totalRow: json['total_row'] as int? ?? 0,
      page: json['page'] as int? ?? 0,
      size: json['size'] as int? ?? 0,
      totalPage: json['total_page'] as int? ?? 0,
      data: (json['data'] as List<dynamic>)
          .map((e) => PackingItemAccesses.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PackingNiagaAccessesToJson(
        PackingNiagaAccesses instance) =>
    <String, dynamic>{
      'total_row': instance.totalRow,
      'page': instance.page,
      'size': instance.size,
      'total_page': instance.totalPage,
      'data': instance.data,
    };
