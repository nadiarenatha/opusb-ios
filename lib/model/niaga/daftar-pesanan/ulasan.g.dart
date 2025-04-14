// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ulasan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UlasanAccesses _$UlasanAccessesFromJson(Map<String, dynamic> json) =>
    UlasanAccesses(
      orderNumber: json['orderNumber'] as String? ?? '',
      email: json['email'] as String? ?? '',
      customerFeedback: json['customerFeedback'] as String? ?? '',
      niagaFeedback: json['niagaFeedback'] as String? ?? '',
      createdBy: json['createdBy'] as String? ?? '',
      createdDate: json['createdDate'] as String? ?? '',
      updateBy: json['updateBy'] as String? ?? '',
      updateDate: json['updateDate'] as String? ?? '',
      userId: json['userId'] as int? ?? 0,
      rating: json['rating'] as int? ?? 0,
      activated: json['activated'] as bool? ?? true,
    );

Map<String, dynamic> _$UlasanAccessesToJson(UlasanAccesses instance) =>
    <String, dynamic>{
      'orderNumber': instance.orderNumber,
      'email': instance.email,
      'customerFeedback': instance.customerFeedback,
      'niagaFeedback': instance.niagaFeedback,
      'createdBy': instance.createdBy,
      'createdDate': instance.createdDate,
      'updateBy': instance.updateBy,
      'updateDate': instance.updateDate,
      'userId': instance.userId,
      'rating': instance.rating,
      'activated': instance.activated,
    };
