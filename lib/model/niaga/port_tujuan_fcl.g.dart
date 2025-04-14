// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'port_tujuan_fcl.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PortTujuanFCLAccesses _$PortTujuanFCLAccessesFromJson(
        Map<String, dynamic> json) =>
    PortTujuanFCLAccesses(
      kotaTujuan: json['KOTA_TUJUAN'] as String? ?? '',
      portTujuan: json['PORT_TUJUAN'] as String? ?? '',
      locIdTujuan: json['LOCID_TUJUAN'] as String? ?? '',
    );

Map<String, dynamic> _$PortTujuanFCLAccessesToJson(
        PortTujuanFCLAccesses instance) =>
    <String, dynamic>{
      'KOTA_TUJUAN': instance.kotaTujuan,
      'PORT_TUJUAN': instance.portTujuan,
      'LOCID_TUJUAN': instance.locIdTujuan,
    };
