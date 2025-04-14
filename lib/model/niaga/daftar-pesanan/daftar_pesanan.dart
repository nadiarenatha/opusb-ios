import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:intl/intl.dart';

part 'daftar_pesanan.g.dart';

@JsonSerializable()
class DaftarPesananAccesses extends Equatable {
  final String? createdDate,
      orderNumber,
      orderService,
      shipmentType,
      originalCity,
      destinationCity,
      statusId,
      status,
      invoiceNum,
      noOrderBoon;

  final double? amount;

  final int? id;

  final bool? point;

  const DaftarPesananAccesses({
    this.createdDate = '',
    this.orderNumber = '',
    this.orderService = '',
    this.shipmentType = '',
    this.originalCity = '',
    this.destinationCity = '',
    this.statusId = '',
    this.status = '',
    this.amount = 0,
    this.id = 0,
    this.point = false,
    this.invoiceNum = '',
    this.noOrderBoon = '',
  });

  factory DaftarPesananAccesses.fromJson(Map<String, dynamic> json) =>
      _$DaftarPesananAccessesFromJson(json);
  Map<String, dynamic> toJson() => _$DaftarPesananAccessesToJson(this);

  String get formattedAmount {
    if (amount == null) return 'Rp0,00';

    final NumberFormat currencyFormat = NumberFormat.currency(
      locale: 'ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return currencyFormat.format(amount) + ',-';
  }

  @override
  List<Object> get props => [];
}
