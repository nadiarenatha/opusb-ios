// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_token_niaga.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginTokenNiaga _$LoginTokenNiagaFromJson(Map<String, dynamic> json) =>
    LoginTokenNiaga(
      refreshToken: json['refreshToken'] as String? ?? '',
      accessToken: json['accessToken'] as String? ?? '',
      expiredAt: json['expiredAt'] as int? ?? 0,
    );

Map<String, dynamic> _$LoginTokenNiagaToJson(LoginTokenNiaga instance) =>
    <String, dynamic>{
      'refreshToken': instance.refreshToken,
      'accessToken': instance.accessToken,
      'expiredAt': instance.expiredAt,
    };
