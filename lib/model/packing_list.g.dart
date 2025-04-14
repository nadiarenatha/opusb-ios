// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'packing_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PackingListAccesses _$PackingListAccessesFromJson(Map<String, dynamic> json) =>
    PackingListAccesses(
      id: json['id'] as int? ?? 0,
      packingListNo: json['packingListNo'] as String? ?? '',
      type: json['type'] as String? ?? '',
      volume: json['volume'] as int? ?? 0,
      rute: json['rute'] as String? ?? '',
      ata: json['ata'] as String? ?? '',
      atd: json['atd'] as String? ?? '',
    );

Map<String, dynamic> _$PackingListAccessesToJson(
        PackingListAccesses instance) =>
    <String, dynamic>{
      'id': instance.id,
      'volume': instance.volume,
      'packingListNo': instance.packingListNo,
      'type': instance.type,
      'rute': instance.rute,
      'ata': instance.ata,
      'atd': instance.atd,
    };
