import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'order.g.dart';

@JsonSerializable()
class OrderAccesses extends Equatable {
  final String? email,
      createdBy,
      createdDate,
      businessUnit,
      portAsal,
      portTujuan,
      ownerCode,
      orderService,
      shipmentType,
      originalCity,
      originalAddress,
      originalPicName,
      cargoReadyDate,
      destinationCity,
      destinationAddress,
      destinationPicName,
      contractNo,
      komoditi,
      productDescription,
      containerSize,
      originalPicNumber,
      destinationPicNumber,
      orderNumber;

  final int? userId, lineNumber, quantity, statusID, amount;

  const OrderAccesses({
    this.email = '',
    this.createdBy = '',
    this.createdDate = '',
    this.businessUnit = '',
    this.portAsal = '',
    this.portTujuan = '',
    this.ownerCode = '',
    this.orderService = '',
    this.shipmentType = '',
    this.originalCity = '',
    this.originalAddress = '',
    this.originalPicName = '',
    this.originalPicNumber = '',
    this.cargoReadyDate = '',
    this.destinationCity = '',
    this.destinationAddress = '',
    this.destinationPicName = '',
    this.destinationPicNumber = '',
    this.contractNo = '',
    this.komoditi = '',
    this.productDescription = '',
    this.userId = 0,
    this.lineNumber = 0,
    this.containerSize = '',
    this.quantity = 0,
    this.statusID = 0,
    this.amount = 0,
    this.orderNumber = '',
  });

  factory OrderAccesses.fromJson(Map<String, dynamic> json) =>
      _$OrderAccessesFromJson(json);
  Map<String, dynamic> toJson() => _$OrderAccessesToJson(this);

  @override
  List<Object> get props => [];
}
