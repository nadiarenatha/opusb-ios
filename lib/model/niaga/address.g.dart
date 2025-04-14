// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddressAccesses _$AddressAccessesFromJson(Map<String, dynamic> json) =>
    AddressAccesses(
      picPhone: json['picPhone'] as String? ?? '',
      addressType: json['addressType'] as String? ?? '',
      email: json['email'] as String? ?? '',
      addressName: json['addressName'] as String? ?? '',
      picName: json['picName'] as String? ?? '',
      city: json['city'] as String? ?? '',
      createdDate: json['createdDate'] as String? ?? '',
      createdBy: json['createdBy'] as String? ?? '',
      address1: json['address1'] as String? ?? '',
    );

Map<String, dynamic> _$AddressAccessesToJson(AddressAccesses instance) =>
    <String, dynamic>{
      'picPhone': instance.picPhone,
      'addressType': instance.addressType,
      'email': instance.email,
      'addressName': instance.addressName,
      'picName': instance.picName,
      'city': instance.city,
      'createdDate': instance.createdDate,
      'createdBy': instance.createdBy,
      'address1': instance.address1,
    };
