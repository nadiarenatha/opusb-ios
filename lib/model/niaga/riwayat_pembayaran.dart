import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:intl/intl.dart';

part 'riwayat_pembayaran.g.dart';

@JsonSerializable()
class RiwayatPembayaranAccesses extends Equatable {
  final String? email,
      orderNumber,
      invoiceNumber,
      packingListNumber,
      ruteTujuan,
      tipePengiriman,
      volume,
      payMethod,
      paidDate,
      transactionStatus;

  final double? paymentAmount;

  const RiwayatPembayaranAccesses({
    this.email = '',
    this.orderNumber = '',
    this.invoiceNumber = '',
    this.packingListNumber = '',
    this.ruteTujuan = '',
    this.tipePengiriman = '',
    this.volume = '',
    this.payMethod = '',
    this.paidDate = '',
    this.transactionStatus = '',
    this.paymentAmount = 0,
  });

  factory RiwayatPembayaranAccesses.fromJson(Map<String, dynamic> json) =>
      _$RiwayatPembayaranAccessesFromJson(json);
  Map<String, dynamic> toJson() => _$RiwayatPembayaranAccessesToJson(this);

  String get formattedTotalAmount {
    if (paymentAmount == null) return 'Rp0,00';

    final NumberFormat currencyFormat = NumberFormat.currency(
      locale: 'ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return currencyFormat.format(paymentAmount) + ',-';
  }

  @override
  List<Object> get props => [];
}
