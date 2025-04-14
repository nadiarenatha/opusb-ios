import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'detail_invoice_group.dart';

part 'invoice_group.g.dart';

@JsonSerializable()
class InvoiceGroupAccesses extends Equatable {
  final List<DetailInvoiceGroupAccess> invoices;

  const InvoiceGroupAccesses({
    required this.invoices,
  });

  factory InvoiceGroupAccesses.fromJson(Map<String, dynamic> json) =>
      _$InvoiceGroupAccessesFromJson(json);
  Map<String, dynamic> toJson() => _$InvoiceGroupAccessesToJson(this);

  @override
  List<Object> get props => [];
}
