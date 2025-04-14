import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'close_invoice_detail_niaga.dart';

part 'close_invoice_niaga.g.dart';

@JsonSerializable()
class CloseInvoiceAccesses extends Equatable {
  @JsonKey(name: 'total_row')
  final int? totalRow;

  final int? page, size;

  @JsonKey(name: 'total_page')
  final int? totalPage;

  final List<InvoiceCloseItemAccesses> data;

  const CloseInvoiceAccesses({
    this.totalRow = 0,
    this.page = 0,
    this.size = 0,
    this.totalPage = 0,
    required this.data,
  });

  factory CloseInvoiceAccesses.fromJson(Map<String, dynamic> json) =>
      _$CloseInvoiceAccessesFromJson(json);
  Map<String, dynamic> toJson() => _$CloseInvoiceAccessesToJson(this);

  @override
  List<Object?> get props => [totalRow, page, size, totalPage, data];
}
