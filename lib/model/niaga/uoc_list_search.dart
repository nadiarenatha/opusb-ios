import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'uoc_list_search.g.dart';

@JsonSerializable()
class UOCListSearchAccesses extends Equatable {
  @JsonKey(name: 'KOTA')
  final String? kota; 

  @JsonKey(name: 'DISTRIK')
  final String? distrik;

  @JsonKey(name: 'PORT_CODE')
  final String? portCode;

  @JsonKey(name: 'LOC_ID')
  final String? locId;

  const UOCListSearchAccesses({
    this.kota = '',
    this.distrik = '',
    this.portCode = '',
    this.locId = '',
  });

  factory UOCListSearchAccesses.fromJson(Map<String, dynamic> json) =>
      _$UOCListSearchAccessesFromJson(json);
  Map<String, dynamic> toJson() => _$UOCListSearchAccessesToJson(this);

  @override
  List<Object?> get props => [kota, distrik, portCode];
}
