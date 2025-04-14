import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:niaga_apps_mobile/model/niaga/cari-barang-profil/track_head.dart';

import 'jenis_barang_data.dart';

part 'jenis_barang.g.dart';

@JsonSerializable()
class JenisBarangAccesses extends Equatable {
  final TrackHeadAccesses head;
  final JenisBarangData data;

  const JenisBarangAccesses({
    required this.head,
    required this.data,
  });

  factory JenisBarangAccesses.fromJson(Map<String, dynamic> json) =>
      _$JenisBarangAccessesFromJson(json);
  Map<String, dynamic> toJson() => _$JenisBarangAccessesToJson(this);

  @override
  List<Object?> get props => [head, data];
}
