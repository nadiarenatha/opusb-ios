import 'package:json_annotation/json_annotation.dart';

part 'wa_push_otp.g.dart';

@JsonSerializable()
class WAPushOTPNiaga {
  final String? no;
  final String? email;

  WAPushOTPNiaga({
    this.no = '',
    this.email = '',
  });

  factory WAPushOTPNiaga.fromJson(Map<String, dynamic> json) =>
      _$WAPushOTPNiagaFromJson(json);

  Map<String, dynamic> toJson() => _$WAPushOTPNiagaToJson(this);

  @override
  String toString() {
    return 'WAPushOTPNiaga[No: $no, Email: $email]';
  }
}
