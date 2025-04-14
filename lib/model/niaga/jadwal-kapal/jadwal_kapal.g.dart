// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'jadwal_kapal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JadwalKapalNiagaAccesses _$JadwalKapalNiagaAccessesFromJson(
        Map<String, dynamic> json) =>
    JadwalKapalNiagaAccesses(
      voyageNo: json['VOYAGE_NO'] as String? ?? '',
      vesselName: json['VESSEL_NAME'] as String? ?? '',
      etd: json['ETD'] as String? ?? '',
      eta: json['ETA'] as String? ?? '',
      portAsal: json['PORT_ASAL'] as String? ?? '',
      portTujuan: json['PORT_TUJUAN'] as String? ?? '',
      shippingLine: json['SHIPPING_LINE'] as String? ?? '',
      rutePanjang: json['RUTE_PANJANG'] as String? ?? '',
      tglClosing: json['TGL_CLOSING'] as String? ?? '',
    );

Map<String, dynamic> _$JadwalKapalNiagaAccessesToJson(
        JadwalKapalNiagaAccesses instance) =>
    <String, dynamic>{
      'VOYAGE_NO': instance.voyageNo,
      'VESSEL_NAME': instance.vesselName,
      'ETD': instance.etd,
      'ETA': instance.eta,
      'PORT_ASAL': instance.portAsal,
      'PORT_TUJUAN': instance.portTujuan,
      'SHIPPING_LINE': instance.shippingLine,
      'RUTE_PANJANG': instance.rutePanjang,
      'TGL_CLOSING': instance.tglClosing,
    };
