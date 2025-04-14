import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'open_invoice_detail_niaga.dart';

part 'open_invoice_niaga.g.dart';

@JsonSerializable()
class OpenInvoiceAccesses extends Equatable {
  @JsonKey(name: 'total_row')
  final int? totalRow;

  final int? page, size;

  @JsonKey(name: 'total_page')
  final int? totalPage;

  final List<InvoiceItemAccesses> data;

  const OpenInvoiceAccesses({
    this.totalRow = 0,
    this.page = 0,
    this.size = 0,
    this.totalPage = 0,
    required this.data,
  });

  factory OpenInvoiceAccesses.fromJson(Map<String, dynamic> json) =>
      _$OpenInvoiceAccessesFromJson(json);
  Map<String, dynamic> toJson() => _$OpenInvoiceAccessesToJson(this);

  @override
  List<Object?> get props => [totalRow, page, size, totalPage, data];
}
