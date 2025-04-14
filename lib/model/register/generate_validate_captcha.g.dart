// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generate_validate_captcha.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GenerateValidateCaptcha _$GenerateValidateCaptchaFromJson(
        Map<String, dynamic> json) =>
    GenerateValidateCaptcha(
      email: json['email'] as String? ?? '',
      sessionId: json['sessionId'] as String? ?? '',
      captchaEncode: json['captchaEncode'] as String? ?? '',
      otpCode: json['otpCode'] as String? ?? '',
      status: json['status'] as String? ?? '',
    );

Map<String, dynamic> _$GenerateValidateCaptchaToJson(
        GenerateValidateCaptcha instance) =>
    <String, dynamic>{
      'email': instance.email,
      'sessionId': instance.sessionId,
      'captchaEncode': instance.captchaEncode,
      'otpCode': instance.otpCode,
      'status': instance.status,
    };
