import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tracking_gudang_astra.g.dart';

@JsonSerializable()
class TrackingItemDariGudangAstraAccesses extends Equatable {
  @JsonKey(name: 'pertama_dari_astra')
  final String? pertamaDariAstra;

  @JsonKey(name: 'terakhir_dari_astra')
  final String? terakhirDariAstra;

  const TrackingItemDariGudangAstraAccesses({
    this.pertamaDariAstra = '',
    this.terakhirDariAstra = '',
  });

  factory TrackingItemDariGudangAstraAccesses.fromJson(
          Map<String, dynamic> json) =>
      _$TrackingItemDariGudangAstraAccessesFromJson(json);
  Map<String, dynamic> toJson() =>
      _$TrackingItemDariGudangAstraAccessesToJson(this);

  String get formattedTimePertama {
    if (pertamaDariAstra != null && pertamaDariAstra!.isNotEmpty) {
      try {
        final dateTime = DateTime.parse(pertamaDariAstra!);
        // Format to "YYYY-MM-DD HH:MM"
        return "${dateTime.year.toString().padLeft(4, '0')}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
      } catch (e) {
        // Handle parsing errors
        return '';
      }
    }
    return '';
  }

  String get formattedTimeTerakhir {
    if (terakhirDariAstra != null && terakhirDariAstra!.isNotEmpty) {
      try {
        final dateTime = DateTime.parse(terakhirDariAstra!);
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
  List<Object?> get props => [pertamaDariAstra, terakhirDariAstra];
}
