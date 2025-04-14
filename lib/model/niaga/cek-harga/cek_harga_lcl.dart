import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:intl/intl.dart';

part 'cek_harga_lcl.g.dart';

@JsonSerializable()
class CekHargaLCLAccesses extends Equatable {

  @JsonKey(name: 'no_kontrak')
  final String? noKontrak;
  
  @JsonKey(name: 'no_contract')
  final String? noContract;

  @JsonKey(name: 'harga_kontrak')
  final int? hargaKontrak;

  @JsonKey(name: 'estimasi_harga')
  final double? estimasiHarga;

  @JsonKey(name: 'point_digunakan')
  final int? pointDigunakan;

  final double? cbm;

  final String? point;

  const CekHargaLCLAccesses({
    this.noKontrak = '',
    this.noContract = '',
    this.hargaKontrak = 0,
    this.estimasiHarga = 0,
    this.cbm = 0,
    this.pointDigunakan = 0,
    this.point = '',
  });

  factory CekHargaLCLAccesses.fromJson(Map<String, dynamic> json) =>
      _$CekHargaLCLAccessesFromJson(json);
  Map<String, dynamic> toJson() => _$CekHargaLCLAccessesToJson(this);

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
