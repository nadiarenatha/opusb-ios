import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
part 'packing_list.g.dart';

@JsonSerializable()
class PackingListAccesses extends Equatable {
  final int? id, volume;
  final String? packingListNo, type, rute, ata, atd;
  const PackingListAccesses({
    this.id = 0,
    // this.adOrganizationId = 0,
    // this.accessType = '',
    this.packingListNo = '',
    this.type = '',
    this.volume = 0,
    this.rute = '',
    this.ata = '',
    this.atd = '',
  });

  factory PackingListAccesses.fromJson(Map<String, dynamic> json) =>
      _$PackingListAccessesFromJson(json);
  Map<String, dynamic> toJson() => _$PackingListAccessesToJson(this);

  @override
  List<Object> get props => [];
}
