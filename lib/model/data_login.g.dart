// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_login.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DataLoginAccesses _$DataLoginAccessesFromJson(Map<String, dynamic> json) =>
    DataLoginAccesses(
      active: json['active'] as bool? ?? false,
      phone: json['phone'] as String? ?? '',
      employee: json['employee'] as bool? ?? false,
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      businessUnit: json['businessUnit'] as String? ?? '',
      ownerCode: json['ownerCode'] as String? ?? '',
      city: json['city'] as String? ?? '',
      nik: json['nik'] as String? ?? '',
      npwp: json['npwp'] as String? ?? '',
      address: json['address'] as String? ?? '',
      waVerified: json['waVerified'] as bool? ?? false,
      contractFlag: json['contractFlag'] as bool? ?? false,
      vendor: json['vendor'] as bool? ?? false,
      assigner: json['assigner'] as bool? ?? false,
      name: json['name'] as String? ?? '',
      position: json['position'] as String? ?? '',
      failedLoginCount: json['failedLoginCount'] as int? ?? 0,
      concurrentUserAccess: json['concurrentUserAccess'] as int? ?? 0,
      lastLoginDate: json['lastLoginDate'] as String? ?? '',
      userLogin: json['userLogin'] as String? ?? '',
      cVendorId: json['cVendorId'] as int? ?? 0,
      cVendorCode: json['cVendorCode'] as String? ?? '',
      cVendorName: json['cVendorName'] as String? ?? '',
      cCostCenterId: json['cCostCenterId'] as int? ?? 0,
      adOrganizationId: json['adOrganizationId'] as int? ?? 0,
      adOrganizationName: json['adOrganizationName'] as String? ?? '',
      businessCategoryIds: json['businessCategoryIds'] as String? ?? '',
      entitas: json['entitas'] as String? ?? '',
      picName: json['picName'] as String? ?? '',
      userId: json['userId'] as int? ?? 0,
    );

Map<String, dynamic> _$DataLoginAccessesToJson(DataLoginAccesses instance) =>
    <String, dynamic>{
      'phone': instance.phone,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
      'businessUnit': instance.businessUnit,
      'ownerCode': instance.ownerCode,
      'city': instance.city,
      'nik': instance.nik,
      'npwp': instance.npwp,
      'address': instance.address,
      'position': instance.position,
      'cVendorCode': instance.cVendorCode,
      'cVendorName': instance.cVendorName,
      'lastLoginDate': instance.lastLoginDate,
      'userLogin': instance.userLogin,
      'adOrganizationName': instance.adOrganizationName,
      'businessCategoryIds': instance.businessCategoryIds,
      'name': instance.name,
      'entitas': instance.entitas,
      'picName': instance.picName,
      'active': instance.active,
      'employee': instance.employee,
      'waVerified': instance.waVerified,
      'contractFlag': instance.contractFlag,
      'vendor': instance.vendor,
      'assigner': instance.assigner,
      'failedLoginCount': instance.failedLoginCount,
      'concurrentUserAccess': instance.concurrentUserAccess,
      'cVendorId': instance.cVendorId,
      'cCostCenterId': instance.cCostCenterId,
      'adOrganizationId': instance.adOrganizationId,
      'userId': instance.userId,
    };
