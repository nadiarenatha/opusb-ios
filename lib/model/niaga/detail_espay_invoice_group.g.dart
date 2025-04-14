// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'detail_espay_invoice_group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DetailEspayInvoiceGroupAccesses _$DetailEspayInvoiceGroupAccessesFromJson(
        Map<String, dynamic> json) =>
    DetailEspayInvoiceGroupAccesses(
      noInvoiceAsli: json['no_invoice_asli'] as String? ?? '',
      totalInvoiceAsli: json['total_invoice_asli'] as int? ?? 0,
    );

Map<String, dynamic> _$DetailEspayInvoiceGroupAccessesToJson(
        DetailEspayInvoiceGroupAccesses instance) =>
    <String, dynamic>{
      'no_invoice_asli': instance.noInvoiceAsli,
      'total_invoice_asli': instance.totalInvoiceAsli,
    };
