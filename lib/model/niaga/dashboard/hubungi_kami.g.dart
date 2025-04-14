// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hubungi_kami.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HubungiKamiAccesses _$HubungiKamiAccessesFromJson(Map<String, dynamic> json) =>
    HubungiKamiAccesses(
      noWa: json['no_wa'] as String? ?? '',
      id: json['id'] as int? ?? 0,
      nomor: json['nomor'] as String? ?? '',
      nama: json['nama'] as String? ?? '',
      area: json['area'] as String? ?? '',
    );

Map<String, dynamic> _$HubungiKamiAccessesToJson(
        HubungiKamiAccesses instance) =>
    <String, dynamic>{
      'no_wa': instance.noWa,
      'id': instance.id,
      'nomor': instance.nomor,
      'nama': instance.nama,
      'area': instance.area,
    };
