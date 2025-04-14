import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'detail_data_barang.g.dart';

@JsonSerializable()
class DetailJenisBarangAccesses extends Equatable {
  @JsonKey(name: 'asn_date')
  final String? asnDate;

  @JsonKey(name: 'asn_no')
  final int? asnNo;

  @JsonKey(name: 'no_resi')
  final String? noResi;

  @JsonKey(name: 'nama_owner')
  final String? namaOwner;

  @JsonKey(name: 'customer_distribusi')
  final String? customerDistribusi;

  @JsonKey(name: 'act_volume')
  final double? actVolume;

  @JsonKey(name: 'no_pl')
  final String? noPl;

  @JsonKey(name: 'owner_code')
  final String? ownerCode;

  @JsonKey(name: 'whs_code')
  final String? whsCode;

  final String? tujuan, deskripsi;

  final int? qty;

  const DetailJenisBarangAccesses({
    this.asnDate = '',
    this.asnNo = 0,
    this.noResi = '',
    this.namaOwner = '',
    this.customerDistribusi = '',
    this.actVolume = 0,
    this.noPl = '',
    this.ownerCode = '',
    this.whsCode = '',
    this.tujuan = '',
    this.deskripsi = '',
    this.qty = 0,
  });

  factory DetailJenisBarangAccesses.fromJson(Map<String, dynamic> json) =>
      _$DetailJenisBarangAccessesFromJson(json);
  Map<String, dynamic> toJson() => _$DetailJenisBarangAccessesToJson(this);

  @override
  List<Object?> get props => [
        asnDate,
        asnNo,
        noResi,
        namaOwner,
        customerDistribusi,
        actVolume,
        noPl,
        ownerCode,
        whsCode,
        tujuan,
        deskripsi,
        qty
      ];
}
