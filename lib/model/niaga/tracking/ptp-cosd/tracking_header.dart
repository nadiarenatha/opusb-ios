import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tracking_header.g.dart';

@JsonSerializable()
class TrackingItemHeaderAccesses extends Equatable {
  @JsonKey(name: 'no_pl')
  final String? nopl;

  @JsonKey(name: 'no_resi')
  final String? noresi;

  @JsonKey(name: 'asn_no')
  final String? asnNo;

  @JsonKey(name: 'owner_code')
  final String? ownerCode;

  @JsonKey(name: 'owner_name')
  final String? ownerName;

  @JsonKey(name: 'whs_code')
  final String? whsCode;

  final String? container, keterangan;

  const TrackingItemHeaderAccesses({
    this.nopl = '',
    this.noresi = '',
    this.asnNo = '',
    this.ownerCode = '',
    this.ownerName = '',
    this.whsCode = '',
    this.container = '',
    this.keterangan = '',
  });

  factory TrackingItemHeaderAccesses.fromJson(Map<String, dynamic> json) =>
      _$TrackingItemHeaderAccessesFromJson(json);
  Map<String, dynamic> toJson() => _$TrackingItemHeaderAccessesToJson(this);

  @override
  List<Object?> get props => [
        nopl,
        noresi,
        asnNo,
        ownerCode,
        ownerName,
        whsCode,
        container,
        keterangan
      ];

  // static int? _stringToInt(String? value) {
  //   return value != null ? int.tryParse(value) : null;
  // }
}
