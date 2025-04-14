import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:niaga_apps_mobile/model/niaga/packing_detail_niaga.dart';

part 'packing_niaga.g.dart';

@JsonSerializable()
class PackingNiagaAccesses extends Equatable {
  @JsonKey(name: 'total_row')
  final int? totalRow;

  final int? page, size;

  @JsonKey(name: 'total_page')
  final int? totalPage;

  final List<PackingItemAccesses> data;

  const PackingNiagaAccesses({
    this.totalRow = 0,
    this.page = 0,
    this.size = 0,
    this.totalPage = 0,
    required this.data,
  });

  factory PackingNiagaAccesses.fromJson(Map<String, dynamic> json) =>
      _$PackingNiagaAccessesFromJson(json);
  Map<String, dynamic> toJson() => _$PackingNiagaAccessesToJson(this);

  @override
  List<Object?> get props => [totalRow, page, size, totalPage, data];
}
