// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'popular_destination.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PopularDestinationAccesses _$PopularDestinationAccessesFromJson(
        Map<String, dynamic> json) =>
    PopularDestinationAccesses(
      populer: json['POPULER'] as String? ?? '',
      kota: json['KOTA'] as String? ?? '',
      fcl: json['FCL'] as int? ?? 0,
      lcl: (json['LCL'] as num?)?.toDouble() ?? 0,
    );

Map<String, dynamic> _$PopularDestinationAccessesToJson(
        PopularDestinationAccesses instance) =>
    <String, dynamic>{
      'POPULER': instance.populer,
      'KOTA': instance.kota,
      'FCL': instance.fcl,
      'LCL': instance.lcl,
    };
