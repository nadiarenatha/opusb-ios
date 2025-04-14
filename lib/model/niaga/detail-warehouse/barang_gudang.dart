import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'data_barang_gudang.dart';
import 'header_barang_gudang.dart';

part 'barang_gudang.g.dart';

@JsonSerializable()
class BarangGudangAccesses extends Equatable {
  @JsonKey(name: 'total_row')
  final int? totalRow;

  final int? page, size;

  @JsonKey(name: 'total_page')
  final int? totalPage;

  // final List<BarangGudangHeaderAccesses> header;

  final List<BarangGudangDataAccesses> data;

  const BarangGudangAccesses({
    this.totalRow = 0,
    this.page = 0,
    this.size = 0,
    this.totalPage = 0,
    // required this.header,
    required this.data,
  });

  factory BarangGudangAccesses.fromJson(Map<String, dynamic> json) =>
      _$BarangGudangAccessesFromJson(json);
  Map<String, dynamic> toJson() => _$BarangGudangAccessesToJson(this);

  @override
  List<Object?> get props => [totalRow, page, size, totalPage, data];
}
