// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice_group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InvoiceGroupAccesses _$InvoiceGroupAccessesFromJson(
        Map<String, dynamic> json) =>
    InvoiceGroupAccesses(
      invoices: (json['invoices'] as List<dynamic>)
          .map((e) =>
              DetailInvoiceGroupAccess.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$InvoiceGroupAccessesToJson(
        InvoiceGroupAccesses instance) =>
    <String, dynamic>{
      'invoices': instance.invoices,
    };
