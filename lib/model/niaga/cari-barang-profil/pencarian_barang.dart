import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'detail_cari_barang.dart';

part 'pencarian_barang.g.dart';

@JsonSerializable()
class PencarianBarangAccesses extends Equatable {
  @JsonKey(name: 'total_row')
  final int? totalRow;

  final int? page, size;

  @JsonKey(name: 'total_page')
  final int? totalPage;

  final List<DetailDataBarangAccesses> data;

  const PencarianBarangAccesses({
    this.totalRow = 0,
    this.page = 0,
    this.size = 0,
    this.totalPage = 0,
    required this.data,
  });

  factory PencarianBarangAccesses.fromJson(Map<String, dynamic> json) =>
      _$PencarianBarangAccessesFromJson(json);
  Map<String, dynamic> toJson() => _$PencarianBarangAccessesToJson(this);

  @override
  List<Object?> get props => [totalRow, page, size, totalPage, data];
}