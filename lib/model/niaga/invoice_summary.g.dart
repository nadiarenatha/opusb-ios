// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InvoiceSummaryAccesses _$InvoiceSummaryAccessesFromJson(
        Map<String, dynamic> json) =>
    InvoiceSummaryAccesses(
      totalTagihan: json['total_tagihan'] as int? ?? 0,
      data: json['data'] as String? ?? '',
    );

Map<String, dynamic> _$InvoiceSummaryAccessesToJson(
        InvoiceSummaryAccesses instance) =>
    <String, dynamic>{
      'total_tagihan': instance.totalTagihan,
      'data': instance.data,
    };
