// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'detail_invoice_group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DetailInvoiceGroupAccess _$DetailInvoiceGroupAccessFromJson(
        Map<String, dynamic> json) =>
    DetailInvoiceGroupAccess(
      noInvoice: json['no_invoice'] as String? ?? '',
      totalInvoice: json['total_invoice'] as int? ?? 0,
      noInvGroup: json['no_inv_group'] as String? ?? '',
      total: json['total'] as int? ?? 0,
      noOrderBoon: json['no_order_boon'] as String? ?? '',
      noOrderOnline: json['no_order_online'] as String? ?? '',
    );

Map<String, dynamic> _$DetailInvoiceGroupAccessToJson(
        DetailInvoiceGroupAccess instance) =>
    <String, dynamic>{
      'no_invoice': instance.noInvoice,
      'total_invoice': instance.totalInvoice,
      'no_inv_group': instance.noInvGroup,
      'no_order_boon': instance.noOrderBoon,
      'no_order_online': instance.noOrderOnline,
      'total': instance.total,
    };
