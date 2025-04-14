import 'package:json_annotation/json_annotation.dart';

part 'espay.g.dart';

@JsonSerializable()
class EspayResponse {

  final String? webRedirectUrl, responseCode, responseMessage;

  EspayResponse({
    this.webRedirectUrl = '',
    this.responseCode = '',
    this.responseMessage = '',
  });

  factory EspayResponse.fromJson(Map<String, dynamic> json) =>
      _$EspayResponseFromJson(json);

  Map<String, dynamic> toJson() => _$EspayResponseToJson(this);

  @override
  String toString() {
    return 'EspayResponse[ Web Direct Url: $webRedirectUrl]';
  }
}
