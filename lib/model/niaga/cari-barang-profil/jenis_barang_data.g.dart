// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'jenis_barang_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JenisBarangData _$JenisBarangDataFromJson(Map<String, dynamic> json) =>
    JenisBarangData(
      message: json['message'] as String? ?? '',
      trackDetail: (json['track_detail'] as List<dynamic>)
          .map((e) =>
              DetailJenisBarangAccesses.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$JenisBarangDataToJson(JenisBarangData instance) =>
    <String, dynamic>{
      'message': instance.message,
      'track_detail': instance.trackDetail,
    };
