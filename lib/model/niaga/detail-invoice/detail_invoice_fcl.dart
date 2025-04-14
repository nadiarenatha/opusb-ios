import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:intl/intl.dart';

part 'detail_invoice_fcl.g.dart';

@JsonSerializable()
class DetailInvoiceFCLAccesses extends Equatable {
  @JsonKey(name: 'customer_id')
  final String? customerId;

  @JsonKey(name: 'tanggal_invoice')
  final String? tanggalInvoice;

  @JsonKey(name: 'customer_billing')
  final String? customerBiling;

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

  @JsonKey(name: 'qty_container')
  final double? qtyContainer;

  @JsonKey(name: 'type_pengiriman')
  final String? typePengiriman;

  @JsonKey(name: 'no_pl')
  final String? noPl;

  @JsonKey(name: 'customer_job')
  final String? customerJob;

  @JsonKey(name: 'no_job')
  final String? noJob;

  @JsonKey(name: 'va_bca')
  final String? vaBCA;

  @JsonKey(name: 'va_bca_name')
  final String? vaBCAName;

  @JsonKey(name: 'va_mandiri')
  final String? vaMandiri;

  @JsonKey(name: 'va_mandiri_name')
  final String? vaMandiriName;

  @JsonKey(name: 'harga_kontrak')
  final double? hargaKontrak;

  @JsonKey(name: 'biaya_karantina')
  final double? biayaKarantina;

  @JsonKey(name: 'biaya_dokumen')
  final double? biayaDokumen;

  @JsonKey(name: 'biaya_asuransi')
  final double? biayaAsuransi;

  final String? email, rute, volume;

  final int? ppn;

  const DetailInvoiceFCLAccesses({
    this.customerId = '',
    this.tanggalInvoice = '',
    this.customerBiling = '',
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
    this.qtyContainer = 0,
    this.typePengiriman = '',
    this.noPl = '',
    this.customerJob = '',
    this.noJob = '',
    this.vaBCA = '',
    this.vaBCAName = '',
    this.vaMandiri = '',
    this.vaMandiriName = '',
    this.hargaKontrak = 0,
    this.biayaKarantina = 0,
    this.biayaDokumen = 0,
    this.biayaAsuransi = 0,
    this.email = '',
    this.rute = '',
    this.volume = '',
    this.ppn = 0,
  });

  factory DetailInvoiceFCLAccesses.fromJson(Map<String, dynamic> json) =>
      _$DetailInvoiceFCLAccessesFromJson(json);
  Map<String, dynamic> toJson() => _$DetailInvoiceFCLAccessesToJson(this);

  String get formattedHargaKontrak {
    if (hargaKontrak == null) return 'Rp0,00';

    final NumberFormat currencyFormat = NumberFormat.currency(
      locale: 'ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return currencyFormat.format(hargaKontrak) + ',-';
  }

  String get formattedBiayaKarantina {
    if (biayaKarantina == null) return 'Rp0,00';

    final NumberFormat currencyFormat = NumberFormat.currency(
      locale: 'ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return currencyFormat.format(biayaKarantina) + ',-';
  }

  String get formattedBiayaDokumen {
    if (biayaDokumen == null) return 'Rp0,00';

    final NumberFormat currencyFormat = NumberFormat.currency(
      locale: 'ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return currencyFormat.format(biayaDokumen) + ',-';
  }

  String get formattedBiayaAsuransi {
    if (biayaAsuransi == null) return 'Rp0,00';

    final NumberFormat currencyFormat = NumberFormat.currency(
      locale: 'ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return currencyFormat.format(biayaAsuransi) + ',-';
  }

  String get formattedHargaPengiriman {
    if (biayaAsuransi == null) return 'Rp0,00';

    final NumberFormat currencyFormat = NumberFormat.currency(
      locale: 'ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return currencyFormat.format(hargaPengiriman) + ',-';
  }

  @override
  List<Object?> get props => [
        customerId,
        tanggalInvoice,
        customerBiling,
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
        qtyContainer,
        typePengiriman,
        typePengiriman,
        noPl,
        customerJob,
        noJob,
        vaBCA,
        vaBCAName,
        vaMandiri,
        vaMandiriName,
        hargaKontrak,
        biayaKarantina,
        biayaDokumen,
        biayaAsuransi,
        email,
        rute,
        volume,
        ppn
      ];
}
