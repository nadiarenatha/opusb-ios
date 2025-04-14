import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:niaga_apps_mobile/model/niaga/tracking/ptp-cosd/dtd-cosl/pengambilan_customer.dart';
import 'package:niaga_apps_mobile/model/niaga/tracking/ptp-cosd/tracking_bongkar.dart';
import 'package:niaga_apps_mobile/model/niaga/tracking/ptp-cosd/tracking_header.dart';
import 'package:niaga_apps_mobile/model/niaga/tracking/ptp-cosd/tracking_muat_pelabuhan.dart';

part 'tracking_dtp_cosl.g.dart';

@JsonSerializable()
class TrackingDtpCoslAccesses extends Equatable {
  final List<TrackingItemHeaderAccesses> header;

  @JsonKey(name: 'pengambilan_customer')
  final TrackingItemPengambilanCustomerAccesses pengambilanCustomer;

  @JsonKey(name: 'muat_pelabuhan')
  final TrackingItemMuatPelabuhanAccesses muatPelabuhan;

  @JsonKey(name: 'bongkar_pelabuhan')
  final TrackingItemBongkarPelabuhanAccesses bongkarPelabuhan;

  const TrackingDtpCoslAccesses({
    required this.header,
    required this.pengambilanCustomer,
    required this.muatPelabuhan,
    required this.bongkarPelabuhan,
  });

  factory TrackingDtpCoslAccesses.fromJson(Map<String, dynamic> json) =>
      _$TrackingDtpCoslAccessesFromJson(json);
  Map<String, dynamic> toJson() => _$TrackingDtpCoslAccessesToJson(this);

  @override
  List<Object?> get props => [
        header,
        pengambilanCustomer,
        muatPelabuhan,
        bongkarPelabuhan,
      ];
}
