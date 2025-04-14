// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_slider.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImageSliderAccesses _$ImageSliderAccessesFromJson(Map<String, dynamic> json) =>
    ImageSliderAccesses(
      id: json['id'] as int? ?? 0,
      attachmentUrl: json['attachmentUrl'] as String? ?? '',
      active: json['active'] as bool? ?? false,
    );

Map<String, dynamic> _$ImageSliderAccessesToJson(
        ImageSliderAccesses instance) =>
    <String, dynamic>{
      'id': instance.id,
      'attachmentUrl': instance.attachmentUrl,
      'active': instance.active,
    };
