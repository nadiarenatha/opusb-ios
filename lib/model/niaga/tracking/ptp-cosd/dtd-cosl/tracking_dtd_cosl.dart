import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:niaga_apps_mobile/model/niaga/tracking/ptp-cosd/dtd-cosl/pengambilan_customer.dart';
import 'package:niaga_apps_mobile/model/niaga/tracking/ptp-cosd/dtd-cosl/tiba.dart';
import 'package:niaga_apps_mobile/model/niaga/tracking/ptp-cosd/tracking_bongkar.dart';
import 'package:niaga_apps_mobile/model/niaga/tracking/ptp-cosd/tracking_header.dart';
import 'package:niaga_apps_mobile/model/niaga/tracking/ptp-cosd/tracking_muat_pelabuhan.dart';

part 'tracking_dtd_cosl.g.dart';

@JsonSerializable()
class TrackingDtdCoslAccesses extends Equatable {
  final List<TrackingItemHeaderAccesses> header;

  @JsonKey(name: 'pengambilan_customer')
  final TrackingItemPengambilanCustomerAccesses pengambilanCustomer;

  @JsonKey(name: 'muat_pelabuhan')
  final TrackingItemMuatPelabuhanAccesses muatPelabuhan;

  @JsonKey(name: 'bongkar_pelabuhan')
  final TrackingItemBongkarPelabuhanAccesses bongkarPelabuhan;

  final TrackingItemTibaAccesses tiba;

  const TrackingDtdCoslAccesses({
    required this.header,
    required this.pengambilanCustomer,
    required this.muatPelabuhan,
    required this.bongkarPelabuhan,
    required this.tiba,
  });

  factory TrackingDtdCoslAccesses.fromJson(Map<String, dynamic> json) =>
      _$TrackingDtdCoslAccessesFromJson(json);
  Map<String, dynamic> toJson() => _$TrackingDtdCoslAccessesToJson(this);

  @override
  List<Object?> get props => [
        header,
        pengambilanCustomer,
        muatPelabuhan,
        bongkarPelabuhan,
        tiba
      ];
}
