// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tentang_niaga.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TentangNiagaAccesses _$TentangNiagaAccessesFromJson(
        Map<String, dynamic> json) =>
    TentangNiagaAccesses(
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      id: json['id'] as int? ?? 0,
      active: json['active'] as bool? ?? false,
    );

Map<String, dynamic> _$TentangNiagaAccessesToJson(
        TentangNiagaAccesses instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'active': instance.active,
      'id': instance.id,
    };
