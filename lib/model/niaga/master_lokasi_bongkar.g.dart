// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'master_lokasi_bongkar.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MasterLokasiBongkarAccesses _$MasterLokasiBongkarAccessesFromJson(
        Map<String, dynamic> json) =>
    MasterLokasiBongkarAccesses(
      custCode: json['CUST_CODE'] as String? ?? '',
      kota: json['KOTA'] as String? ?? '',
      locID: json['LOC_ID'] as String? ?? '',
      pilihAlamatBongkar: json['PILIH_ALAMAT_BONGKAR'] as String? ?? '',
      detailAlamatBongkar: json['DETAIL_ALAMAT_BONGKAR'] as String? ?? '',
      picBongkarBarang: json['PIC_BONGKAR_BARANG'] as String? ?? '',
      noTelpPicBongkar: json['NO_TELP_PIC_BONGKAR'] as String? ?? '',
      locType: json['LOC_TYPE'] as String? ?? '',
    );

Map<String, dynamic> _$MasterLokasiBongkarAccessesToJson(
        MasterLokasiBongkarAccesses instance) =>
    <String, dynamic>{
      'CUST_CODE': instance.custCode,
      'LOC_ID': instance.locID,
      'KOTA': instance.kota,
      'PILIH_ALAMAT_BONGKAR': instance.pilihAlamatBongkar,
      'DETAIL_ALAMAT_BONGKAR': instance.detailAlamatBongkar,
      'PIC_BONGKAR_BARANG': instance.picBongkarBarang,
      'NO_TELP_PIC_BONGKAR': instance.noTelpPicBongkar,
      'LOC_TYPE': instance.locType,
    };
