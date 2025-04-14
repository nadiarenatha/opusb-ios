// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contract_lcl.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContractLCLAccesses _$ContractLCLAccessesFromJson(Map<String, dynamic> json) =>
    ContractLCLAccesses(
      contractNo: json['CONTRACT_NO'] as String? ?? '',
      portAsal: json['PORT_ASAL'] as String? ?? '',
      portTujuan: json['PORT_TUJUAN'] as String? ?? '',
      pelayaran: json['PELAYARAN'] as String? ?? '',
      pengiriman: json['PENGIRIMAN'] as String? ?? '',
      harga: (json['HARGA'] as num?)?.toDouble() ?? 0,
      message: json['message'] as String? ?? '',
    );

Map<String, dynamic> _$ContractLCLAccessesToJson(
        ContractLCLAccesses instance) =>
    <String, dynamic>{
      'CONTRACT_NO': instance.contractNo,
      'PORT_ASAL': instance.portAsal,
      'PORT_TUJUAN': instance.portTujuan,
      'PELAYARAN': instance.pelayaran,
      'PENGIRIMAN': instance.pengiriman,
      'HARGA': instance.harga,
      'message': instance.message,
    };
