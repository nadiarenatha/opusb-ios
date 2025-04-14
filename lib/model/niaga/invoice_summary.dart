import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:intl/intl.dart';

part 'invoice_summary.g.dart';

@JsonSerializable()
class InvoiceSummaryAccesses extends Equatable {
  @JsonKey(name: 'total_tagihan')
  final int? totalTagihan;

  final String? data;

  const InvoiceSummaryAccesses({
    this.totalTagihan = 0,
    this.data = '',
  });

  factory InvoiceSummaryAccesses.fromJson(Map<String, dynamic> json) =>
      _$InvoiceSummaryAccessesFromJson(json);
  Map<String, dynamic> toJson() => _$InvoiceSummaryAccessesToJson(this);

  String get formattedTotalTagihan {
    if (totalTagihan == null) return 'Rp 0';

    final NumberFormat currencyFormat = NumberFormat.currency(
      locale: 'ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return currencyFormat.format(totalTagihan);
  }

  @override
  List<Object?> get props => [totalTagihan, data];
}
