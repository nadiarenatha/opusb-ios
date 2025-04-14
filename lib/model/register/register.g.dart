// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterCredential _$RegisterCredentialFromJson(Map<String, dynamic> json) =>
    RegisterCredential(
      userLogin: json['userLogin'] as String? ?? '',
      picName: json['picName'] as String? ?? '',
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      name: json['name'] as String? ?? '',
      businessUnit: json['businessUnit'] as String? ?? '',
      address: json['address'] as String? ?? '',
      city: json['city'] as String? ?? '',
      password: json['password'] as String? ?? '',
      active: json['active'] as bool? ?? false,
      employee: json['employee'] as bool? ?? false,
      phone: json['phone'] as String? ?? '',
      adOrganizationId: json['adOrganizationId'] as int? ?? 1,
      nik: json['nik'] as String? ?? '',
      npwp: json['npwp'] as String? ?? '',
      entitas: json['entitas'] as String? ?? '',
      adOrganizationName: json['adOrganizationName'] as String? ?? '',
      ownerCode: json['ownerCode'] as String? ?? '',
      contractFlag: json['contractFlag'] as bool? ?? false,
      waVerified: json['waVerified'] as bool? ?? false,
      assigner: json['assigner'] as bool? ?? false,
    );

Map<String, dynamic> _$RegisterCredentialToJson(RegisterCredential instance) =>
    <String, dynamic>{
      'phone': instance.phone,
      'picName': instance.picName,
      'userLogin': instance.userLogin,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
      'name': instance.name,
      'city': instance.city,
      'nik': instance.nik,
      'npwp': instance.npwp,
      'password': instance.password,
      'adOrganizationName': instance.adOrganizationName,
      'businessUnit': instance.businessUnit,
      'entitas': instance.entitas,
      'ownerCode': instance.ownerCode,
      'address': instance.address,
      'active': instance.active,
      'employee': instance.employee,
      'waVerified': instance.waVerified,
      'contractFlag': instance.contractFlag,
      'assigner': instance.assigner,
      'adOrganizationId': instance.adOrganizationId,
    };
