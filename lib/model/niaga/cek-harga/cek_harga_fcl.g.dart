// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cek_harga_fcl.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CekHargaFCLAccesses _$CekHargaFCLAccessesFromJson(Map<String, dynamic> json) =>
    CekHargaFCLAccesses(
      noKontrak: json['no_kontrak'] as String? ?? '',
      noContract: json['no_contract'] as String? ?? '',
      hargaKontrak: json['harga_kontrak'] as int? ?? 0,
      estimasiHarga: json['estimasi_harga'] as int? ?? 0,
      qty: json['qty'] as int? ?? 0,
      point: json['point'] as String? ?? '',
      pointDigunakan: json['point_digunakan'] as int? ?? 0,
    );

Map<String, dynamic> _$CekHargaFCLAccessesToJson(
        CekHargaFCLAccesses instance) =>
    <String, dynamic>{
      'no_kontrak': instance.noKontrak,
      'no_contract': instance.noContract,
      'harga_kontrak': instance.hargaKontrak,
      'estimasi_harga': instance.estimasiHarga,
      'point_digunakan': instance.pointDigunakan,
      'qty': instance.qty,
      'point': instance.point,
    };
