import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:niaga_apps_mobile/model/niaga/packing_detail_niaga.dart';

part 'jadwal_kapal.g.dart';

@JsonSerializable()
class JadwalKapalNiagaAccesses extends Equatable {
  @JsonKey(name: 'VOYAGE_NO')
  final String? voyageNo;

  @JsonKey(name: 'VESSEL_NAME')
  final String? vesselName;

  @JsonKey(name: 'ETD')
  final String? etd;

  @JsonKey(name: 'ETA')
  final String? eta;

  @JsonKey(name: 'PORT_ASAL')
  final String? portAsal;

  @JsonKey(name: 'PORT_TUJUAN')
  final String? portTujuan;

  @JsonKey(name: 'SHIPPING_LINE')
  final String? shippingLine;

  @JsonKey(name: 'RUTE_PANJANG')
  final String? rutePanjang;

  @JsonKey(name: 'TGL_CLOSING')
  final String? tglClosing;

  const JadwalKapalNiagaAccesses({
    this.voyageNo = '',
    this.vesselName = '',
    this.etd = '',
    this.eta = '',
    this.portAsal = '',
    this.portTujuan = '',
    this.shippingLine = '',
    this.rutePanjang = '',
    this.tglClosing = '',
  });

  factory JadwalKapalNiagaAccesses.fromJson(Map<String, dynamic> json) =>
      _$JadwalKapalNiagaAccessesFromJson(json);
  Map<String, dynamic> toJson() => _$JadwalKapalNiagaAccessesToJson(this);

  @override
  List<Object?> get props => [
        voyageNo,
        vesselName,
        etd,
        eta,
        portAsal,
        portTujuan,
        shippingLine,
        rutePanjang,
        tglClosing
      ];
}
