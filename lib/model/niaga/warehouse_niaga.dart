import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:niaga_apps_mobile/model/niaga/warehouse_detail_niaga.dart';

part 'warehouse_niaga.g.dart';

@JsonSerializable()
class WarehouseNiagaAccesses extends Equatable {
  @JsonKey(name: 'total_row')
  final int? totalRow;

  final int? page, size;

  @JsonKey(name: 'total_page')
  final int? totalPage;

  final List<WarehouseItemAccesses> data;

  const WarehouseNiagaAccesses({
    this.totalRow = 0,
    this.page = 0,
    this.size = 0,
    this.totalPage = 0,
    required this.data,
  });

  factory WarehouseNiagaAccesses.fromJson(Map<String, dynamic> json) =>
      _$WarehouseNiagaAccessesFromJson(json);
  Map<String, dynamic> toJson() => _$WarehouseNiagaAccessesToJson(this);

  @override
  List<Object?> get props => [totalRow, page, size, totalPage, data];
}
