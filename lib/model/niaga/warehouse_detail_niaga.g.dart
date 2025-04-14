// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'warehouse_detail_niaga.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WarehouseItemAccesses _$WarehouseItemAccessesFromJson(
        Map<String, dynamic> json) =>
    WarehouseItemAccesses(
      asnNo: json['ASN_NO'] as String? ?? '',
      tanggalMasuk: json['TANGGAL_MASUK'] as String? ?? '',
      customerDistribusi: json['CUSTOMER_DISTRIBUSI'] as String? ?? '',
      tujuan: json['TUJUAN'] as String? ?? '',
      totalVolume: (json['TOTAL_VOLUME'] as num?)?.toDouble() ?? 0,
      division: json['DIVISION'] as String? ?? '',
      noResi: json['NO_RESI'] as String? ?? '',
    );

Map<String, dynamic> _$WarehouseItemAccessesToJson(
        WarehouseItemAccesses instance) =>
    <String, dynamic>{
      'ASN_NO': instance.asnNo,
      'TANGGAL_MASUK': instance.tanggalMasuk,
      'CUSTOMER_DISTRIBUSI': instance.customerDistribusi,
      'TUJUAN': instance.tujuan,
      'TOTAL_VOLUME': instance.totalVolume,
      'NO_RESI': instance.noResi,
      'DIVISION': instance.division,
    };
