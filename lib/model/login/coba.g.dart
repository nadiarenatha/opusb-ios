// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coba.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Coba _$CobaFromJson(Map<String, dynamic> json) => Coba(
      id: json['id'] as int? ?? 0,
      adOrganizationId: json['adOrganizationId'] as int? ?? 0,
      accessType: json['accessType'] as String? ?? '',
    );

Map<String, dynamic> _$CobaToJson(Coba instance) => <String, dynamic>{
      'id': instance.id,
      'adOrganizationId': instance.adOrganizationId,
      'accessType': instance.accessType,
    };
