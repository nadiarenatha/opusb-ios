// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'email_account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmailAccountAccesses _$EmailAccountAccessesFromJson(
        Map<String, dynamic> json) =>
    EmailAccountAccesses(
      email: json['email'] as String? ?? '',
      status: json['status'] as String? ?? '',
    );

Map<String, dynamic> _$EmailAccountAccessesToJson(
        EmailAccountAccesses instance) =>
    <String, dynamic>{
      'email': instance.email,
      'status': instance.status,
    };
