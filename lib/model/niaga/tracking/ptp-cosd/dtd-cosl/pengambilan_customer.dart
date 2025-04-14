import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'pengambilan_customer.g.dart';

@JsonSerializable()
class TrackingItemPengambilanCustomerAccesses extends Equatable {
  @JsonKey(name: 'nama_customer')
  final String? namaCustomer;

  final String? tanggal;

  const TrackingItemPengambilanCustomerAccesses({
    this.namaCustomer = '',
    this.tanggal = '',
  });

  factory TrackingItemPengambilanCustomerAccesses.fromJson(
          Map<String, dynamic> json) =>
      _$TrackingItemPengambilanCustomerAccessesFromJson(json);
  Map<String, dynamic> toJson() =>
      _$TrackingItemPengambilanCustomerAccessesToJson(this);

  String get formattedTime {
    if (tanggal != null && tanggal!.isNotEmpty) {
      try {
        final dateTime = DateTime.parse(tanggal!);
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
  List<Object?> get props => [namaCustomer, tanggal];
}
