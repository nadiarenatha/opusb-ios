// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'header_tracking.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HeaderTrackingAccesses _$HeaderTrackingAccessesFromJson(
        Map<String, dynamic> json) =>
    HeaderTrackingAccesses(
      header: (json['header'] as List<dynamic>)
          .map((e) =>
              HeaderItemTrackingAccesses.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$HeaderTrackingAccessesToJson(
        HeaderTrackingAccesses instance) =>
    <String, dynamic>{
      'header': instance.header,
    };
