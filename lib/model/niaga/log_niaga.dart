import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'log_niaga.g.dart';

@JsonSerializable()
class LogNiagaAccesses extends Equatable {
  final String? actionUrl;

  const LogNiagaAccesses({
    this.actionUrl = '',
  });

  factory LogNiagaAccesses.fromJson(Map<String, dynamic> json) =>
      _$LogNiagaAccessesFromJson(json);
  Map<String, dynamic> toJson() => _$LogNiagaAccessesToJson(this);

  @override
  List<Object> get props => [];
}
