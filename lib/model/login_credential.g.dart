// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_credential.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginCredential _$LoginCredentialFromJson(Map<String, dynamic> json) =>
    LoginCredential(
      username: json['username'] as String? ?? '',
      password: json['password'] as String? ?? '',
    );

Map<String, dynamic> _$LoginCredentialToJson(LoginCredential instance) =>
    <String, dynamic>{
      'username': instance.username,
      'password': instance.password,
    };
