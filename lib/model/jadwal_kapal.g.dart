// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'jadwal_kapal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JadwalKapalAccesses _$JadwalKapalAccessesFromJson(Map<String, dynamic> json) =>
    JadwalKapalAccesses(
      id: json['id'] as int? ?? 0,
      shipName: json['shipName'] as String? ?? '',
      voyageNo: json['voyageNo'] as String? ?? '',
      closingDate: json['closingDate'] as String? ?? '',
      rute: json['rute'] as String? ?? '',
      rutePanjang: json['rutePanjang'] as String? ?? '',
      eta: json['eta'] as String? ?? '',
      etd: json['etd'] as String? ?? '',
    );

Map<String, dynamic> _$JadwalKapalAccessesToJson(
        JadwalKapalAccesses instance) =>
    <String, dynamic>{
      'id': instance.id,
      'shipName': instance.shipName,
      'voyageNo': instance.voyageNo,
      'closingDate': instance.closingDate,
      'rute': instance.rute,
      'rutePanjang': instance.rutePanjang,
      'eta': instance.eta,
      'etd': instance.etd,
    };
