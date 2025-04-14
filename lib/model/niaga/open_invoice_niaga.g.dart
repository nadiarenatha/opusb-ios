// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'open_invoice_niaga.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OpenInvoiceAccesses _$OpenInvoiceAccessesFromJson(Map<String, dynamic> json) =>
    OpenInvoiceAccesses(
      totalRow: json['total_row'] as int? ?? 0,
      page: json['page'] as int? ?? 0,
      size: json['size'] as int? ?? 0,
      totalPage: json['total_page'] as int? ?? 0,
      data: (json['data'] as List<dynamic>)
          .map((e) => InvoiceItemAccesses.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$OpenInvoiceAccessesToJson(
        OpenInvoiceAccesses instance) =>
    <String, dynamic>{
      'total_row': instance.totalRow,
      'page': instance.page,
      'size': instance.size,
      'total_page': instance.totalPage,
      'data': instance.data,
    };
