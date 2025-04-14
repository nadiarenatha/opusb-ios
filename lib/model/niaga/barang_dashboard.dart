import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:niaga_apps_mobile/model/niaga/packing_detail_niaga.dart';

part 'barang_dashboard.g.dart';

@JsonSerializable()
class BarangDashboardAccesses extends Equatable {
  @JsonKey(name: 'DESCRIPTION')
  final String? description;

  @JsonKey(name: 'TOTAL')
  final dynamic total;

  const BarangDashboardAccesses({
    this.description = '',
    this.total = 0,
  });

  factory BarangDashboardAccesses.fromJson(Map<String, dynamic> json) =>
      _$BarangDashboardAccessesFromJson(json);
  Map<String, dynamic> toJson() => _$BarangDashboardAccessesToJson(this);

  @override
  List<Object?> get props => [description, total];
}
