import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:niaga_apps_mobile/model/niaga/packing_detail_niaga.dart';

part 'port_asal_fcl.g.dart';

@JsonSerializable()
class PortAsalFCLAccesses extends Equatable {
  @JsonKey(name: 'KOTA_ASAL')
  final String? kotaAsal;

  @JsonKey(name: 'PORT_ASAL')
  final String? portAsal;

  @JsonKey(name: 'LOCID_ASAL')
  final String? locIdAsal;

  const PortAsalFCLAccesses({
    this.kotaAsal = '',
    this.portAsal = '',
    this.locIdAsal = '',
  });

  factory PortAsalFCLAccesses.fromJson(Map<String, dynamic> json) =>
      _$PortAsalFCLAccessesFromJson(json);
  Map<String, dynamic> toJson() => _$PortAsalFCLAccessesToJson(this);

  @override
  List<Object?> get props => [kotaAsal, portAsal, locIdAsal];
}
