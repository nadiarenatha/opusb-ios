import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'kantor_cabang.g.dart';

@JsonSerializable()
class KantorCabangAccesses extends Equatable {
  @JsonKey(name: 'sort_order')
  final int? sortOrder;

  final int? id;

  final String? alamat, image;

  @JsonKey(name: 'nama_cabang')
  final String? namaCabang;

  const KantorCabangAccesses({
    this.sortOrder = 0,
    this.id = 0,
    this.alamat = '',
    this.namaCabang = '',
    this.image = '',
  });

  factory KantorCabangAccesses.fromJson(Map<String, dynamic> json) =>
      _$KantorCabangAccessesFromJson(json);
  Map<String, dynamic> toJson() => _$KantorCabangAccessesToJson(this);

  @override
  List<Object?> get props => [sortOrder, id, alamat, namaCabang, image];
}
