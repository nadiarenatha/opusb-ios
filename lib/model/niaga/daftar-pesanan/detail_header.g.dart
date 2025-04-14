// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'detail_header.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DetailHeaderAccesses _$DetailHeaderAccessesFromJson(
        Map<String, dynamic> json) =>
    DetailHeaderAccesses(
      createdDate: json['createdDate'] as String? ?? '',
      contractNo: json['contractNo'] as String? ?? '',
      orderNumber: json['orderNumber'] as String? ?? '',
      orderService: json['orderService'] as String? ?? '',
      shipmentType: json['shipmentType'] as String? ?? '',
      originalCity: json['originalCity'] as String? ?? '',
      destinationCity: json['destinationCity'] as String? ?? '',
      originalAddress: json['originalAddress'] as String? ?? '',
      originalPicName: json['originalPicName'] as String? ?? '',
      originalPicNumber: json['originalPicNumber'] as String? ?? '',
      cargoReadyDate: json['cargoReadyDate'] as String? ?? '',
      destinationAddress: json['destinationAddress'] as String? ?? '',
      destinationPicName: json['destinationPicName'] as String? ?? '',
      destinationPicNumber: json['destinationPicNumber'] as String? ?? '',
      noOrderBoon: json['noOrderBoon'] as String? ?? '',
      reviseDescription: json['reviseDescription'] as String? ?? '',
      portAsal: json['portAsal'] as String? ?? '',
      portTujuan: json['portTujuan'] as String? ?? '',
      point: json['point'] as bool? ?? false,
      id: json['id'] as int? ?? 0,
      resiNumber: json['resiNumber'] as String? ?? '',
      etd: json['etd'] as String? ?? '',
    );

Map<String, dynamic> _$DetailHeaderAccessesToJson(
        DetailHeaderAccesses instance) =>
    <String, dynamic>{
      'createdDate': instance.createdDate,
      'contractNo': instance.contractNo,
      'orderNumber': instance.orderNumber,
      'orderService': instance.orderService,
      'shipmentType': instance.shipmentType,
      'originalCity': instance.originalCity,
      'destinationCity': instance.destinationCity,
      'originalAddress': instance.originalAddress,
      'originalPicName': instance.originalPicName,
      'originalPicNumber': instance.originalPicNumber,
      'cargoReadyDate': instance.cargoReadyDate,
      'destinationAddress': instance.destinationAddress,
      'destinationPicName': instance.destinationPicName,
      'destinationPicNumber': instance.destinationPicNumber,
      'noOrderBoon': instance.noOrderBoon,
      'reviseDescription': instance.reviseDescription,
      'portAsal': instance.portAsal,
      'portTujuan': instance.portTujuan,
      'resiNumber': instance.resiNumber,
      'etd': instance.etd,
      'point': instance.point,
      'id': instance.id,
    };
