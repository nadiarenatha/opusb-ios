import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'header_barang_gudang.g.dart';

@JsonSerializable()
class BarangGudangHeaderAccesses extends Equatable {
  @JsonKey(name: 'ASN_NO')
  final String? asnNo;

  @JsonKey(name: 'TANGGAL_MASUK')
  final String? tanggalMasuk;

  @JsonKey(name: 'CUSTOMER_DISTRIBUSI')
  final String? customerDistribusi;

  @JsonKey(name: 'TUJUAN')
  final String? tujuan;

  @JsonKey(name: 'TOTAL_VOLUME')
  final double? totalVolume;

  @JsonKey(name: 'DIVISION')
  final String? division;

  const BarangGudangHeaderAccesses({
    this.asnNo = '',
    this.tanggalMasuk = '',
    this.customerDistribusi = '',
    this.tujuan = '',
    this.totalVolume = 0,
    this.division = '',
  });

  factory BarangGudangHeaderAccesses.fromJson(Map<String, dynamic> json) =>
      _$BarangGudangHeaderAccessesFromJson(json);
  Map<String, dynamic> toJson() => _$BarangGudangHeaderAccessesToJson(this);

  @override
  List<Object?> get props => [
        asnNo,
        tanggalMasuk,
        customerDistribusi,
        tujuan,
        totalVolume,
        division
      ];
}
