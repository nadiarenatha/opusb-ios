import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tracking_masuk_niaga.g.dart';

@JsonSerializable()
class TrackingItemMasukNiagaAccesses extends Equatable {
  @JsonKey(name: 'nama_gudang')
  final String? namaGudang;

  @JsonKey(name: 'tgl_masuk')
  final String? tglMasuk;

  const TrackingItemMasukNiagaAccesses({
    this.namaGudang = '',
    this.tglMasuk = '',
  });

  factory TrackingItemMasukNiagaAccesses.fromJson(Map<String, dynamic> json) =>
      _$TrackingItemMasukNiagaAccessesFromJson(json);
  Map<String, dynamic> toJson() => _$TrackingItemMasukNiagaAccessesToJson(this);

  String get formattedTime {
    if (tglMasuk != null && tglMasuk!.isNotEmpty) {
      try {
        final dateTime = DateTime.parse(tglMasuk!);
        // Format to "YYYY-MM-DD"
        return "${dateTime.year.toString().padLeft(4, '0')}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}";
      } catch (e) {
        // Handle parsing errors
        return '';
      }
    }
    return '';
  }

  @override
  List<Object?> get props => [namaGudang, tglMasuk];
}
