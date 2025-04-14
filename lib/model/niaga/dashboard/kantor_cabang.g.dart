// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kantor_cabang.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KantorCabangAccesses _$KantorCabangAccessesFromJson(
        Map<String, dynamic> json) =>
    KantorCabangAccesses(
      sortOrder: json['sort_order'] as int? ?? 0,
      id: json['id'] as int? ?? 0,
      alamat: json['alamat'] as String? ?? '',
      namaCabang: json['nama_cabang'] as String? ?? '',
      image: json['image'] as String? ?? '',
    );

Map<String, dynamic> _$KantorCabangAccessesToJson(
        KantorCabangAccesses instance) =>
    <String, dynamic>{
      'sort_order': instance.sortOrder,
      'id': instance.id,
      'alamat': instance.alamat,
      'image': instance.image,
      'nama_cabang': instance.namaCabang,
    };
