import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:niaga_apps_mobile/model/niaga/packing_detail_niaga.dart';

import 'daftar_pesanan.dart';

part 'data_pesanan.g.dart';

@JsonSerializable()
class DataPesananAccesses extends Equatable {
  final List<DaftarPesananAccesses> content;
  final int? totalPages;

  const DataPesananAccesses({
    required this.content,
    this.totalPages = 0,
  });

  factory DataPesananAccesses.fromJson(Map<String, dynamic> json) =>
      _$DataPesananAccessesFromJson(json);
  Map<String, dynamic> toJson() => _$DataPesananAccessesToJson(this);

  @override
  List<Object?> get props => [content];
}
