// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'detail_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DetailDataAccesses _$DetailDataAccessesFromJson(Map<String, dynamic> json) =>
    DetailDataAccesses(
      asnDate: json['ASN_DATE'] as String? ?? '',
      namaOwner: json['NAMA_OWNER'] as String? ?? '',
      customerDistribusi: json['CUSTOMER_DISTRIBUSI'] as String? ?? '',
      tujuan: json['TUJUAN'] as String? ?? '',
      deskripsi: json['DESKRIPSI'] as String? ?? '',
      volume: json['VOLUME'] as int? ?? 0,
      qtyOnHand: json['QTY_ON_HAND'] as int? ?? 0,
    );

Map<String, dynamic> _$DetailDataAccessesToJson(DetailDataAccesses instance) =>
    <String, dynamic>{
      'ASN_DATE': instance.asnDate,
      'NAMA_OWNER': instance.namaOwner,
      'CUSTOMER_DISTRIBUSI': instance.customerDistribusi,
      'TUJUAN': instance.tujuan,
      'DESKRIPSI': instance.deskripsi,
      'VOLUME': instance.volume,
      'QTY_ON_HAND': instance.qtyOnHand,
    };
