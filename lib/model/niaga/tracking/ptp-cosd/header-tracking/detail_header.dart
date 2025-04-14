import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'detail_header.g.dart';

@JsonSerializable()
class HeaderItemTrackingAccesses extends Equatable {
  @JsonKey(name: 'no_pl')
  final String? noPl;

  @JsonKey(name: 'no_resi')
  final String? noResi;

  @JsonKey(name: 'asn_no')
  final String? asnNo;

  @JsonKey(name: 'owner_code')
  final String? ownerCode;

  @JsonKey(name: 'owner_name')
  final String? ownerName;

  @JsonKey(name: 'whs_code')
  final String? whsCode;

  final String? container, keterangan;

  const HeaderItemTrackingAccesses({
    this.noPl = '',
    this.noResi = '',
    this.asnNo = '',
    this.ownerCode = '',
    this.ownerName = '',
    this.whsCode = '',
    this.container = '',
    this.keterangan = '',
  });

  factory HeaderItemTrackingAccesses.fromJson(Map<String, dynamic> json) =>
      _$HeaderItemTrackingAccessesFromJson(json);
  Map<String, dynamic> toJson() => _$HeaderItemTrackingAccessesToJson(this);

  @override
  List<Object?> get props => [
        noPl,
        noResi,
        asnNo,
        ownerCode,
        ownerName,
        whsCode,
        container,
        keterangan
      ];
}
