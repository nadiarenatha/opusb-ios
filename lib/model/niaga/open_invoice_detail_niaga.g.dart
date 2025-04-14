// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'open_invoice_detail_niaga.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InvoiceItemAccesses _$InvoiceItemAccessesFromJson(Map<String, dynamic> json) =>
    InvoiceItemAccesses(
      customerId: json['customer_id'] as String? ?? '',
      tanggalInvoice: json['tanggal_invoice'] as String? ?? '',
      customerBilling: json['customer_billing'] as String? ?? '',
      invoiceNumber: json['invoice_number'] as String? ?? '',
      hargaPengiriman: (json['harga_pengiriman'] as num?)?.toDouble() ?? 0,
      totalInvoice: json['total_invoice'] as int? ?? 0,
      sisaPembayaran: json['sisa_pembayaran'] as int? ?? 0,
      tagihanTerbayar: json['tagihan_terbayar'] as int? ?? 0,
      statusPayment: json['status_payment'] as String? ?? '',
      pembayaranTerakhir: json['pembayaran_terakhir'] as String? ?? '',
      tanggalJatuhTempo: json['tanggal_jatuh_tempo'] as String? ?? '',
      namaKapal: json['nama_kapal'] as String? ?? '',
      tanggalBerangkat: json['tanggal_berangkat'] as String? ?? '',
      typePengiriman: json['type_pengiriman'] as String? ?? '',
      customerJob: json['customer_job'] as String? ?? '',
      noJob: json['no_job'] as String? ?? '',
      noPL: json['no_pl'] as String? ?? '',
      vaBCA: json['va_bca'] as String? ?? '',
      vaBCAName: json['va_bca_name'] as String? ?? '',
      vaMandiri: json['va_mandiri'] as String? ?? '',
      vaMandiriName: json['va_mandiri_name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      rute: json['rute'] as String? ?? '',
      volume: json['volume'] as String? ?? '',
      ppn: json['ppn'] as int? ?? 0,
      noOrderOnline: json['no_order_online'] as String? ?? '',
      pph: json['pph'] as int? ?? 0,
      setelahPPN: json['setelah_ppn'] as int? ?? 0,
      urlEspay: json['url_espay'] as String? ?? '',
      invoiceGroup: json['invoice_group'] as String? ?? '',
      cabang: json['cabang'] as String? ?? '',
      flagEspay: json['flag_espay'] as bool? ?? false,
      taxCode: json['tax_code'] as String? ?? '',
      penggunaanPoint: json['penggunaan_point'] as int? ?? 0,
    );

Map<String, dynamic> _$InvoiceItemAccessesToJson(
        InvoiceItemAccesses instance) =>
    <String, dynamic>{
      'customer_id': instance.customerId,
      'tanggal_invoice': instance.tanggalInvoice,
      'customer_billing': instance.customerBilling,
      'invoice_number': instance.invoiceNumber,
      'harga_pengiriman': instance.hargaPengiriman,
      'total_invoice': instance.totalInvoice,
      'sisa_pembayaran': instance.sisaPembayaran,
      'tagihan_terbayar': instance.tagihanTerbayar,
      'status_payment': instance.statusPayment,
      'pembayaran_terakhir': instance.pembayaranTerakhir,
      'tanggal_jatuh_tempo': instance.tanggalJatuhTempo,
      'nama_kapal': instance.namaKapal,
      'tanggal_berangkat': instance.tanggalBerangkat,
      'type_pengiriman': instance.typePengiriman,
      'customer_job': instance.customerJob,
      'no_job': instance.noJob,
      'no_pl': instance.noPL,
      'va_bca': instance.vaBCA,
      'va_bca_name': instance.vaBCAName,
      'va_mandiri': instance.vaMandiri,
      'va_mandiri_name': instance.vaMandiriName,
      'no_order_online': instance.noOrderOnline,
      'setelah_ppn': instance.setelahPPN,
      'url_espay': instance.urlEspay,
      'invoice_group': instance.invoiceGroup,
      'flag_espay': instance.flagEspay,
      'tax_code': instance.taxCode,
      'penggunaan_point': instance.penggunaanPoint,
      'email': instance.email,
      'rute': instance.rute,
      'volume': instance.volume,
      'cabang': instance.cabang,
      'ppn': instance.ppn,
      'pph': instance.pph,
    };
