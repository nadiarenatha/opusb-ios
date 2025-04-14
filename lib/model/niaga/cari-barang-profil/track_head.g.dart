// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'track_head.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TrackHeadAccesses _$TrackHeadAccessesFromJson(Map<String, dynamic> json) =>
    TrackHeadAccesses(
      message: json['message'] as String? ?? '',
      trackHeader: (json['track_header'] as List<dynamic>)
          .map((e) => TrackHeader.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TrackHeadAccessesToJson(TrackHeadAccesses instance) =>
    <String, dynamic>{
      'message': instance.message,
      'track_header': instance.trackHeader,
    };
