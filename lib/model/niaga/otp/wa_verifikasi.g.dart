// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wa_verifikasi.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WAVerifikasiNiaga _$WAVerifikasiNiagaFromJson(Map<String, dynamic> json) =>
    WAVerifikasiNiaga(
      no: json['no'] as String? ?? '',
      email: json['email'] as String? ?? '',
      otp: json['otp'] as String? ?? '',
    );

Map<String, dynamic> _$WAVerifikasiNiagaToJson(WAVerifikasiNiaga instance) =>
    <String, dynamic>{
      'no': instance.no,
      'email': instance.email,
      'otp': instance.otp,
    };
