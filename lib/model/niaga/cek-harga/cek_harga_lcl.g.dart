// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cek_harga_lcl.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CekHargaLCLAccesses _$CekHargaLCLAccessesFromJson(Map<String, dynamic> json) =>
    CekHargaLCLAccesses(
      noKontrak: json['no_kontrak'] as String? ?? '',
      noContract: json['no_contract'] as String? ?? '',
      hargaKontrak: json['harga_kontrak'] as int? ?? 0,
      estimasiHarga: (json['estimasi_harga'] as num?)?.toDouble() ?? 0,
      cbm: (json['cbm'] as num?)?.toDouble() ?? 0,
      pointDigunakan: json['point_digunakan'] as int? ?? 0,
      point: json['point'] as String? ?? '',
    );

Map<String, dynamic> _$CekHargaLCLAccessesToJson(
        CekHargaLCLAccesses instance) =>
    <String, dynamic>{
      'no_kontrak': instance.noKontrak,
      'no_contract': instance.noContract,
      'harga_kontrak': instance.hargaKontrak,
      'estimasi_harga': instance.estimasiHarga,
      'point_digunakan': instance.pointDigunakan,
      'cbm': instance.cbm,
      'point': instance.point,
    };
