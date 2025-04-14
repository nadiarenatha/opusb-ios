// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daftar_pesanan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DaftarPesananAccesses _$DaftarPesananAccessesFromJson(
        Map<String, dynamic> json) =>
    DaftarPesananAccesses(
      createdDate: json['createdDate'] as String? ?? '',
      orderNumber: json['orderNumber'] as String? ?? '',
      orderService: json['orderService'] as String? ?? '',
      shipmentType: json['shipmentType'] as String? ?? '',
      originalCity: json['originalCity'] as String? ?? '',
      destinationCity: json['destinationCity'] as String? ?? '',
      statusId: json['statusId'] as String? ?? '',
      status: json['status'] as String? ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0,
      id: json['id'] as int? ?? 0,
      point: json['point'] as bool? ?? false,
      invoiceNum: json['invoiceNum'] as String? ?? '',
      noOrderBoon: json['noOrderBoon'] as String? ?? '',
    );

Map<String, dynamic> _$DaftarPesananAccessesToJson(
        DaftarPesananAccesses instance) =>
    <String, dynamic>{
      'createdDate': instance.createdDate,
      'orderNumber': instance.orderNumber,
      'orderService': instance.orderService,
      'shipmentType': instance.shipmentType,
      'originalCity': instance.originalCity,
      'destinationCity': instance.destinationCity,
      'statusId': instance.statusId,
      'status': instance.status,
      'invoiceNum': instance.invoiceNum,
      'noOrderBoon': instance.noOrderBoon,
      'amount': instance.amount,
      'id': instance.id,
      'point': instance.point,
    };
