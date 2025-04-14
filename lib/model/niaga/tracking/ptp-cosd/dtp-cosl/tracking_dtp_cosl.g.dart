// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tracking_dtp_cosl.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TrackingDtpCoslAccesses _$TrackingDtpCoslAccessesFromJson(
        Map<String, dynamic> json) =>
    TrackingDtpCoslAccesses(
      header: (json['header'] as List<dynamic>)
          .map((e) =>
              TrackingItemHeaderAccesses.fromJson(e as Map<String, dynamic>))
          .toList(),
      pengambilanCustomer: TrackingItemPengambilanCustomerAccesses.fromJson(
          json['pengambilan_customer'] as Map<String, dynamic>),
      muatPelabuhan: TrackingItemMuatPelabuhanAccesses.fromJson(
          json['muat_pelabuhan'] as Map<String, dynamic>),
      bongkarPelabuhan: TrackingItemBongkarPelabuhanAccesses.fromJson(
          json['bongkar_pelabuhan'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TrackingDtpCoslAccessesToJson(
        TrackingDtpCoslAccesses instance) =>
    <String, dynamic>{
      'header': instance.header,
      'pengambilan_customer': instance.pengambilanCustomer,
      'muat_pelabuhan': instance.muatPelabuhan,
      'bongkar_pelabuhan': instance.bongkarPelabuhan,
    };
