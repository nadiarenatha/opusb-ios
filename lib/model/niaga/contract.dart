import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:intl/intl.dart';

part 'contract.g.dart';

@JsonSerializable()
class ContractAccesses extends Equatable {

  @JsonKey(name: 'CONTRACT_NO')
  final String? contractNo;

  @JsonKey(name: 'PORT_ASAL')
  final String? portAsal;

  @JsonKey(name: 'PORT_TUJUAN')
  final String? portTujuan;

  @JsonKey(name: 'PELAYARAN')
  final String? pelayaran;

  @JsonKey(name: 'PENGIRIMAN')
  final String? pengiriman;

  @JsonKey(name: 'HARGA')
  final int? harga;

  const ContractAccesses({
    this.contractNo = '',
    this.portAsal = '',
    this.portTujuan = '',
    this.pelayaran = '',
    this.pengiriman = '',
    this.harga = 0,
  });

  factory ContractAccesses.fromJson(Map<String, dynamic> json) =>
      _$ContractAccessesFromJson(json);
  Map<String, dynamic> toJson() => _$ContractAccessesToJson(this);

  String get formattedHarga {
    final NumberFormat currencyFormat = NumberFormat.currency(
      locale: 'ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return currencyFormat.format(harga) + ',-';
  }

  @override
  List<Object> get props => [];
}
