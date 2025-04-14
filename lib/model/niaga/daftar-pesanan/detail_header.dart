import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'detail_header.g.dart';

@JsonSerializable()
class DetailHeaderAccesses extends Equatable {
  final String? createdDate,
      contractNo,
      orderNumber,
      orderService,
      shipmentType,
      originalCity,
      destinationCity,
      originalAddress,
      originalPicName,
      originalPicNumber,
      cargoReadyDate,
      destinationAddress,
      destinationPicName,
      destinationPicNumber,
      noOrderBoon,
      reviseDescription,
      portAsal,
      portTujuan,
      resiNumber,
      etd;

  final bool? point;

  final int? id;

  const DetailHeaderAccesses({
    this.createdDate = '',
    this.contractNo = '',
    this.orderNumber = '',
    this.orderService = '',
    this.shipmentType = '',
    this.originalCity = '',
    this.destinationCity = '',
    this.originalAddress = '',
    this.originalPicName = '',
    this.originalPicNumber = '',
    this.cargoReadyDate = '',
    this.destinationAddress = '',
    this.destinationPicName = '',
    this.destinationPicNumber = '',
    this.noOrderBoon = '',
    this.reviseDescription = '',
    this.portAsal = '',
    this.portTujuan = '',
    this.point = false,
    this.id = 0,
    this.resiNumber = '',
    this.etd = '',
  });

  factory DetailHeaderAccesses.fromJson(Map<String, dynamic> json) =>
      _$DetailHeaderAccessesFromJson(json);
  Map<String, dynamic> toJson() => _$DetailHeaderAccessesToJson(this);

  @override
  List<Object> get props => [];
}
