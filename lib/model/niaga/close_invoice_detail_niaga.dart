import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'close_invoice_detail_niaga.g.dart';

@JsonSerializable()
class InvoiceCloseItemAccesses extends Equatable {
  @JsonKey(name: 'customer_id')
  final String? customerId;

  @JsonKey(name: 'tanggal_invoice')
  final String? tanggalInvoice;

  @JsonKey(name: 'customer_billing')
  final String? customerBilling;

  @JsonKey(name: 'invoice_number')
  final String? invoiceNumber;

  @JsonKey(name: 'harga_pengiriman')
  final double? hargaPengiriman;

  @JsonKey(name: 'total_invoice')
  final double? totalInvoice;

  @JsonKey(name: 'sisa_pembayaran')
  final double? sisaPembayaran;

  @JsonKey(name: 'tagihan_terbayar')
  final double? tagihanTerbayar;

  @JsonKey(name: 'status_payment')
  final String? statusPayment;

  @JsonKey(name: 'pembayaran_terakhir')
  final String? pembayaranTerakhir;

  @JsonKey(name: 'tanggal_jatuh_tempo')
  final String? tanggalJatuhTempo;

  @JsonKey(name: 'nama_kapal')
  final String? namaKapal;

  @JsonKey(name: 'tanggal_berangkat')
  final String? tanggalBerangkat;

  @JsonKey(name: 'type_pengiriman')
  final String? typePengiriman;

  @JsonKey(name: 'customer_job')
  final String? customerJob;

  @JsonKey(name: 'no_job')
  final String? noJob;

  @JsonKey(name: 'no_pl')
  final String? noPL;

  @JsonKey(name: 'va_bca')
  final String? vaBCA;

  // @JsonKey(name: 'va_bca', fromJson: _stringToInt)
  // final int vaBCA;

  @JsonKey(name: 'va_bca_name')
  final String? vaBCAName;

  @JsonKey(name: 'va_mandiri')
  final String? vaMandiri;

  // @JsonKey(name: 'va_mandiri', fromJson: _stringToInt)
  // final int vaMandiri;

  @JsonKey(name: 'va_mandiri_name')
  final String? vaMandiriName;

  final String? email, rute, volume;
  final double? ppn;

  const InvoiceCloseItemAccesses({
    this.customerId = '',
    this.tanggalInvoice = '',
    this.customerBilling = '',
    this.invoiceNumber = '',
    this.hargaPengiriman = 0,
    this.totalInvoice = 0,
    this.sisaPembayaran = 0,
    this.tagihanTerbayar = 0,
    this.statusPayment = '',
    this.pembayaranTerakhir = '',
    this.tanggalJatuhTempo = '',
    this.namaKapal = '',
    this.tanggalBerangkat = '',
    this.typePengiriman = '',
    this.customerJob = '',
    this.noJob = '',
    this.noPL = '',
    this.vaBCA = '',
    // this.vaBCA = 0,
    this.vaBCAName = '',
    this.vaMandiri = '',
    // this.vaMandiri = 0,
    this.vaMandiriName = '',
    this.email = '',
    this.rute = '',
    this.volume = '',
    this.ppn = 0,
  });

  factory InvoiceCloseItemAccesses.fromJson(Map<String, dynamic> json) =>
      _$InvoiceCloseItemAccessesFromJson(json);
  Map<String, dynamic> toJson() => _$InvoiceCloseItemAccessesToJson(this);

  @override
  List<Object?> get props => [
        customerId,
        tanggalInvoice,
        customerBilling,
        invoiceNumber,
        hargaPengiriman,
        totalInvoice,
        sisaPembayaran,
        tagihanTerbayar,
        statusPayment,
        pembayaranTerakhir,
        tanggalJatuhTempo,
        namaKapal,
        tanggalBerangkat,
        typePengiriman,
        customerJob,
        noJob,
        noPL,
        vaBCA,
        vaBCAName,
        vaMandiri,
        vaMandiriName,
        email,
        rute,
        volume,
        ppn
      ];

  // static int? _stringToInt(String? value) {
  //   return value != null ? int.tryParse(value) : null;
  // }
}
