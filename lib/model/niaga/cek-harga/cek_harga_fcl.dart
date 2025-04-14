import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:intl/intl.dart';

part 'cek_harga_fcl.g.dart';

@JsonSerializable()
class CekHargaFCLAccesses extends Equatable {

  @JsonKey(name: 'no_kontrak')
  final String? noKontrak;

  @JsonKey(name: 'no_contract')
  final String? noContract;

  @JsonKey(name: 'harga_kontrak')
  final int? hargaKontrak;

  @JsonKey(name: 'estimasi_harga')
  final int? estimasiHarga;

  @JsonKey(name: 'point_digunakan')
  final int? pointDigunakan;

  final int? qty;

  final String? point;

  const CekHargaFCLAccesses({
    this.noKontrak = '',
    this.noContract = '',
    this.hargaKontrak = 0,
    this.estimasiHarga = 0,
    this.qty = 0,
    this.point = '',
    this.pointDigunakan = 0,
  });

  factory CekHargaFCLAccesses.fromJson(Map<String, dynamic> json) =>
      _$CekHargaFCLAccessesFromJson(json);
  Map<String, dynamic> toJson() => _$CekHargaFCLAccessesToJson(this);

  String get formattedEstimasiHarga {
    final NumberFormat currencyFormat = NumberFormat.currency(
      locale: 'ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return currencyFormat.format(estimasiHarga) + ',-';
  }

  @override
  List<Object> get props => [];
}
