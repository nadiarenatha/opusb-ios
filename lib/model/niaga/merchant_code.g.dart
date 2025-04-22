// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_code.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MerchantCodeAccesses _$MerchantCodeAccessesFromJson(
        Map<String, dynamic> json) =>
    MerchantCodeAccesses(
      name: json['name'] as String? ?? '',
      value: json['value'] as String? ?? '',
      description: json['description'] as String? ?? '',
    );

Map<String, dynamic> _$MerchantCodeAccessesToJson(
        MerchantCodeAccesses instance) =>
    <String, dynamic>{
      'name': instance.name,
      'value': instance.value,
      'description': instance.description,
    };
