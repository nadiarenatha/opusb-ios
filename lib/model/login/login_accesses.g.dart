// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_accesses.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginAccesses _$LoginAccessesFromJson(Map<String, dynamic> json) =>
    LoginAccesses(
      id: json['id'] as int? ?? 0,
      adOrganizationId: json['adOrganizationId'] as int? ?? 0,
      accessType: json['accessType'] as String? ?? '',
    );

Map<String, dynamic> _$LoginAccessesToJson(LoginAccesses instance) =>
    <String, dynamic>{
      'id': instance.id,
      'adOrganizationId': instance.adOrganizationId,
      'accessType': instance.accessType,
    };
