import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'data_login.g.dart';

@JsonSerializable()
class DataLoginAccesses extends Equatable {
  final String? phone,
      firstName,
      lastName,
      email,
      businessUnit,
      ownerCode,
      city,
      nik,
      npwp,
      address,
      position,
      cVendorCode,
      cVendorName,
      lastLoginDate,
      userLogin,
      adOrganizationName,
      businessCategoryIds,
      name,
      entitas,
      picName;

  final bool? active, employee, waVerified, contractFlag, vendor, assigner;

  final int? failedLoginCount,
      concurrentUserAccess,
      cVendorId,
      cCostCenterId,
      adOrganizationId,
      userId;

  const DataLoginAccesses({
    this.active = false,
    this.phone = '',
    this.employee = false,
    this.firstName = '',
    this.lastName = '',
    this.email = '',
    this.businessUnit = '',
    this.ownerCode = '',
    this.city = '',
    this.nik = '',
    this.npwp = '',
    this.address = '',
    this.waVerified = false,
    this.contractFlag = false,
    this.vendor = false,
    this.assigner = false,
    this.name = '',
    this.position = '',
    this.failedLoginCount = 0,
    this.concurrentUserAccess = 0,
    this.lastLoginDate = '',
    this.userLogin = '',
    this.cVendorId = 0,
    this.cVendorCode = '',
    this.cVendorName = '',
    this.cCostCenterId = 0,
    this.adOrganizationId = 0,
    this.adOrganizationName = '',
    this.businessCategoryIds = '',
    this.entitas = '',
    this.picName = '',
    this.userId = 0,
  });

  factory DataLoginAccesses.fromJson(Map<String, dynamic> json) =>
      _$DataLoginAccessesFromJson(json);
  Map<String, dynamic> toJson() => _$DataLoginAccessesToJson(this);

  @override
  List<Object?> get props => [
        active,
        phone,
        employee,
        firstName,
        lastName,
        email,
        businessUnit,
        ownerCode,
        city,
        nik,
        address,
        waVerified,
        contractFlag,
        name,
        position,
        failedLoginCount,
        concurrentUserAccess,
        lastLoginDate,
        userLogin,
        cVendorId,
        cVendorCode,
        cVendorName,
        cCostCenterId,
        adOrganizationId,
        adOrganizationName,
        businessCategoryIds,
        entitas,
        picName
      ];
}
