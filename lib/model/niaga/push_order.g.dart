// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'push_order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PushOrderAccesses _$PushOrderAccessesFromJson(Map<String, dynamic> json) =>
    PushOrderAccesses(
      noOrderOnline: json['no_order_online'] as String? ?? '',
      point: json['point'] as int? ?? 0,
    );

Map<String, dynamic> _$PushOrderAccessesToJson(PushOrderAccesses instance) =>
    <String, dynamic>{
      'no_order_online': instance.noOrderOnline,
      'point': instance.point,
    };
