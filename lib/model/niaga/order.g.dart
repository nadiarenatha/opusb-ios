// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderAccesses _$OrderAccessesFromJson(Map<String, dynamic> json) =>
    OrderAccesses(
      email: json['email'] as String? ?? '',
      createdBy: json['createdBy'] as String? ?? '',
      createdDate: json['createdDate'] as String? ?? '',
      businessUnit: json['businessUnit'] as String? ?? '',
      portAsal: json['portAsal'] as String? ?? '',
      portTujuan: json['portTujuan'] as String? ?? '',
      ownerCode: json['ownerCode'] as String? ?? '',
      orderService: json['orderService'] as String? ?? '',
      shipmentType: json['shipmentType'] as String? ?? '',
      originalCity: json['originalCity'] as String? ?? '',
      originalAddress: json['originalAddress'] as String? ?? '',
      originalPicName: json['originalPicName'] as String? ?? '',
      originalPicNumber: json['originalPicNumber'] as String? ?? '',
      cargoReadyDate: json['cargoReadyDate'] as String? ?? '',
      destinationCity: json['destinationCity'] as String? ?? '',
      destinationAddress: json['destinationAddress'] as String? ?? '',
      destinationPicName: json['destinationPicName'] as String? ?? '',
      destinationPicNumber: json['destinationPicNumber'] as String? ?? '',
      contractNo: json['contractNo'] as String? ?? '',
      komoditi: json['komoditi'] as String? ?? '',
      productDescription: json['productDescription'] as String? ?? '',
      userId: json['userId'] as int? ?? 0,
      lineNumber: json['lineNumber'] as int? ?? 0,
      containerSize: json['containerSize'] as String? ?? '',
      quantity: json['quantity'] as int? ?? 0,
      statusID: json['statusID'] as int? ?? 0,
      amount: json['amount'] as int? ?? 0,
      orderNumber: json['orderNumber'] as String? ?? '',
    );

Map<String, dynamic> _$OrderAccessesToJson(OrderAccesses instance) =>
    <String, dynamic>{
      'email': instance.email,
      'createdBy': instance.createdBy,
      'createdDate': instance.createdDate,
      'businessUnit': instance.businessUnit,
      'portAsal': instance.portAsal,
      'portTujuan': instance.portTujuan,
      'ownerCode': instance.ownerCode,
      'orderService': instance.orderService,
      'shipmentType': instance.shipmentType,
      'originalCity': instance.originalCity,
      'originalAddress': instance.originalAddress,
      'originalPicName': instance.originalPicName,
      'cargoReadyDate': instance.cargoReadyDate,
      'destinationCity': instance.destinationCity,
      'destinationAddress': instance.destinationAddress,
      'destinationPicName': instance.destinationPicName,
      'contractNo': instance.contractNo,
      'komoditi': instance.komoditi,
      'productDescription': instance.productDescription,
      'containerSize': instance.containerSize,
      'originalPicNumber': instance.originalPicNumber,
      'destinationPicNumber': instance.destinationPicNumber,
      'orderNumber': instance.orderNumber,
      'userId': instance.userId,
      'lineNumber': instance.lineNumber,
      'quantity': instance.quantity,
      'statusID': instance.statusID,
      'amount': instance.amount,
    };
