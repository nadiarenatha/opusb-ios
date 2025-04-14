import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:niaga_apps_mobile/model/niaga/packing_detail_niaga.dart';

part 'port_tujuan_fcl.g.dart';

@JsonSerializable()
class PortTujuanFCLAccesses extends Equatable {
  @JsonKey(name: 'KOTA_TUJUAN')
  final String? kotaTujuan;

  @JsonKey(name: 'PORT_TUJUAN')
  final String? portTujuan;

  @JsonKey(name: 'LOCID_TUJUAN')
  final String? locIdTujuan;

  const PortTujuanFCLAccesses({
    this.kotaTujuan = '',
    this.portTujuan = '',
    this.locIdTujuan = '',
  });

  factory PortTujuanFCLAccesses.fromJson(Map<String, dynamic> json) =>
      _$PortTujuanFCLAccessesFromJson(json);
  Map<String, dynamic> toJson() => _$PortTujuanFCLAccessesToJson(this);

  @override
  List<Object?> get props => [kotaTujuan, portTujuan];
}
