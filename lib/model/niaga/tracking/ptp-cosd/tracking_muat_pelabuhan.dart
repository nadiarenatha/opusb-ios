import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tracking_muat_pelabuhan.g.dart';

@JsonSerializable()
class TrackingItemMuatPelabuhanAccesses extends Equatable {
  @JsonKey(name: 'pelabuhan_asal')
  final String? pelabuhanAsal;

  @JsonKey(name: 'ETD')
  final String? etd;

  const TrackingItemMuatPelabuhanAccesses({
    this.pelabuhanAsal = '',
    this.etd = '',
  });

  factory TrackingItemMuatPelabuhanAccesses.fromJson(
          Map<String, dynamic> json) =>
      _$TrackingItemMuatPelabuhanAccessesFromJson(json);
  Map<String, dynamic> toJson() =>
      _$TrackingItemMuatPelabuhanAccessesToJson(this);

  String get formattedTime {
    if (etd != null && etd!.isNotEmpty) {
      try {
        final dateTime = DateTime.parse(etd!);
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
  List<Object?> get props => [pelabuhanAsal, etd];
}
