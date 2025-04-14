import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'master_lokasi.g.dart';

@JsonSerializable()
class MasterLokasiAccesses extends Equatable {
  @JsonKey(name: 'OWNER_CODE')
  final String? ownerCode;

  @JsonKey(name: 'LOC_ID')
  final String? locID;

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

  const MasterLokasiAccesses({
    this.ownerCode = '',
    this.locID = '',
    this.kota = '',
    this.pilihAlamatMuat = '',
    this.detailAlamatMuat = '',
    this.picMuatBarang = '',
    this.noTelpPicMuat = '',
    this.locType = '',
  });

  factory MasterLokasiAccesses.fromJson(Map<String, dynamic> json) =>
      _$MasterLokasiAccessesFromJson(json);
  Map<String, dynamic> toJson() => _$MasterLokasiAccessesToJson(this);

  @override
  List<Object> get props => [];
}
