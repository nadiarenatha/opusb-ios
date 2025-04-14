import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
part 'invoice.g.dart';

@JsonSerializable()
class InvoiceAccesses extends Equatable {
  final int? id, volume;
  final String? invoiceNo, type, status, dueDate;
  const InvoiceAccesses({
    this.id = 0,
    this.invoiceNo = '',
    this.type = '',
    this.volume = 0,
    this.status = '',
    this.dueDate = '',
  });

  factory InvoiceAccesses.fromJson(Map<String, dynamic> json) =>
      _$InvoiceAccessesFromJson(json);
  Map<String, dynamic> toJson() => _$InvoiceAccessesToJson(this);

  @override
  List<Object> get props => [];
}
