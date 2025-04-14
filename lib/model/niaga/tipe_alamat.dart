import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tipe_alamat.g.dart';

@JsonSerializable()
class TipeAlamatAccesses extends Equatable {
  final String? name, value;

  const TipeAlamatAccesses({
    this.name = '',
    this.value = '',
  });

  factory TipeAlamatAccesses.fromJson(Map<String, dynamic> json) =>
      _$TipeAlamatAccessesFromJson(json);
  Map<String, dynamic> toJson() => _$TipeAlamatAccessesToJson(this);

  @override
  List<Object> get props => [];
}
