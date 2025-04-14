// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alamat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AlamatAccesses _$AlamatAccessesFromJson(Map<String, dynamic> json) =>
    AlamatAccesses(
      port: json['port'] as String? ?? '',
      kota: json['KOTA'] as String? ?? '',
      ownerCode: json['ownerCode'] as String? ?? '',
      email: json['email'] as String? ?? '',
      tipe: json['tipe'] as String? ?? '',
      token: json['token'] as String? ?? '',
      locID: json['LOC_ID'] as String? ?? '',
      city: json['CITY'] as String? ?? '',
      pilihAlamatMuat: json['PILIH_ALAMAT_MUAT'] as String? ?? '',
      detailAlamatMuat: json['DETAIL_ALAMAT_MUAT'] as String? ?? '',
      picMuatBarang: json['PIC_MUAT_BARANG'] as String? ?? '',
      noTelpPicMuat: json['NO_TELP_PIC_MUAT'] as String? ?? '',
      locType: json['LOC_TYPE'] as String? ?? '',
      name: json['NAME'] as String? ?? '',
    );

Map<String, dynamic> _$AlamatAccessesToJson(AlamatAccesses instance) =>
    <String, dynamic>{
      'port': instance.port,
      'ownerCode': instance.ownerCode,
      'email': instance.email,
      'tipe': instance.tipe,
      'token': instance.token,
      'LOC_ID': instance.locID,
      'CITY': instance.city,
      'KOTA': instance.kota,
      'PILIH_ALAMAT_MUAT': instance.pilihAlamatMuat,
      'DETAIL_ALAMAT_MUAT': instance.detailAlamatMuat,
      'PIC_MUAT_BARANG': instance.picMuatBarang,
      'NO_TELP_PIC_MUAT': instance.noTelpPicMuat,
      'LOC_TYPE': instance.locType,
      'NAME': instance.name,
    };
