import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'hubungi_kami.g.dart';

@JsonSerializable()
class HubungiKamiAccesses extends Equatable {
  @JsonKey(name: 'no_wa')
  final String? noWa;

  final int? id;

  final String? nomor, nama, area;


  const HubungiKamiAccesses({
    this.noWa = '',
    this.id = 0,
    this.nomor = '',
    this.nama = '',
    this.area = '',
  });

  factory HubungiKamiAccesses.fromJson(Map<String, dynamic> json) =>
      _$HubungiKamiAccessesFromJson(json);
  Map<String, dynamic> toJson() => _$HubungiKamiAccessesToJson(this);

  @override
  List<Object?> get props => [noWa, id, nomor, nama, area];
}
