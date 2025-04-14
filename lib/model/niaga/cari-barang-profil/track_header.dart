import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'track_header.g.dart';

@JsonSerializable()
class TrackHeader extends Equatable {
  @JsonKey(name: 'no_pl')
  final String? noPl;

  @JsonKey(name: 'no_resi')
  final int? noResi;

  @JsonKey(name: 'asn_no')
  final int? asnNo;

  @JsonKey(name: 'owner_code')
  final String? ownerCode;

  @JsonKey(name: 'owner_name')
  final String? ownerName;

  @JsonKey(name: 'whs_code')
  final String? whsCode;

  final String? container, keterangan;

  const TrackHeader({
    this.noPl = '',
    this.noResi = 0,
    this.asnNo = 0,
    this.ownerCode = '',
    this.ownerName = '',
    this.whsCode = '',
    this.container = '',
    this.keterangan = '',
  });

  factory TrackHeader.fromJson(Map<String, dynamic> json) =>
      _$TrackHeaderFromJson(json);
  Map<String, dynamic> toJson() => _$TrackHeaderToJson(this);

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
