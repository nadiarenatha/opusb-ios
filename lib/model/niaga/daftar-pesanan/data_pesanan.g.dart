// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_pesanan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DataPesananAccesses _$DataPesananAccessesFromJson(Map<String, dynamic> json) =>
    DataPesananAccesses(
      content: (json['content'] as List<dynamic>)
          .map((e) => DaftarPesananAccesses.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalPages: json['totalPages'] as int? ?? 0,
    );

Map<String, dynamic> _$DataPesananAccessesToJson(
        DataPesananAccesses instance) =>
    <String, dynamic>{
      'content': instance.content,
      'totalPages': instance.totalPages,
    };
