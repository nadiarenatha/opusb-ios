import 'package:json_annotation/json_annotation.dart';

part 'wa_verifikasi.g.dart';

@JsonSerializable()
class WAVerifikasiNiaga {
  final String? no;
  final String? email;
  final String? otp;

  WAVerifikasiNiaga({
    this.no = '',
    this.email = '',
    this.otp = '',
  });

  factory WAVerifikasiNiaga.fromJson(Map<String, dynamic> json) =>
      _$WAVerifikasiNiagaFromJson(json);

  Map<String, dynamic> toJson() => _$WAVerifikasiNiagaToJson(this);

  @override
  String toString() {
    return 'WAVerifikasiNiaga[No: $no, Email: $email, OTP: $otp]';
  }
}
