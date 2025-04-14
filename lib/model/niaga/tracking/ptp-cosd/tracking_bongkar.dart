import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tracking_bongkar.g.dart';

@JsonSerializable()
class TrackingItemBongkarPelabuhanAccesses extends Equatable {
  @JsonKey(name: 'ETA')
  final String? eta;

  final String? pelabuhan;

  const TrackingItemBongkarPelabuhanAccesses({
    this.eta = '',
    this.pelabuhan = '',
  });

  factory TrackingItemBongkarPelabuhanAccesses.fromJson(
          Map<String, dynamic> json) =>
      _$TrackingItemBongkarPelabuhanAccessesFromJson(json);
  Map<String, dynamic> toJson() =>
      _$TrackingItemBongkarPelabuhanAccessesToJson(this);

  String get formattedTime {
    if (eta != null && eta!.isNotEmpty) {
      try {
        final dateTime = DateTime.parse(eta!);
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
  List<Object?> get props => [eta, pelabuhan];
}
