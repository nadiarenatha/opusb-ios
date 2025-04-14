// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'syarat_create_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SyaratCreateUserAccesses _$SyaratCreateUserAccessesFromJson(
        Map<String, dynamic> json) =>
    SyaratCreateUserAccesses(
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      active: json['active'] as bool? ?? false,
    );

Map<String, dynamic> _$SyaratCreateUserAccessesToJson(
        SyaratCreateUserAccesses instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'active': instance.active,
    };
