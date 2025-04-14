// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'master_lokasi.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MasterLokasiAccesses _$MasterLokasiAccessesFromJson(
        Map<String, dynamic> json) =>
    MasterLokasiAccesses(
      ownerCode: json['OWNER_CODE'] as String? ?? '',
      locID: json['LOC_ID'] as String? ?? '',
      kota: json['KOTA'] as String? ?? '',
      pilihAlamatMuat: json['PILIH_ALAMAT_MUAT'] as String? ?? '',
      detailAlamatMuat: json['DETAIL_ALAMAT_MUAT'] as String? ?? '',
      picMuatBarang: json['PIC_MUAT_BARANG'] as String? ?? '',
      noTelpPicMuat: json['NO_TELP_PIC_MUAT'] as String? ?? '',
      locType: json['LOC_TYPE'] as String? ?? '',
    );

Map<String, dynamic> _$MasterLokasiAccessesToJson(
        MasterLokasiAccesses instance) =>
    <String, dynamic>{
      'OWNER_CODE': instance.ownerCode,
      'LOC_ID': instance.locID,
      'KOTA': instance.kota,
      'PILIH_ALAMAT_MUAT': instance.pilihAlamatMuat,
      'DETAIL_ALAMAT_MUAT': instance.detailAlamatMuat,
      'PIC_MUAT_BARANG': instance.picMuatBarang,
      'NO_TELP_PIC_MUAT': instance.noTelpPicMuat,
      'LOC_TYPE': instance.locType,
    };
