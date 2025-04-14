// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'detail_data_barang.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DetailJenisBarangAccesses _$DetailJenisBarangAccessesFromJson(
        Map<String, dynamic> json) =>
    DetailJenisBarangAccesses(
      asnDate: json['asn_date'] as String? ?? '',
      asnNo: json['asn_no'] as int? ?? 0,
      noResi: json['no_resi'] as String? ?? '',
      namaOwner: json['nama_owner'] as String? ?? '',
      customerDistribusi: json['customer_distribusi'] as String? ?? '',
      actVolume: (json['act_volume'] as num?)?.toDouble() ?? 0,
      noPl: json['no_pl'] as String? ?? '',
      ownerCode: json['owner_code'] as String? ?? '',
      whsCode: json['whs_code'] as String? ?? '',
      tujuan: json['tujuan'] as String? ?? '',
      deskripsi: json['deskripsi'] as String? ?? '',
      qty: json['qty'] as int? ?? 0,
    );

Map<String, dynamic> _$DetailJenisBarangAccessesToJson(
        DetailJenisBarangAccesses instance) =>
    <String, dynamic>{
      'asn_date': instance.asnDate,
      'asn_no': instance.asnNo,
      'no_resi': instance.noResi,
      'nama_owner': instance.namaOwner,
      'customer_distribusi': instance.customerDistribusi,
      'act_volume': instance.actVolume,
      'no_pl': instance.noPl,
      'owner_code': instance.ownerCode,
      'whs_code': instance.whsCode,
      'tujuan': instance.tujuan,
      'deskripsi': instance.deskripsi,
      'qty': instance.qty,
    };
