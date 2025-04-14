// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InvoiceAccesses _$InvoiceAccessesFromJson(Map<String, dynamic> json) =>
    InvoiceAccesses(
      id: json['id'] as int? ?? 0,
      invoiceNo: json['invoiceNo'] as String? ?? '',
      type: json['type'] as String? ?? '',
      volume: json['volume'] as int? ?? 0,
      status: json['status'] as String? ?? '',
      dueDate: json['dueDate'] as String? ?? '',
    );

Map<String, dynamic> _$InvoiceAccessesToJson(InvoiceAccesses instance) =>
    <String, dynamic>{
      'id': instance.id,
      'volume': instance.volume,
      'invoiceNo': instance.invoiceNo,
      'type': instance.type,
      'status': instance.status,
      'dueDate': instance.dueDate,
    };
