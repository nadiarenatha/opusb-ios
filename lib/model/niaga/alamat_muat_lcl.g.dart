// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alamat_muat_lcl.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AlamatMuatLCLAccesses _$AlamatMuatLCLAccessesFromJson(
        Map<String, dynamic> json) =>
    AlamatMuatLCLAccesses(
      portCode: json['port_code'] as String? ?? '',
      namaGudang: json['nama_gudang'] as String? ?? '',
      alamat: json['alamat'] as String? ?? '',
      loctId: json['loct_id'] as String? ?? '',
    );

Map<String, dynamic> _$AlamatMuatLCLAccessesToJson(
        AlamatMuatLCLAccesses instance) =>
    <String, dynamic>{
      'port_code': instance.portCode,
      'nama_gudang': instance.namaGudang,
      'loct_id': instance.loctId,
      'alamat': instance.alamat,
    };
