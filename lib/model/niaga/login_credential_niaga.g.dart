// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_credential_niaga.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginCredentialNiaga _$LoginCredentialNiagaFromJson(
        Map<String, dynamic> json) =>
    LoginCredentialNiaga(
      username: json['username'] as String? ?? '',
      password: json['password'] as String? ?? '',
      accessToken: json['access_token'] as String? ?? '',
      refreshToken: json['refresh_token'] as String? ?? '',
    );

Map<String, dynamic> _$LoginCredentialNiagaToJson(
        LoginCredentialNiaga instance) =>
    <String, dynamic>{
      'username': instance.username,
      'password': instance.password,
      'access_token': instance.accessToken,
      'refresh_token': instance.refreshToken,
    };
