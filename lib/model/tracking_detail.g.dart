// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tracking_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TrackingDetailAccesses _$TrackingDetailAccessesFromJson(
        Map<String, dynamic> json) =>
    TrackingDetailAccesses(
      id: json['id'] as int? ?? 0,
      description: json['description'] as String? ?? '',
      date: json['date'] as String? ?? '',
      mePackingListId: json['mePackingListId'] as int? ?? 0,
      location: json['location'] as String? ?? '',
    );

Map<String, dynamic> _$TrackingDetailAccessesToJson(
        TrackingDetailAccesses instance) =>
    <String, dynamic>{
      'id': instance.id,
      'mePackingListId': instance.mePackingListId,
      'description': instance.description,
      'date': instance.date,
      'location': instance.location,
    };
