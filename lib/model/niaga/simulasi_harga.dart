import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'simulasi_harga.g.dart';

@JsonSerializable()
class SimulasiHargaAccesses extends Equatable {
  @JsonKey(name: 'KOTA_ASAL')
  final String kotaAsal;

  @JsonKey(name: 'PORT_ASAL')
  final String portAsal;

  @JsonKey(name: 'KOTA_TUJUAN')
  final String kotaTujuan;

  @JsonKey(name: 'PORT_TUJUAN')
  final String portTujuan;

  @JsonKey(name: 'JENIS_PENGIRIMAN')
  final String jenisPengiriman;

  @JsonKey(name: 'HARGA')
  final dynamic harga; // Can be int or Map<String, dynamic>

  final String? message, caption, url;

  const SimulasiHargaAccesses({
    this.kotaAsal = '',
    this.portAsal = '',
    this.kotaTujuan = '',
    this.portTujuan = '',
    this.jenisPengiriman = '',
    required this.harga,
    this.caption = '',
    this.url = '',
    this.message = '',
  });

  factory SimulasiHargaAccesses.fromJson(Map<String, dynamic> json) =>
      _$SimulasiHargaAccessesFromJson(json);
  Map<String, dynamic> toJson() => _$SimulasiHargaAccessesToJson(this);

  @override
  List<Object?> get props => [
        kotaAsal,
        portAsal,
        kotaTujuan,
        portTujuan,
        jenisPengiriman,
        harga,
        message,
        caption,
        url,
      ];
}
