import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'detail_cari_barang.g.dart';

@JsonSerializable()
class DetailDataBarangAccesses extends Equatable {
  @JsonKey(name: 'ASN_NO')
  final int? asnNo;

  @JsonKey(name: 'PO_NO')
  final String? poNo;

  @JsonKey(name: 'NO_RESI')
  final String? noResi;

  @JsonKey(name: 'PENERIMA')
  final String? penerima;

  @JsonKey(name: 'VOLUME')
  final double? volume;

  @JsonKey(name: 'SEND_ASN_DATE')
  final String? sendAsnDate;

  @JsonKey(name: 'RESULT_COUNT')
  final int? resultCount;

  @JsonKey(name: 'WHS_CODE')
  final String? whsCode;

  @JsonKey(name: 'DIVISION')
  final String? division;


  const DetailDataBarangAccesses({
    this.asnNo = 0,
    this.poNo = '',
    this.noResi = '',
    this.penerima = '',
    this.volume = 0,
    this.sendAsnDate = '',
    this.resultCount = 0,
    this.whsCode = '',
    this.division = '',
  });

  factory DetailDataBarangAccesses.fromJson(Map<String, dynamic> json) =>
      _$DetailDataBarangAccessesFromJson(json);
  Map<String, dynamic> toJson() => _$DetailDataBarangAccessesToJson(this);

  String get formattedTime {
    if (sendAsnDate != null && sendAsnDate!.isNotEmpty) {
      try {
        final dateTime = DateTime.parse(sendAsnDate!);
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
        asnNo,
        poNo,
        noResi,
        penerima,
        volume,
        sendAsnDate,
        resultCount,
        whsCode,
        division
      ];
}
