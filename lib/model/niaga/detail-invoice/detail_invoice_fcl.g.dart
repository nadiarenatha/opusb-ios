// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'detail_invoice_fcl.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DetailInvoiceFCLAccesses _$DetailInvoiceFCLAccessesFromJson(
        Map<String, dynamic> json) =>
    DetailInvoiceFCLAccesses(
      customerId: json['customer_id'] as String? ?? '',
      tanggalInvoice: json['tanggal_invoice'] as String? ?? '',
      customerBiling: json['customer_billing'] as String? ?? '',
      invoiceNumber: json['invoice_number'] as String? ?? '',
      hargaPengiriman: (json['harga_pengiriman'] as num?)?.toDouble() ?? 0,
      totalInvoice: (json['total_invoice'] as num?)?.toDouble() ?? 0,
      sisaPembayaran: (json['sisa_pembayaran'] as num?)?.toDouble() ?? 0,
      tagihanTerbayar: (json['tagihan_terbayar'] as num?)?.toDouble() ?? 0,
      statusPayment: json['status_payment'] as String? ?? '',
      pembayaranTerakhir: json['pembayaran_terakhir'] as String? ?? '',
      tanggalJatuhTempo: json['tanggal_jatuh_tempo'] as String? ?? '',
      namaKapal: json['nama_kapal'] as String? ?? '',
      tanggalBerangkat: json['tanggal_berangkat'] as String? ?? '',
      qtyContainer: (json['qty_container'] as num?)?.toDouble() ?? 0,
      typePengiriman: json['type_pengiriman'] as String? ?? '',
      noPl: json['no_pl'] as String? ?? '',
      customerJob: json['customer_job'] as String? ?? '',
      noJob: json['no_job'] as String? ?? '',
      vaBCA: json['va_bca'] as String? ?? '',
      vaBCAName: json['va_bca_name'] as String? ?? '',
      vaMandiri: json['va_mandiri'] as String? ?? '',
      vaMandiriName: json['va_mandiri_name'] as String? ?? '',
      hargaKontrak: (json['harga_kontrak'] as num?)?.toDouble() ?? 0,
      biayaKarantina: (json['biaya_karantina'] as num?)?.toDouble() ?? 0,
      biayaDokumen: (json['biaya_dokumen'] as num?)?.toDouble() ?? 0,
      biayaAsuransi: (json['biaya_asuransi'] as num?)?.toDouble() ?? 0,
      email: json['email'] as String? ?? '',
      rute: json['rute'] as String? ?? '',
      volume: json['volume'] as String? ?? '',
      ppn: json['ppn'] as int? ?? 0,
    );

Map<String, dynamic> _$DetailInvoiceFCLAccessesToJson(
        DetailInvoiceFCLAccesses instance) =>
    <String, dynamic>{
      'customer_id': instance.customerId,
      'tanggal_invoice': instance.tanggalInvoice,
      'customer_billing': instance.customerBiling,
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
      'qty_container': instance.qtyContainer,
      'type_pengiriman': instance.typePengiriman,
      'no_pl': instance.noPl,
      'customer_job': instance.customerJob,
      'no_job': instance.noJob,
      'va_bca': instance.vaBCA,
      'va_bca_name': instance.vaBCAName,
      'va_mandiri': instance.vaMandiri,
      'va_mandiri_name': instance.vaMandiriName,
      'harga_kontrak': instance.hargaKontrak,
      'biaya_karantina': instance.biayaKarantina,
      'biaya_dokumen': instance.biayaDokumen,
      'biaya_asuransi': instance.biayaAsuransi,
      'email': instance.email,
      'rute': instance.rute,
      'volume': instance.volume,
      'ppn': instance.ppn,
    };
