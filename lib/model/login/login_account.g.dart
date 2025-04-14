// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginAccount _$LoginAccountFromJson(Map<String, dynamic> json) => LoginAccount(
      id: json['id'] as int? ?? 0,
      authorities: (json['authorities'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$LoginAccountToJson(LoginAccount instance) =>
    <String, dynamic>{
      'id': instance.id,
      'authorities': instance.authorities,
    };
