// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'riwayat_pembayaran.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RiwayatPembayaranAccesses _$RiwayatPembayaranAccessesFromJson(
        Map<String, dynamic> json) =>
    RiwayatPembayaranAccesses(
      email: json['email'] as String? ?? '',
      orderNumber: json['orderNumber'] as String? ?? '',
      invoiceNumber: json['invoiceNumber'] as String? ?? '',
      packingListNumber: json['packingListNumber'] as String? ?? '',
      ruteTujuan: json['ruteTujuan'] as String? ?? '',
      tipePengiriman: json['tipePengiriman'] as String? ?? '',
      volume: json['volume'] as String? ?? '',
      payMethod: json['payMethod'] as String? ?? '',
      paidDate: json['paidDate'] as String? ?? '',
      transactionStatus: json['transactionStatus'] as String? ?? '',
      paymentAmount: (json['paymentAmount'] as num?)?.toDouble() ?? 0,
    );

Map<String, dynamic> _$RiwayatPembayaranAccessesToJson(
        RiwayatPembayaranAccesses instance) =>
    <String, dynamic>{
      'email': instance.email,
      'orderNumber': instance.orderNumber,
      'invoiceNumber': instance.invoiceNumber,
      'packingListNumber': instance.packingListNumber,
      'ruteTujuan': instance.ruteTujuan,
      'tipePengiriman': instance.tipePengiriman,
      'volume': instance.volume,
      'payMethod': instance.payMethod,
      'paidDate': instance.paidDate,
      'transactionStatus': instance.transactionStatus,
      'paymentAmount': instance.paymentAmount,
    };
