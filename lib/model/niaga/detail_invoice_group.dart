import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'detail_invoice_group.g.dart';

@JsonSerializable()
class DetailInvoiceGroupAccess extends Equatable {
  @JsonKey(name: 'no_invoice')
  final String? noInvoice;

  @JsonKey(name: 'total_invoice')
  final int? totalInvoice;

  @JsonKey(name: 'no_inv_group')
  final String? noInvGroup;

  @JsonKey(name: 'no_order_boon')
  final String? noOrderBoon;

  @JsonKey(name: 'no_order_online')
  final String? noOrderOnline;

  final int? total;

  const DetailInvoiceGroupAccess({
    this.noInvoice = '',
    this.totalInvoice = 0,
    this.noInvGroup = '',
    this.total = 0,
    this.noOrderBoon = '',
    this.noOrderOnline = '',
  });

  factory DetailInvoiceGroupAccess.fromJson(Map<String, dynamic> json) =>
      _$DetailInvoiceGroupAccessFromJson(json);
  Map<String, dynamic> toJson() => _$DetailInvoiceGroupAccessToJson(this);

  @override
  List<Object?> get props => [noInvGroup, total, noOrderBoon, noOrderOnline];
}
