import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
part 'invoice_detail.g.dart';

@JsonSerializable()
class InvoiceDetailAccesses extends Equatable {
  final int? id, qty, meInvoiceId;
  final double? price, amount, pph;
  final String? item;
  const InvoiceDetailAccesses({
    this.id = 0,
    this.price = 0,
    this.amount = 0,
    this.qty = 0,
    this.pph = 0,
    this.meInvoiceId = 0,
    this.item = '',
  });

  factory InvoiceDetailAccesses.fromJson(Map<String, dynamic> json) =>
      _$InvoiceDetailAccessesFromJson(json);
  Map<String, dynamic> toJson() => _$InvoiceDetailAccessesToJson(this);

  @override
  List<Object> get props => [];
}
