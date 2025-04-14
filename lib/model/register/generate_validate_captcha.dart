import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'generate_validate_captcha.g.dart';

@JsonSerializable()
class GenerateValidateCaptcha extends Equatable {
  // final int? id;
  final String? email,
      sessionId,
      captchaEncode,
      otpCode,
      status; // Add this field

  const GenerateValidateCaptcha({
    // this.id = 0,
    this.email = '',
    this.sessionId = '', // Initialize it here
    this.captchaEncode = '',
    this.otpCode = '',
    this.status = '',
  });

  factory GenerateValidateCaptcha.fromJson(Map<String, dynamic> json) =>
      _$GenerateValidateCaptchaFromJson(json);

  Map<String, dynamic> toJson() => _$GenerateValidateCaptchaToJson(this);

  @override
  List<Object?> get props =>
      // [id, email, sessionId]; // Include sessionId in props
      [email, sessionId, captchaEncode, status]; // Include sessionId in props
}
