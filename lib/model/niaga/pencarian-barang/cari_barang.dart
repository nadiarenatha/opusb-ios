import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:niaga_apps_mobile/model/niaga/packing_detail_niaga.dart';

import 'detail_data.dart';
import 'detail_header.dart';

part 'cari_barang.g.dart';

@JsonSerializable()
class CariBarangAccesses extends Equatable {
  @JsonKey(name: 'total_row')
  final int? totalRow;

  final int? page, size;

  @JsonKey(name: 'total_page')
  final int? totalPage;

  final List<DetailHeaderAccesses> header;
  final List<DetailDataAccesses> data;

  const CariBarangAccesses({
    this.totalRow = 0,
    this.page = 0,
    this.size = 0,
    this.totalPage = 0,
    required this.header,
    required this.data,
  });

  factory CariBarangAccesses.fromJson(Map<String, dynamic> json) =>
      _$CariBarangAccessesFromJson(json);
  Map<String, dynamic> toJson() => _$CariBarangAccessesToJson(this);

  @override
  List<Object?> get props => [totalRow, page, size, totalPage, header, data];
}
