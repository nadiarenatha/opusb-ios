// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'barang_dashboard.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BarangDashboardAccesses _$BarangDashboardAccessesFromJson(
        Map<String, dynamic> json) =>
    BarangDashboardAccesses(
      description: json['DESCRIPTION'] as String? ?? '',
      total: json['TOTAL'] ?? 0,
    );

Map<String, dynamic> _$BarangDashboardAccessesToJson(
        BarangDashboardAccesses instance) =>
    <String, dynamic>{
      'DESCRIPTION': instance.description,
      'TOTAL': instance.total,
    };
