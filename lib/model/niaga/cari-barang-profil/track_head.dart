import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:niaga_apps_mobile/model/niaga/cari-barang-profil/track_header.dart';

part 'track_head.g.dart';

@JsonSerializable()
class TrackHeadAccesses extends Equatable {
  final String message;

  @JsonKey(name: 'track_header')
  // final TrackHeader trackHeader;
  final List<TrackHeader> trackHeader;

  const TrackHeadAccesses({
    this.message = '',
    required this.trackHeader,
  });

  factory TrackHeadAccesses.fromJson(Map<String, dynamic> json) =>
      _$TrackHeadAccessesFromJson(json);
  Map<String, dynamic> toJson() => _$TrackHeadAccessesToJson(this);

  @override
  List<Object?> get props => [message, trackHeader];
}
