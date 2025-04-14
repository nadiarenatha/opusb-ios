// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'syarat_ketentuan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SyaratKetentuanAccesses _$SyaratKetentuanAccessesFromJson(
        Map<String, dynamic> json) =>
    SyaratKetentuanAccesses(
      value: json['value'] as String? ?? '',
      createdDate: json['createdDate'] as String? ?? '',
      description: json['description'] as String? ?? '',
      active: json['active'] as bool? ?? false,
    );

Map<String, dynamic> _$SyaratKetentuanAccessesToJson(
        SyaratKetentuanAccesses instance) =>
    <String, dynamic>{
      'value': instance.value,
      'description': instance.description,
      'createdDate': instance.createdDate,
      'active': instance.active,
    };
