import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'id_account.g.dart';

@JsonSerializable()
class IdAccountAccesses extends Equatable {
  final int? id;

  const IdAccountAccesses({
    this.id = 0,
  });

  factory IdAccountAccesses.fromJson(Map<String, dynamic> json) =>
      _$IdAccountAccessesFromJson(json);
  Map<String, dynamic> toJson() => _$IdAccountAccessesToJson(this);

  @override
  List<Object?> get props => [
        id
      ];
}
