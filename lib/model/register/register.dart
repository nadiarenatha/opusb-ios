import 'package:json_annotation/json_annotation.dart';
part 'register.g.dart';

@JsonSerializable()
class RegisterCredential {
  // final String email;
  final String? phone,
      picName,
      userLogin,
      firstName,
      lastName,
      email,
      name,
      city,
      nik,
      npwp,
      password,
      adOrganizationName,
      businessUnit,
      entitas,
      ownerCode,
      address;

  final bool? active, employee, waVerified, contractFlag, assigner;

  final int? adOrganizationId;

  RegisterCredential({
    this.userLogin = '',
    this.picName = '',
    this.firstName = '',
    this.lastName = '',
    this.email = '',
    this.name = '',
    this.businessUnit = '',
    this.address = '',
    this.city = '',
    this.password = '',
    this.active = false,
    this.employee = false,
    this.phone = '',
    this.adOrganizationId = 1,
    this.nik = '',
    this.npwp = '',
    this.entitas = '',
    this.adOrganizationName = '',
    this.ownerCode = '',
    this.contractFlag = false,
    this.waVerified = false,
    this.assigner = false,
  });

  factory RegisterCredential.fromJson(Map<String, dynamic> json) =>
      _$RegisterCredentialFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterCredentialToJson(this);

  @override
  List<Object?> get props =>
      [
        phone,
        picName,
        userLogin,
        firstName,
        lastName,
        email,
        businessUnit,
        name,
        address,
        city,
        nik,
        npwp,
        password,
        entitas,
        active,
        adOrganizationId,
        employee,
        adOrganizationName,
        ownerCode,
        contractFlag,
        waVerified,
        assigner
      ]; // Include sessionId in props
}
