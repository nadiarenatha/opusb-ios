import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:intl/intl.dart';

part 'open_invoice_detail_niaga.g.dart';

@JsonSerializable()
class InvoiceItemAccesses extends Equatable {
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
  final int? totalInvoice;

  @JsonKey(name: 'sisa_pembayaran')
  final int? sisaPembayaran;

  @JsonKey(name: 'tagihan_terbayar')
  final int? tagihanTerbayar;

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

  @JsonKey(name: 'va_bca_name')
  final String? vaBCAName;

  @JsonKey(name: 'va_mandiri')
  final String? vaMandiri;

  @JsonKey(name: 'va_mandiri_name')
  final String? vaMandiriName;

  @JsonKey(name: 'no_order_online')
  final String? noOrderOnline;

  @JsonKey(name: 'setelah_ppn')
  final int? setelahPPN;

  @JsonKey(name: 'url_espay')
  final String? urlEspay;

  @JsonKey(name: 'invoice_group')
  final String? invoiceGroup;

  @JsonKey(name: 'flag_espay')
  final bool? flagEspay;

  @JsonKey(name: 'tax_code')
  final String? taxCode;

  @JsonKey(name: 'penggunaan_point')
  final int? penggunaanPoint;

  final String? email, rute, volume, cabang;
  final int? ppn, pph;

  const InvoiceItemAccesses({
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
    this.noOrderOnline = '',
    this.pph = 0,
    this.setelahPPN = 0,
    this.urlEspay = '',
    this.invoiceGroup = '',
    this.cabang = '',
    this.flagEspay = false,
    this.taxCode = '',
    this.penggunaanPoint = 0,
  });

  factory InvoiceItemAccesses.fromJson(Map<String, dynamic> json) =>
      _$InvoiceItemAccessesFromJson(json);
  Map<String, dynamic> toJson() => _$InvoiceItemAccessesToJson(this);

  String get formattedTotalInvoice {
    if (totalInvoice == null) return 'Rp0,00';

    final NumberFormat currencyFormat = NumberFormat.currency(
      locale: 'ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return currencyFormat.format(totalInvoice) + ',-';
  }

  String get formattedTagihanTerbayar {
    if (tagihanTerbayar == null) return 'Rp0,00';

    final NumberFormat currencyFormat = NumberFormat.currency(
      locale: 'ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return currencyFormat.format(tagihanTerbayar) + ',-';
  }

  String get formattedSisaPembayaran {
    if (sisaPembayaran == null) return 'Rp0,00';

    final NumberFormat currencyFormat = NumberFormat.currency(
      locale: 'ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return currencyFormat.format(sisaPembayaran) + ',-';
  }

  String get formattedPPN {
    if (ppn == null) return 'Rp0,00';

    final NumberFormat currencyFormat = NumberFormat.currency(
      locale: 'ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return currencyFormat.format(ppn) + ',-';
  }

  String get formattedPPH {
    if (pph == null) return 'Rp0,00';

    final NumberFormat currencyFormat = NumberFormat.currency(
      locale: 'ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return currencyFormat.format(pph) + ',-';
  }

  String get formattedHargaPengiriman {
    if (hargaPengiriman == null) return 'Rp0,00';

    final NumberFormat currencyFormat = NumberFormat.currency(
      locale: 'ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return currencyFormat.format(hargaPengiriman) + ',-';
  }

  String get formattedSetelahPPN {
    if (setelahPPN == null) return 'Rp0,00';

    final NumberFormat currencyFormat = NumberFormat.currency(
      locale: 'ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return currencyFormat.format(setelahPPN) + ',-';
  }

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
        ppn,
        pph,
        urlEspay,
        invoiceGroup,
        cabang,
        penggunaanPoint
      ];
}
