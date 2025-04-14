// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kebijakan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KebijakanAccesses _$KebijakanAccessesFromJson(Map<String, dynamic> json) =>
    KebijakanAccesses(
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      id: json['id'] as int? ?? 0,
      active: json['active'] as bool? ?? false,
    );

Map<String, dynamic> _$KebijakanAccessesToJson(KebijakanAccesses instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'active': instance.active,
      'id': instance.id,
    };
