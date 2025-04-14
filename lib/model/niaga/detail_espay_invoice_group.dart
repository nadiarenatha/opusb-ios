import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:intl/intl.dart';

part 'detail_espay_invoice_group.g.dart';

@JsonSerializable()
class DetailEspayInvoiceGroupAccesses extends Equatable {
  @JsonKey(name: 'no_invoice_asli')
  final String? noInvoiceAsli;

  @JsonKey(name: 'total_invoice_asli')
  final int? totalInvoiceAsli;

  const DetailEspayInvoiceGroupAccesses({
    this.noInvoiceAsli = '',
    this.totalInvoiceAsli = 0,
  });

  factory DetailEspayInvoiceGroupAccesses.fromJson(Map<String, dynamic> json) =>
      _$DetailEspayInvoiceGroupAccessesFromJson(json);
  Map<String, dynamic> toJson() =>
      _$DetailEspayInvoiceGroupAccessesToJson(this);

  String get formattedTotalInvoiceAsli {
    if (totalInvoiceAsli == null) return 'Rp0,00';

    final NumberFormat currencyFormat = NumberFormat.currency(
      locale: 'ID',
      symbol: 'Rp ',
      decimalDigits: 2,
    );

    return currencyFormat.format(totalInvoiceAsli);
  }

  @override
  List<Object?> get props => [noInvoiceAsli, totalInvoiceAsli];
}
