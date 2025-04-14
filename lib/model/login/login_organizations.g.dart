// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_organizations.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginOrganizations _$LoginOrganizationsFromJson(Map<String, dynamic> json) =>
    LoginOrganizations(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      code: json['code'] as String? ?? '',
      description: json['description'] as String? ?? '',
    );

Map<String, dynamic> _$LoginOrganizationsToJson(LoginOrganizations instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'code': instance.code,
      'description': instance.description,
    };
