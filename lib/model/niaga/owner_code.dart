import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'owner_code.g.dart';

@JsonSerializable()
class OwnerCodeAccesses extends Equatable {
  @JsonKey(name: 'OWNER_CODE')
  final String? ownerCode;

  @JsonKey(name: 'NAME')
  final String? name;

  @JsonKey(name: 'ALAMAT')
  final String? alamat;

  @JsonKey(name: 'KOTA')
  final String? kota;

  @JsonKey(name: 'PROVINSI')
  final String? provinsi;

  @JsonKey(name: 'KODE_POS')
  final int? kodePos;

  @JsonKey(name: 'NEGARA')
  final String? negara;

  @JsonKey(name: 'CONTACT')
  final String? contact;

  @JsonKey(name: 'EMAIL')
  final String? email;

  @JsonKey(name: 'NO_TLP')
  final String? noTlp;

  @JsonKey(name: 'NO_HP')
  final String? noHp;

  @JsonKey(name: 'CONTACT2')
  final String? contact2;

  @JsonKey(name: 'EMAIL2')
  final String? email2;

  @JsonKey(name: 'NO_TLP2')
  final String? noTlp2;

  @JsonKey(name: 'BA')
  final String? bA;

  @JsonKey(name: 'NO_HP2')
  final String? noHp2;

  @JsonKey(name: 'BILL_CONTACT')
  final String? billContact;

  @JsonKey(name: 'BILL_EMAIL')
  final String? billEmail;

  @JsonKey(name: 'BILL_TEL_NO')
  final String? billTelpNo;

  @JsonKey(name: 'BILL_FAX_NO')
  final String? billFaxNo;

  @JsonKey(name: 'BILL_MOBILE')
  final String? billMobile;

  @JsonKey(name: 'OWNER_GROUP')
  final String? ownerGroup;

  @JsonKey(name: 'TAX_CODE')
  final String? taxCode;

  const OwnerCodeAccesses({
    this.ownerCode = '',
    this.name = '',
    this.alamat = '',
    this.kota = '',
    this.provinsi = '',
    this.kodePos = 0,
    this.negara = '',
    this.contact = '',
    this.email = '',
    this.noTlp = '',
    this.noHp = '',
    this.contact2 = '',
    this.email2 = '',
    this.noTlp2 = '',
    this.bA = '',
    this.noHp2 = '',
    this.billContact = '',
    this.billEmail = '',
    this.billTelpNo = '',
    this.billFaxNo = '',
    this.billMobile = '',
    this.ownerGroup = '',
    this.taxCode = '',
  });

  factory OwnerCodeAccesses.fromJson(Map<String, dynamic> json) =>
      _$OwnerCodeAccessesFromJson(json);
  Map<String, dynamic> toJson() => _$OwnerCodeAccessesToJson(this);

  @override
  List<Object?> get props => [
        ownerCode,
        name,
        alamat,
        kota,
        provinsi,
        kodePos,
        negara,
        contact,
        email,
        noTlp,
        noHp,
        contact2,
        email2,
        noTlp2,
        bA,
        noHp2,
        billContact,
        billEmail,
        billTelpNo,
        billFaxNo,
        billMobile,
        ownerGroup,
        taxCode
      ];
}
