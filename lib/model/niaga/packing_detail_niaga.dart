import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'packing_detail_niaga.g.dart';

@JsonSerializable()
class PackingItemAccesses extends Equatable {
  @JsonKey(name: 'JOB_TYPE')
  final String? jobType;

  @JsonKey(name: 'ORDER_NO')
  final String? orderNo;

  @JsonKey(name: 'ORDER_DATE')
  final String? orderDate;

  @JsonKey(name: 'TIPE_PENGIRIMAN') 
  final String? tipePengiriman;

  @JsonKey(name: 'RUTE') 
  final String? rute;

  @JsonKey(name: 'SHIPMENT_TYPE')
  final String? shipmentType;

  @JsonKey(name: 'CONTAINER_NO')
  final String? containerNo;

  @JsonKey(name: 'CONTAINER_SIZE')
  final String? containerSize;

  @JsonKey(name: 'NO_PL')
  final String? noPL;

  @JsonKey(name: 'OWNER_CODE')
  final String? ownerCode;

  @JsonKey(name: 'ASAL')
  final String? asal;

  @JsonKey(name: 'TUJUAN')
  final String? tujuan;

  @JsonKey(name: 'VESSEL_NAME')
  final String? vesselName;

  @JsonKey(name: 'VOYAGE_NO')
  final String? voyageNo;

  @JsonKey(name: 'CARTON_NO')
  final int? cartonNo;

  @JsonKey(name: 'WHS_CODE')
  final String? whsCode;

  @JsonKey(name: 'ETA_DATE')
  final String? etaDate;
  
  @JsonKey(name: 'ETD_DATE')
  final String? etdDate;

  @JsonKey(name: 'DESCRIPTION')
  final String? description;

  @JsonKey(name: 'TIPE_PL')
  final String? tipePL;

  @JsonKey(name: 'JENIS_PENGIRIMAN')
  final String? jenisPengiriman;

  @JsonKey(name: 'STATUS')
  final String? status;

  @JsonKey(name: 'VOLUME')
  final String? volume;

  const PackingItemAccesses({
    this.jobType = '',
    this.orderNo = '',
    this.orderDate = '',
    this.tipePengiriman = '',
    this.shipmentType = '',
    this.containerNo = '',
    this.containerSize = '',
    this.noPL = '',
    this.ownerCode = '',
    this.asal = '',
    this.tujuan = '',
    this.vesselName = '',
    this.voyageNo = '',
    this.cartonNo = 0,
    this.whsCode = '',
    this.etaDate = '',
    this.etdDate = '',
    this.description = '',
    this.tipePL = '',
    this.jenisPengiriman = '',
    this.status = '',
    this.volume = '',
    this.rute = '',
  });

  factory PackingItemAccesses.fromJson(Map<String, dynamic> json) =>
      _$PackingItemAccessesFromJson(json);
  Map<String, dynamic> toJson() => _$PackingItemAccessesToJson(this);

  String get formattedTimeETA {
    if (etaDate != null && etaDate!.isNotEmpty) {
      try {
        final dateTime = DateTime.parse(etaDate!);
        // Format to "YYYY-MM-DD HH:MM"
        return "${dateTime.year.toString().padLeft(4, '0')}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
      } catch (e) {
        // Handle parsing errors
        return '';
      }
    }
    return '';
  }

  String get formattedTimeETD {
    if (etaDate != null && etdDate!.isNotEmpty) {
      try {
        final dateTime = DateTime.parse(etdDate!);
        // Format to "YYYY-MM-DD HH:MM"
        return "${dateTime.year.toString().padLeft(4, '0')}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
      } catch (e) {
        // Handle parsing errors
        return '';
      }
    }
    return '';
  }

  @override
  List<Object?> get props => [
        jobType,
        orderNo,
        orderDate,
        tipePengiriman,
        shipmentType,
        containerNo,
        containerSize,
        noPL,
        ownerCode,
        asal,
        tujuan,
        vesselName,
        voyageNo,
        cartonNo,
        whsCode,
        etaDate,
        etdDate,
        description,
        tipePL,
        jenisPengiriman,
        status,
        volume
      ];
}
