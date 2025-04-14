// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'detail_header.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DetailHeaderAccesses _$DetailHeaderAccessesFromJson(
        Map<String, dynamic> json) =>
    DetailHeaderAccesses(
      asnNo: json['ASN_NO'] as String? ?? '',
      tanggalMasuk: json['TANGGAL_MASUK'] as String? ?? '',
      customerDistribusi: json['CUSTOMER_DISTRIBUSI'] as String? ?? '',
      tujuan: json['TUJUAN'] as String? ?? '',
      totalVolume: json['TOTAL_VOLUME'] as int? ?? 0,
      division: json['DIVISION'] as String? ?? '',
    );

Map<String, dynamic> _$DetailHeaderAccessesToJson(
        DetailHeaderAccesses instance) =>
    <String, dynamic>{
      'ASN_NO': instance.asnNo,
      'TANGGAL_MASUK': instance.tanggalMasuk,
      'CUSTOMER_DISTRIBUSI': instance.customerDistribusi,
      'TUJUAN': instance.tujuan,
      'TOTAL_VOLUME': instance.totalVolume,
      'DIVISION': instance.division,
    };
