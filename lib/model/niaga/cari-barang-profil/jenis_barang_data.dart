import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:niaga_apps_mobile/model/niaga/cari-barang-profil/track_header.dart';

import 'detail_data_barang.dart';

part 'jenis_barang_data.g.dart';

@JsonSerializable()
class JenisBarangData extends Equatable {
  final String message;

  @JsonKey(name: 'track_detail')
  // final DetailJenisBarangAccesses trackDetail;
  final List<DetailJenisBarangAccesses> trackDetail;

  const JenisBarangData({
    this.message = '',
    required this.trackDetail,
  });

  factory JenisBarangData.fromJson(Map<String, dynamic> json) =>
      _$JenisBarangDataFromJson(json);
  Map<String, dynamic> toJson() => _$JenisBarangDataToJson(this);

  @override
  List<Object?> get props => [message, trackDetail];
}
