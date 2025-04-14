import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
part 'jadwal_kapal.g.dart';

@JsonSerializable()
class JadwalKapalAccesses extends Equatable {
  final int? id;
  final String? shipName, voyageNo, closingDate, rute, rutePanjang, eta, etd;
  const JadwalKapalAccesses({
    this.id = 0,
    this.shipName = '',
    this.voyageNo = '',
    this.closingDate = '',
    this.rute = '',
    this.rutePanjang = '',
    this.eta = '',
    this.etd = '',
  });

  factory JadwalKapalAccesses.fromJson(Map<String, dynamic> json) =>
      _$JadwalKapalAccessesFromJson(json);
  Map<String, dynamic> toJson() => _$JadwalKapalAccessesToJson(this);

  @override
  List<Object> get props => [];
}
