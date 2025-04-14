import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tiba.g.dart';

@JsonSerializable()
class TrackingItemTibaAccesses extends Equatable {
  @JsonKey(name: 'nama_customer_tiba')
  final String? namaCustomerTiba;

  @JsonKey(name: 'tanggal_tiba')
  final String? tanggalTiba;

  const TrackingItemTibaAccesses({
    this.namaCustomerTiba = '',
    this.tanggalTiba = '',
  });

  factory TrackingItemTibaAccesses.fromJson(
          Map<String, dynamic> json) =>
      _$TrackingItemTibaAccessesFromJson(json);
  Map<String, dynamic> toJson() =>
      _$TrackingItemTibaAccessesToJson(this);

  String get formattedTime {
    if (tanggalTiba != null && tanggalTiba!.isNotEmpty) {
      try {
        final dateTime = DateTime.parse(tanggalTiba!);
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
  List<Object?> get props => [namaCustomerTiba, tanggalTiba];
}
