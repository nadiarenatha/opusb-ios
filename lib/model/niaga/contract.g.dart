// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contract.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContractAccesses _$ContractAccessesFromJson(Map<String, dynamic> json) =>
    ContractAccesses(
      contractNo: json['CONTRACT_NO'] as String? ?? '',
      portAsal: json['PORT_ASAL'] as String? ?? '',
      portTujuan: json['PORT_TUJUAN'] as String? ?? '',
      pelayaran: json['PELAYARAN'] as String? ?? '',
      pengiriman: json['PENGIRIMAN'] as String? ?? '',
      harga: json['HARGA'] as int? ?? 0,
    );

Map<String, dynamic> _$ContractAccessesToJson(ContractAccesses instance) =>
    <String, dynamic>{
      'CONTRACT_NO': instance.contractNo,
      'PORT_ASAL': instance.portAsal,
      'PORT_TUJUAN': instance.portTujuan,
      'PELAYARAN': instance.pelayaran,
      'PENGIRIMAN': instance.pengiriman,
      'HARGA': instance.harga,
    };
