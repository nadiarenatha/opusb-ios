// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tiba.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TrackingItemTibaAccesses _$TrackingItemTibaAccessesFromJson(
        Map<String, dynamic> json) =>
    TrackingItemTibaAccesses(
      namaCustomerTiba: json['nama_customer_tiba'] as String? ?? '',
      tanggalTiba: json['tanggal_tiba'] as String? ?? '',
    );

Map<String, dynamic> _$TrackingItemTibaAccessesToJson(
        TrackingItemTibaAccesses instance) =>
    <String, dynamic>{
      'nama_customer_tiba': instance.namaCustomerTiba,
      'tanggal_tiba': instance.tanggalTiba,
    };
