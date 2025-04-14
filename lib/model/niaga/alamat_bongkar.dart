import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'alamat_bongkar.g.dart';

@JsonSerializable()
class AlamatBongkarAccesses extends Equatable {

  final String? port, ownerCode, email, tipe, token;

  @JsonKey(name: 'LOC_ID')
  final String? locID;

  @JsonKey(name: 'KOTA')
  final String? kota;

  @JsonKey(name: 'CITY')
  final String? city;

  @JsonKey(name: 'PILIH_ALAMAT_BONGKAR')
  final String? pilihAlamatBongkar;

  @JsonKey(name: 'DETAIL_ALAMAT_BONGKAR')
  final String? detailAlamatBongkar;

  @JsonKey(name: 'PIC_BONGKAR_BARANG')
  final String? picBongkarBarang;

  @JsonKey(name: 'NO_TELP_PIC_BONGKAR')
  final String? noTelpPicBongkar;

  @JsonKey(name: 'LOC_TYPE')
  final String? locType;

  @JsonKey(name: 'NAME')
  final String? name;

  const AlamatBongkarAccesses({
    this.port = '',
    this.kota = '',
    this.ownerCode = '',
    this.email = '',
    this.tipe = '',
    this.token = '',
    this.locID = '',
    this.city = '',
    this.pilihAlamatBongkar = '',
    this.detailAlamatBongkar = '',
    this.picBongkarBarang = '',
    this.noTelpPicBongkar = '',
    this.locType = '',
    this.name = '',
  });

  factory AlamatBongkarAccesses.fromJson(Map<String, dynamic> json) =>
      _$AlamatBongkarAccessesFromJson(json);
  Map<String, dynamic> toJson() => _$AlamatBongkarAccessesToJson(this);

  @override
  List<Object> get props => [];
}
