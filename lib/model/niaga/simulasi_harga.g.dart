// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'simulasi_harga.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SimulasiHargaAccesses _$SimulasiHargaAccessesFromJson(
        Map<String, dynamic> json) =>
    SimulasiHargaAccesses(
      kotaAsal: json['KOTA_ASAL'] as String? ?? '',
      portAsal: json['PORT_ASAL'] as String? ?? '',
      kotaTujuan: json['KOTA_TUJUAN'] as String? ?? '',
      portTujuan: json['PORT_TUJUAN'] as String? ?? '',
      jenisPengiriman: json['JENIS_PENGIRIMAN'] as String? ?? '',
      harga: json['HARGA'],
      caption: json['caption'] as String? ?? '',
      url: json['url'] as String? ?? '',
      message: json['message'] as String? ?? '',
    );

Map<String, dynamic> _$SimulasiHargaAccessesToJson(
        SimulasiHargaAccesses instance) =>
    <String, dynamic>{
      'KOTA_ASAL': instance.kotaAsal,
      'PORT_ASAL': instance.portAsal,
      'KOTA_TUJUAN': instance.kotaTujuan,
      'PORT_TUJUAN': instance.portTujuan,
      'JENIS_PENGIRIMAN': instance.jenisPengiriman,
      'HARGA': instance.harga,
      'message': instance.message,
      'caption': instance.caption,
      'url': instance.url,
    };
