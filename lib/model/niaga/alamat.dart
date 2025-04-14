import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'alamat.g.dart';

@JsonSerializable()
class AlamatAccesses extends Equatable {

  final String? port, ownerCode, email, tipe, token;

  @JsonKey(name: 'LOC_ID')
  final String? locID;

  @JsonKey(name: 'CITY')
  final String? city;

  @JsonKey(name: 'KOTA')
  final String? kota;

  @JsonKey(name: 'PILIH_ALAMAT_MUAT')
  final String? pilihAlamatMuat;

  @JsonKey(name: 'DETAIL_ALAMAT_MUAT')
  final String? detailAlamatMuat;

  @JsonKey(name: 'PIC_MUAT_BARANG')
  final String? picMuatBarang;

  @JsonKey(name: 'NO_TELP_PIC_MUAT')
  final String? noTelpPicMuat;

  @JsonKey(name: 'LOC_TYPE')
  final String? locType;

  @JsonKey(name: 'NAME')
  final String? name;

  const AlamatAccesses({
    this.port = '',
    this.kota = '',
    this.ownerCode = '',
    this.email = '',
    this.tipe = '',
    this.token = '',
    this.locID = '',
    this.city = '',
    this.pilihAlamatMuat = '',
    this.detailAlamatMuat = '',
    this.picMuatBarang = '',
    this.noTelpPicMuat = '',
    this.locType = '',
    this.name = '',
  });

  factory AlamatAccesses.fromJson(Map<String, dynamic> json) =>
      _$AlamatAccessesFromJson(json);
  Map<String, dynamic> toJson() => _$AlamatAccessesToJson(this);

  @override
  List<Object> get props => [];
}
