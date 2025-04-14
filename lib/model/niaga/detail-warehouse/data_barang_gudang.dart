import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'data_barang_gudang.g.dart';

@JsonSerializable()
class BarangGudangDataAccesses extends Equatable {
  @JsonKey(name: 'ASN_DATE')
  final String? asnDate;

  @JsonKey(name: 'NAMA_OWNER')
  final String? namaOwner;

  @JsonKey(name: 'CUSTOMER_DISTRIBUSI')
  final String? customerDistribusi;

  @JsonKey(name: 'TUJUAN')
  final String? tujuan;

  @JsonKey(name: 'DESKRIPSI')
  final String? deskripsi;

  @JsonKey(name: 'VOLUME')
  final double volume;

  @JsonKey(name: 'QTY_ON_HAND')
  final int qtyOnHand;

  const BarangGudangDataAccesses({
    this.asnDate = '',
    this.namaOwner = '',
    this.customerDistribusi = '',
    this.tujuan = '',
    this.deskripsi = '',
    this.volume = 0,
    this.qtyOnHand = 0,
  });

  factory BarangGudangDataAccesses.fromJson(Map<String, dynamic> json) =>
      _$BarangGudangDataAccessesFromJson(json);
  Map<String, dynamic> toJson() => _$BarangGudangDataAccessesToJson(this);

  @override
  List<Object?> get props => [
        asnDate,
        namaOwner,
        customerDistribusi,
        tujuan,
        deskripsi,
        volume,
        qtyOnHand
      ];
}
