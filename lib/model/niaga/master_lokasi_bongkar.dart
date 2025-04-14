import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'master_lokasi_bongkar.g.dart';

@JsonSerializable()
class MasterLokasiBongkarAccesses extends Equatable {
  @JsonKey(name: 'CUST_CODE')
  final String? custCode;

  @JsonKey(name: 'LOC_ID')
  final String? locID;

  @JsonKey(name: 'KOTA')
  final String? kota;

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

  const MasterLokasiBongkarAccesses({
    this.custCode = '',
    this.kota = '',
    this.locID = '',
    this.pilihAlamatBongkar = '',
    this.detailAlamatBongkar = '',
    this.picBongkarBarang = '',
    this.noTelpPicBongkar = '',
    this.locType = '',
  });

  factory MasterLokasiBongkarAccesses.fromJson(Map<String, dynamic> json) =>
      _$MasterLokasiBongkarAccessesFromJson(json);
  Map<String, dynamic> toJson() => _$MasterLokasiBongkarAccessesToJson(this);

  @override
  List<Object> get props => [];
}
