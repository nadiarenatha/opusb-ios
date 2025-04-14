import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'wa_verified.g.dart';

@JsonSerializable()
class WAVerifiedAccesses extends Equatable {
  final String? userLogin;

  const WAVerifiedAccesses({
    this.userLogin = ''
  });

  factory WAVerifiedAccesses.fromJson(Map<String, dynamic> json) =>
      _$WAVerifiedAccessesFromJson(json);
  Map<String, dynamic> toJson() => _$WAVerifiedAccessesToJson(this);

  @override
  List<Object?> get props => [userLogin];
}
