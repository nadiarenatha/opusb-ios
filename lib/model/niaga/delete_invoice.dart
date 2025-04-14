import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'delete_invoice.g.dart';

@JsonSerializable()
class DeleteInvoiceAccess extends Equatable {
  @JsonKey(name: 'no_invoice_group ')
  final String? noInvoiceGroup;

  const DeleteInvoiceAccess({
    this.noInvoiceGroup = '',
  });

  factory DeleteInvoiceAccess.fromJson(Map<String, dynamic> json) =>
      _$DeleteInvoiceAccessFromJson(json);
  Map<String, dynamic> toJson() => _$DeleteInvoiceAccessToJson(this);

  @override
   List<Object?> get props => [];
}
