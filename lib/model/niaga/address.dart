import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'address.g.dart';

@JsonSerializable()
class AddressAccesses extends Equatable {
  final String? picPhone,
      addressType,
      email,
      addressName,
      picName,
      city,
      createdDate,
      createdBy,
      address1;

  const AddressAccesses({
    this.picPhone = '',
    this.addressType = '',
    this.email = '',
    this.addressName = '',
    this.picName = '',
    this.city = '',
    this.createdDate = '',
    this.createdBy = '',
    this.address1 = '',
  });

  factory AddressAccesses.fromJson(Map<String, dynamic> json) =>
      _$AddressAccessesFromJson(json);
  Map<String, dynamic> toJson() => _$AddressAccessesToJson(this);

  @override
  List<Object> get props => [];
}
