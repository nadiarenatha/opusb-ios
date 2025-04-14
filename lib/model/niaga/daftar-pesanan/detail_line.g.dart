// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'detail_line.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DetailLineAccesses _$DetailLineAccessesFromJson(Map<String, dynamic> json) =>
    DetailLineAccesses(
      komoditi: json['komoditi'] as String? ?? '',
      id: json['id'] as int? ?? 0,
      headerId: json['headerId'] as int? ?? 0,
      price: (json['price'] as num?)?.toDouble() ?? 0,
      containerSize: json['containerSize'] as String? ?? '',
      productDescription: json['productDescription'] as String? ?? '',
      quantity: json['quantity'] as int? ?? 0,
      uom: json['uom'] as String? ?? '',
      userPanjang: (json['userPanjang'] as num?)?.toDouble() ?? 0,
      userLebar: (json['userLebar'] as num?)?.toDouble() ?? 0,
      userTinggi: (json['userTinggi'] as num?)?.toDouble() ?? 0,
      userTotalVolume: (json['userTotalVolume'] as num?)?.toDouble() ?? 0,
      userTotalWeight: (json['userTotalWeight'] as num?)?.toDouble() ?? 0,
      niagaPanjang: (json['niagaPanjang'] as num?)?.toDouble() ?? 0,
      niagaLebar: (json['niagaLebar'] as num?)?.toDouble() ?? 0,
      niagaTinggi: (json['niagaTinggi'] as num?)?.toDouble() ?? 0,
      niagaTotalVolume: (json['niagaTotalVolume'] as num?)?.toDouble() ?? 0,
      niagaTotalWeight: (json['niagaTotalWeight'] as num?)?.toDouble() ?? 0,
      invoiceNum: json['invoiceNum'] as String? ?? '',
    );

Map<String, dynamic> _$DetailLineAccessesToJson(DetailLineAccesses instance) =>
    <String, dynamic>{
      'komoditi': instance.komoditi,
      'containerSize': instance.containerSize,
      'productDescription': instance.productDescription,
      'uom': instance.uom,
      'invoiceNum': instance.invoiceNum,
      'id': instance.id,
      'headerId': instance.headerId,
      'quantity': instance.quantity,
      'price': instance.price,
      'userPanjang': instance.userPanjang,
      'userLebar': instance.userLebar,
      'userTinggi': instance.userTinggi,
      'userTotalVolume': instance.userTotalVolume,
      'userTotalWeight': instance.userTotalWeight,
      'niagaPanjang': instance.niagaPanjang,
      'niagaLebar': instance.niagaLebar,
      'niagaTinggi': instance.niagaTinggi,
      'niagaTotalVolume': instance.niagaTotalVolume,
      'niagaTotalWeight': instance.niagaTotalWeight,
    };
