// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'detail_cari_barang.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DetailDataBarangAccesses _$DetailDataBarangAccessesFromJson(
        Map<String, dynamic> json) =>
    DetailDataBarangAccesses(
      asnNo: json['ASN_NO'] as int? ?? 0,
      poNo: json['PO_NO'] as String? ?? '',
      noResi: json['NO_RESI'] as String? ?? '',
      penerima: json['PENERIMA'] as String? ?? '',
      volume: (json['VOLUME'] as num?)?.toDouble() ?? 0,
      sendAsnDate: json['SEND_ASN_DATE'] as String? ?? '',
      resultCount: json['RESULT_COUNT'] as int? ?? 0,
      whsCode: json['WHS_CODE'] as String? ?? '',
      division: json['DIVISION'] as String? ?? '',
    );

Map<String, dynamic> _$DetailDataBarangAccessesToJson(
        DetailDataBarangAccesses instance) =>
    <String, dynamic>{
      'ASN_NO': instance.asnNo,
      'PO_NO': instance.poNo,
      'NO_RESI': instance.noResi,
      'PENERIMA': instance.penerima,
      'VOLUME': instance.volume,
      'SEND_ASN_DATE': instance.sendAsnDate,
      'RESULT_COUNT': instance.resultCount,
      'WHS_CODE': instance.whsCode,
      'DIVISION': instance.division,
    };
