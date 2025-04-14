import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tracking_gudang_sby.g.dart';

@JsonSerializable()
class TrackingItemGudangSbyAccesses extends Equatable {
  @JsonKey(name: 'pertama_gudang_niaga')
  final String? pertamaGudangNiaga;

  @JsonKey(name: 'terakhir_gudang_niaga')
  final String? terakhirGudangNiaga;

  const TrackingItemGudangSbyAccesses({
    this.pertamaGudangNiaga = '',
    this.terakhirGudangNiaga = '',
  });

  factory TrackingItemGudangSbyAccesses.fromJson(
          Map<String, dynamic> json) =>
      _$TrackingItemGudangSbyAccessesFromJson(json);
  Map<String, dynamic> toJson() =>
      _$TrackingItemGudangSbyAccessesToJson(this);

  String get formattedTimePertamaNiaga {
    if (pertamaGudangNiaga != null && pertamaGudangNiaga!.isNotEmpty) {
      try {
        final dateTime = DateTime.parse(pertamaGudangNiaga!);
        // Format to "YYYY-MM-DD HH:MM"
        return "${dateTime.year.toString().padLeft(4, '0')}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
      } catch (e) {
        // Handle parsing errors
        return '';
      }
    }
    return '';
  }

  String get formattedTimeTerakhirNiaga {
    if (terakhirGudangNiaga != null && terakhirGudangNiaga!.isNotEmpty) {
      try {
        final dateTime = DateTime.parse(terakhirGudangNiaga!);
        // Format to "YYYY-MM-DD HH:MM"
        return "${dateTime.year.toString().padLeft(4, '0')}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
      } catch (e) {
        // Handle parsing errors
        return '';
      }
    }
    return '';
  }

  @override
  List<Object?> get props => [pertamaGudangNiaga, terakhirGudangNiaga];
}
