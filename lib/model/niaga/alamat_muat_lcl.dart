import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'alamat_muat_lcl.g.dart';

@JsonSerializable()
class AlamatMuatLCLAccesses extends Equatable {

  @JsonKey(name: 'port_code')
  final String? portCode;

  @JsonKey(name: 'nama_gudang')
  final String? namaGudang;

  @JsonKey(name: 'loct_id')
  final String? loctId;

  final String? alamat;

  const AlamatMuatLCLAccesses({
    this.portCode = '',
    this.namaGudang = '',
    this.alamat = '',
    this.loctId = '',
  });

  factory AlamatMuatLCLAccesses.fromJson(Map<String, dynamic> json) =>
      _$AlamatMuatLCLAccessesFromJson(json);
  Map<String, dynamic> toJson() => _$AlamatMuatLCLAccessesToJson(this);

  @override
  List<Object> get props => [];
}
