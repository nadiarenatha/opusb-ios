// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alamat_bongkar.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AlamatBongkarAccesses _$AlamatBongkarAccessesFromJson(
        Map<String, dynamic> json) =>
    AlamatBongkarAccesses(
      port: json['port'] as String? ?? '',
      kota: json['KOTA'] as String? ?? '',
      ownerCode: json['ownerCode'] as String? ?? '',
      email: json['email'] as String? ?? '',
      tipe: json['tipe'] as String? ?? '',
      token: json['token'] as String? ?? '',
      locID: json['LOC_ID'] as String? ?? '',
      city: json['CITY'] as String? ?? '',
      pilihAlamatBongkar: json['PILIH_ALAMAT_BONGKAR'] as String? ?? '',
      detailAlamatBongkar: json['DETAIL_ALAMAT_BONGKAR'] as String? ?? '',
      picBongkarBarang: json['PIC_BONGKAR_BARANG'] as String? ?? '',
      noTelpPicBongkar: json['NO_TELP_PIC_BONGKAR'] as String? ?? '',
      locType: json['LOC_TYPE'] as String? ?? '',
      name: json['NAME'] as String? ?? '',
    );

Map<String, dynamic> _$AlamatBongkarAccessesToJson(
        AlamatBongkarAccesses instance) =>
    <String, dynamic>{
      'port': instance.port,
      'ownerCode': instance.ownerCode,
      'email': instance.email,
      'tipe': instance.tipe,
      'token': instance.token,
      'LOC_ID': instance.locID,
      'KOTA': instance.kota,
      'CITY': instance.city,
      'PILIH_ALAMAT_BONGKAR': instance.pilihAlamatBongkar,
      'DETAIL_ALAMAT_BONGKAR': instance.detailAlamatBongkar,
      'PIC_BONGKAR_BARANG': instance.picBongkarBarang,
      'NO_TELP_PIC_BONGKAR': instance.noTelpPicBongkar,
      'LOC_TYPE': instance.locType,
      'NAME': instance.name,
    };
