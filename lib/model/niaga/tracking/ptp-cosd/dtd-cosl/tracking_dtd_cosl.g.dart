// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tracking_dtd_cosl.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TrackingDtdCoslAccesses _$TrackingDtdCoslAccessesFromJson(
        Map<String, dynamic> json) =>
    TrackingDtdCoslAccesses(
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
      tiba: TrackingItemTibaAccesses.fromJson(
          json['tiba'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TrackingDtdCoslAccessesToJson(
        TrackingDtdCoslAccesses instance) =>
    <String, dynamic>{
      'header': instance.header,
      'pengambilan_customer': instance.pengambilanCustomer,
      'muat_pelabuhan': instance.muatPelabuhan,
      'bongkar_pelabuhan': instance.bongkarPelabuhan,
      'tiba': instance.tiba,
    };
