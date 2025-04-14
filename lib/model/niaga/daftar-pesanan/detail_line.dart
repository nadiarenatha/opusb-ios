import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:intl/intl.dart';

part 'detail_line.g.dart';

@JsonSerializable()
class DetailLineAccesses extends Equatable {
  final String? komoditi, containerSize, productDescription, uom, invoiceNum;

  final int? id, headerId, quantity;

  final double? price,
      userPanjang,
      userLebar,
      userTinggi,
      userTotalVolume,
      userTotalWeight,
      niagaPanjang,
      niagaLebar,
      niagaTinggi,
      niagaTotalVolume,
      niagaTotalWeight;

  const DetailLineAccesses({
    this.komoditi = '',
    this.id = 0,
    this.headerId = 0,
    this.price = 0,
    this.containerSize = '',
    this.productDescription = '',
    this.quantity = 0,
    this.uom = '',
    this.userPanjang = 0,
    this.userLebar = 0,
    this.userTinggi = 0,
    this.userTotalVolume = 0,
    this.userTotalWeight = 0,
    this.niagaPanjang = 0,
    this.niagaLebar = 0,
    this.niagaTinggi = 0,
    this.niagaTotalVolume = 0,
    this.niagaTotalWeight = 0,
    this.invoiceNum = '',
  });

  factory DetailLineAccesses.fromJson(Map<String, dynamic> json) =>
      _$DetailLineAccessesFromJson(json);
  Map<String, dynamic> toJson() => _$DetailLineAccessesToJson(this);

  String get formattedPrice {
    if (price == null) return 'Rp0,00';

    final NumberFormat currencyFormat = NumberFormat.currency(
      locale: 'ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return currencyFormat.format(price) + ',-';
  }

  @override
  List<Object> get props => [];
}
