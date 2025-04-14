import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'warehouse_detail_niaga.g.dart';

@JsonSerializable()
class WarehouseItemAccesses extends Equatable {
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

  @JsonKey(name: 'NO_RESI')
  final String? noResi;

  @JsonKey(name: 'DIVISION')
  final String? division;

  const WarehouseItemAccesses({
    this.asnNo = '',
    this.tanggalMasuk = '',
    this.customerDistribusi = '',
    this.tujuan = '',
    this.totalVolume = 0,
    this.division = '',
    this.noResi = '',
  });

  factory WarehouseItemAccesses.fromJson(Map<String, dynamic> json) =>
      _$WarehouseItemAccessesFromJson(json);
  Map<String, dynamic> toJson() => _$WarehouseItemAccessesToJson(this);

  @override
  List<Object?> get props => [
        asnNo,
        tanggalMasuk,
        customerDistribusi,
        tujuan,
        totalVolume,
        division,
        noResi,
      ];
}
