import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'detail_header.g.dart';

@JsonSerializable()
class DetailHeaderAccesses extends Equatable {
  @JsonKey(name: 'ASN_NO')
  final String? asnNo;

  @JsonKey(name: 'TANGGAL_MASUK')
  final String? tanggalMasuk;

  @JsonKey(name: 'CUSTOMER_DISTRIBUSI')
  final String? customerDistribusi;

  @JsonKey(name: 'TUJUAN')
  final String? tujuan;

  @JsonKey(name: 'TOTAL_VOLUME')
  final int? totalVolume;

  @JsonKey(name: 'DIVISION')
  final String? division;

  const DetailHeaderAccesses({
    this.asnNo = '',
    this.tanggalMasuk = '',
    this.customerDistribusi = '',
    this.tujuan = '',
    this.totalVolume = 0,
    this.division = '',
  });

  factory DetailHeaderAccesses.fromJson(Map<String, dynamic> json) =>
      _$DetailHeaderAccessesFromJson(json);
  Map<String, dynamic> toJson() => _$DetailHeaderAccessesToJson(this);

  @override
  List<Object?> get props => [
        asnNo,
        tanggalMasuk,
        customerDistribusi,
        tujuan,
        totalVolume,
        division,
      ];
}
