// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'espay.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EspayResponse _$EspayResponseFromJson(Map<String, dynamic> json) =>
    EspayResponse(
      webRedirectUrl: json['webRedirectUrl'] as String? ?? '',
      responseCode: json['responseCode'] as String? ?? '',
      responseMessage: json['responseMessage'] as String? ?? '',
    );

Map<String, dynamic> _$EspayResponseToJson(EspayResponse instance) =>
    <String, dynamic>{
      'webRedirectUrl': instance.webRedirectUrl,
      'responseCode': instance.responseCode,
      'responseMessage': instance.responseMessage,
    };
