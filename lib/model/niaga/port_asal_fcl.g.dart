// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'port_asal_fcl.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PortAsalFCLAccesses _$PortAsalFCLAccessesFromJson(Map<String, dynamic> json) =>
    PortAsalFCLAccesses(
      kotaAsal: json['KOTA_ASAL'] as String? ?? '',
      portAsal: json['PORT_ASAL'] as String? ?? '',
      locIdAsal: json['LOCID_ASAL'] as String? ?? '',
    );

Map<String, dynamic> _$PortAsalFCLAccessesToJson(
        PortAsalFCLAccesses instance) =>
    <String, dynamic>{
      'KOTA_ASAL': instance.kotaAsal,
      'PORT_ASAL': instance.portAsal,
      'LOCID_ASAL': instance.locIdAsal,
    };
