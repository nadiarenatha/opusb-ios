import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tracking_keluar_niaga.g.dart';

@JsonSerializable()
class TrackingItemKeluarNiagaAccesses extends Equatable {
  @JsonKey(name: 'nama_gudang')
  final String? namaGudang;

  @JsonKey(name: 'tgl_keluar')
  final String? tglKeluar;

  const TrackingItemKeluarNiagaAccesses({
    this.namaGudang = '',
    this.tglKeluar = '',
  });

  factory TrackingItemKeluarNiagaAccesses.fromJson(Map<String, dynamic> json) =>
      _$TrackingItemKeluarNiagaAccessesFromJson(json);
  Map<String, dynamic> toJson() =>
      _$TrackingItemKeluarNiagaAccessesToJson(this);

  String get formattedTime {
    if (tglKeluar != null && tglKeluar!.isNotEmpty) {
      try {
        final dateTime = DateTime.parse(tglKeluar!);
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
  List<Object?> get props => [namaGudang, tglKeluar];
}
