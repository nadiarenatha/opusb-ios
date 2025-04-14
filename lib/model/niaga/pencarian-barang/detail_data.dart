import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'detail_data.g.dart';

@JsonSerializable()
class DetailDataAccesses extends Equatable {
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
  final int? volume;

  @JsonKey(name: 'QTY_ON_HAND')
  final int? qtyOnHand;


  const DetailDataAccesses({
    this.asnDate = '',
    this.namaOwner = '',
    this.customerDistribusi = '',
    this.tujuan = '',
    this.deskripsi = '',
    this.volume = 0,
    this.qtyOnHand = 0,
  });

  factory DetailDataAccesses.fromJson(Map<String, dynamic> json) =>
      _$DetailDataAccessesFromJson(json);
  Map<String, dynamic> toJson() => _$DetailDataAccessesToJson(this);

  @override
  List<Object?> get props => [
        asnDate,
        namaOwner,
        customerDistribusi,
        tujuan,
        deskripsi,
        volume,
        qtyOnHand,
      ];
}
