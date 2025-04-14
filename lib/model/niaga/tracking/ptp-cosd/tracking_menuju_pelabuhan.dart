import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tracking_menuju_pelabuhan.g.dart';

@JsonSerializable()
class TrackingItemMenujuPelabuhanAccesses extends Equatable {
  @JsonKey(name: 'tgl_menuju_pelabuhan')
  final String? tglMenujuPelabuhan;

  const TrackingItemMenujuPelabuhanAccesses({
    this.tglMenujuPelabuhan = '',
  });

  factory TrackingItemMenujuPelabuhanAccesses.fromJson(
          Map<String, dynamic> json) =>
      _$TrackingItemMenujuPelabuhanAccessesFromJson(json);
  Map<String, dynamic> toJson() =>
      _$TrackingItemMenujuPelabuhanAccessesToJson(this);

  String get formattedTime {
    if (tglMenujuPelabuhan != null && tglMenujuPelabuhan!.isNotEmpty) {
      try {
        final dateTime = DateTime.parse(tglMenujuPelabuhan!);
        // Format to "YYYY-MM-DD HH:MM"
        return "${dateTime.year.toString().padLeft(4, '0')}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}";
      } catch (e) {
        // Handle parsing errors
        return '';
      }
    }
    return '';
  }

  @override
  List<Object?> get props => [tglMenujuPelabuhan];
}
