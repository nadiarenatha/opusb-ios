// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'packing_detail_niaga.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PackingItemAccesses _$PackingItemAccessesFromJson(Map<String, dynamic> json) =>
    PackingItemAccesses(
      jobType: json['JOB_TYPE'] as String? ?? '',
      orderNo: json['ORDER_NO'] as String? ?? '',
      orderDate: json['ORDER_DATE'] as String? ?? '',
      tipePengiriman: json['TIPE_PENGIRIMAN'] as String? ?? '',
      shipmentType: json['SHIPMENT_TYPE'] as String? ?? '',
      containerNo: json['CONTAINER_NO'] as String? ?? '',
      containerSize: json['CONTAINER_SIZE'] as String? ?? '',
      noPL: json['NO_PL'] as String? ?? '',
      ownerCode: json['OWNER_CODE'] as String? ?? '',
      asal: json['ASAL'] as String? ?? '',
      tujuan: json['TUJUAN'] as String? ?? '',
      vesselName: json['VESSEL_NAME'] as String? ?? '',
      voyageNo: json['VOYAGE_NO'] as String? ?? '',
      cartonNo: json['CARTON_NO'] as int? ?? 0,
      whsCode: json['WHS_CODE'] as String? ?? '',
      etaDate: json['ETA_DATE'] as String? ?? '',
      etdDate: json['ETD_DATE'] as String? ?? '',
      description: json['DESCRIPTION'] as String? ?? '',
      tipePL: json['TIPE_PL'] as String? ?? '',
      jenisPengiriman: json['JENIS_PENGIRIMAN'] as String? ?? '',
      status: json['STATUS'] as String? ?? '',
      volume: json['VOLUME'] as String? ?? '',
      rute: json['RUTE'] as String? ?? '',
    );

Map<String, dynamic> _$PackingItemAccessesToJson(
        PackingItemAccesses instance) =>
    <String, dynamic>{
      'JOB_TYPE': instance.jobType,
      'ORDER_NO': instance.orderNo,
      'ORDER_DATE': instance.orderDate,
      'TIPE_PENGIRIMAN': instance.tipePengiriman,
      'RUTE': instance.rute,
      'SHIPMENT_TYPE': instance.shipmentType,
      'CONTAINER_NO': instance.containerNo,
      'CONTAINER_SIZE': instance.containerSize,
      'NO_PL': instance.noPL,
      'OWNER_CODE': instance.ownerCode,
      'ASAL': instance.asal,
      'TUJUAN': instance.tujuan,
      'VESSEL_NAME': instance.vesselName,
      'VOYAGE_NO': instance.voyageNo,
      'CARTON_NO': instance.cartonNo,
      'WHS_CODE': instance.whsCode,
      'ETA_DATE': instance.etaDate,
      'ETD_DATE': instance.etdDate,
      'DESCRIPTION': instance.description,
      'TIPE_PL': instance.tipePL,
      'JENIS_PENGIRIMAN': instance.jenisPengiriman,
      'STATUS': instance.status,
      'VOLUME': instance.volume,
    };
