// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bank_code.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BankCodeAccesses _$BankCodeAccessesFromJson(Map<String, dynamic> json) =>
    BankCodeAccesses(
      name: json['name'] as String? ?? '',
      value: json['value'] as String? ?? '',
      description: json['description'] as String? ?? '',
    );

Map<String, dynamic> _$BankCodeAccessesToJson(BankCodeAccesses instance) =>
    <String, dynamic>{
      'name': instance.name,
      'value': instance.value,
      'description': instance.description,
    };
