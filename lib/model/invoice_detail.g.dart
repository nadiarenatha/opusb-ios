// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InvoiceDetailAccesses _$InvoiceDetailAccessesFromJson(
        Map<String, dynamic> json) =>
    InvoiceDetailAccesses(
      id: json['id'] as int? ?? 0,
      price: (json['price'] as num?)?.toDouble() ?? 0,
      amount: (json['amount'] as num?)?.toDouble() ?? 0,
      qty: json['qty'] as int? ?? 0,
      pph: (json['pph'] as num?)?.toDouble() ?? 0,
      meInvoiceId: json['meInvoiceId'] as int? ?? 0,
      item: json['item'] as String? ?? '',
    );

Map<String, dynamic> _$InvoiceDetailAccessesToJson(
        InvoiceDetailAccesses instance) =>
    <String, dynamic>{
      'id': instance.id,
      'qty': instance.qty,
      'meInvoiceId': instance.meInvoiceId,
      'price': instance.price,
      'amount': instance.amount,
      'pph': instance.pph,
      'item': instance.item,
    };
