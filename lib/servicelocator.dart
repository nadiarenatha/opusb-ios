// import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:niaga_apps_mobile/services/auth_service.dart';
import 'package:niaga_apps_mobile/services/auth_service_impl.dart';
import 'package:niaga_apps_mobile/services/data_login_service.dart';
import 'package:niaga_apps_mobile/services/data_login_service_impl.dart';
import 'package:niaga_apps_mobile/services/id_account_service.dart';
import 'package:niaga_apps_mobile/services/id_account_service_impl.dart';
import 'package:niaga_apps_mobile/services/invoice_detail_service.dart';
import 'package:niaga_apps_mobile/services/invoice_detail_service_impl.dart';
import 'package:niaga_apps_mobile/services/invoice_service.dart';
import 'package:niaga_apps_mobile/services/invoice_service_impl.dart';
import 'package:niaga_apps_mobile/services/jadwal_kapal_service.dart';
import 'package:niaga_apps_mobile/services/jadwal_kapal_service_impl.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/add_address_service.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/add_address_service_impl.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/address_service.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/address_service_impl.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/alamat_bongkar_service.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/alamat_bongkar_service_impl.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/alamat_muat_lcl_service.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/alamat_muat_lcl_service_impl.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/alamat_muat_service.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/alamat_muat_service_impl.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/auth_service_niaga_impl.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/barang_dashboard_service.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/barang_dashboard_service_impl.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/check-account/check_email_service.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/check-account/check_email_service_impl.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/contract/cek_contract_fcl_service.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/contract/cek_contract_fcl_service_impl.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/contract/cek_harga_fcl_service.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/contract/cek_harga_fcl_service_impl.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/contract/cek_harga_lcl_service.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/contract/cek_harga_lcl_service_impl.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/contract/container_size_service.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/contract/container_size_service_impl.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/contract/contract_lcl_service.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/contract/contract_lcl_service_impl.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/contract/contract_service.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/contract/contract_service_impl.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/contract/poin_service.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/contract/poin_service_impl.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/contract/uom_service.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/contract/uom_service_impl.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/create-user/syarat_ketentuan_service.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/create-user/syarat_ketentuan_service_impl.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/daftar-pesanan/daftar_pesanan_service.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/daftar-pesanan/daftar_pesanan_service_impl.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/daftar-pesanan/detail_header_pesanan_service.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/daftar-pesanan/detail_header_pesanan_service_impl.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/daftar-pesanan/detail_line_pesanan_service.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/daftar-pesanan/detail_line_pesanan_service_impl.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/daftar-pesanan/hasil_ulasan_service.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/daftar-pesanan/hasil_ulasan_service_impl.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/daftar-pesanan/pesanan_cancel_service.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/daftar-pesanan/pesanan_cancel_service_impl.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/daftar-pesanan/pesanan_completed_service.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/daftar-pesanan/pesanan_completed_service_impl.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/daftar-pesanan/search_cancel_service.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/daftar-pesanan/search_cancel_service_impl.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/daftar-pesanan/search_completed_service.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/daftar-pesanan/search_completed_service_impl.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/daftar-pesanan/search_progress_service_impl.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/daftar-pesanan/search_progresss_service.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/daftar-pesanan/ulasan_service.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/daftar-pesanan/ulasan_service_impl.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/espay_service.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/espay_service_impl.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/fee_espay_service.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/fee_espay_service_impl.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/hubungi_kami_service.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/hubungi_kami_service_impl.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/image_slider_service.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/image_slider_service_impl.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/invoice/bank_code_service.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/invoice/bank_code_service_impl.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/invoice/bayar_sekarang_service.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/invoice/bayar_sekarang_service_impl.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/invoice/delete_invoice_service.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/invoice/delete_invoice_service_impl.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/invoice/detail_invoice_fcl_service.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/invoice/detail_invoice_fcl_service_impl.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/invoice/detail_invoice_group_service.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/invoice/detail_invoice_group_service_impl.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/invoice/detail_invoice_lcl_service.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/invoice/detail_invoice_lcl_service_impl.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/invoice/invoice_close_service.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/invoice/invoice_close_service_impl.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/invoice/invoice_group_service.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/invoice/invoice_group_service_impl.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/invoice/invoice_onprocess_service.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/invoice/invoice_onprocess_service_impl.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/invoice/invoice_open_service.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/invoice/invoice_open_service_impl.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/auth_niaga_service_niaga.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/invoice/invoice_single_service.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/invoice/invoice_single_service_impl.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/invoice/merchant_code_service.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/invoice/merchant_code_service_impl.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/invoice/report_invoice_service.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/invoice/report_invoice_service_impl.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/invoice/search_invoice_service.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/invoice/search_invoice_service_impl.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/invoice_summary_service.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/invoice_summary_service_impl.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/jadwal-kapal/image_jadwal_kapal_service.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/jadwal-kapal/image_jadwal_kapal_service_impl.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/jadwal-kapal/jadwal_kapal_service.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/jadwal-kapal/jadwal_kapal_service_impl.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/kantor_cabang_service.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/kantor_cabang_service_impl.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/kebijakan-privasi/kebijakan_service.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/kebijakan-privasi/kebijakan_service_impl.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/log_niaga_service.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/log_niaga_service_impl.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/log_out_service.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/log_out_service_impl.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/order-online/create_order_fcl_service.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/order-online/create_order_fcl_service_impl.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/order-online/create_order_lcl_service.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/order-online/create_order_lcl_service_impl.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/order-online/master_lokasi_bongkar_service.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/order-online/master_lokasi_bongkar_service_impl.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/order-online/master_lokasi_service.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/order-online/master_lokasi_service_impl.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/order-online/port_asal_fcl_service.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/order-online/port_asal_fcl_service_impl.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/order-online/port_asal_lcl_service.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/order-online/port_asal_lcl_service_impl.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/order-online/port_tujuan_fcl_service.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/order-online/port_tujuan_fcl_service_impl.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/order-online/push_order_service.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/order-online/push_order_service_impl.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/otp/update_flag_wa_service.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/otp/update_flag_wa_service_impl.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/otp/wa_push_otp_service.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/otp/wa_push_otp_service_impl.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/otp/wa_verifikasi_service.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/otp/wa_verifikasi_service_impl.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/packing/packing_niaga_service.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/packing/packing_niaga_service_impl.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/packing/packing_uncomplete_service.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/packing/packing_uncomplete_service_impl.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/packing/report_packing_service.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/packing/report_packing_service_impl.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/packing/search_packing_service.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/packing/search_packing_service_impl.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/packing/search_packing_uncomplete_service.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/packing/search_packing_uncomplete_service_impl.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/password/change_password_service.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/password/change_password_service_impl.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/password/forgot_password_service.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/password/forgot_password_service_impl.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/pencarian%20barang/detail_pencarian_barang_service.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/pencarian%20barang/detail_pencarian_barang_service_impl.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/pencarian%20barang/pencarian_barang_service.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/pencarian%20barang/pencarian_barang_service_impl.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/pencarian%20barang/search_pencarian_barang_service.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/pencarian%20barang/search_pencarian_barang_service_impl.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/popular_destination_service.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/popular_destination_service_impl.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/refresh_token_service.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/refresh_token_service_impl.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/riwayat_pembayaran_service.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/riwayat_pembayaran_service_impl.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/simulasi-pengiriman/port_asal_simulasi_service.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/simulasi-pengiriman/port_asal_simulasi_service_impl.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/simulasi-pengiriman/port_tujuan_simulasi_service.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/simulasi-pengiriman/port_tujuan_simulasi_service_impl.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/simulasi_harga_service.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/simulasi_harga_service_impl.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/syarat-ketentuan/syarat_ketentuan_service.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/syarat-ketentuan/syarat_ketentuan_service_impl.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/tentang-niaga/tentang_niaga_service.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/tentang-niaga/tentang_niaga_service_impl.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/tipe_alamat_service.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/tipe_alamat_service_impl.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/tracking/tracking_astra_service.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/tracking/tracking_astra_service_impl.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/tracking/tracking_dtd_cosl_service.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/tracking/tracking_dtd_cosl_service_impl.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/tracking/tracking_dtp_cosl_service.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/tracking/tracking_dtp_cosl_service_impl.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/tracking/tracking_pencarian_service.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/tracking/tracking_pencarian_service_impl.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/tracking/tracking_ptd_cosd_service.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/tracking/tracking_ptd_cosd_service_impl.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/tracking/tracking_ptd_cosl_service.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/tracking/tracking_ptd_cosl_service_impl.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/tracking/tracking_ptp_cosl_service.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/tracking/tracking_ptp_cosl_service_impl.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/tracking/tracking_service.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/tracking/tracking_service_impl.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/uoc-list-search/uoc_create_account_service.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/uoc-list-search/uoc_create_account_service_impl.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/uoc-list-search/uoc_list_search_service.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/uoc-list-search/uoc_list_search_service_impl.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/warehouse/detail_warehouse_service.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/warehouse/detail_warehouse_service_impl.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/warehouse/report_warehouse_service.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/warehouse/report_warehouse_service_impl.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/warehouse/search_warehouse_service.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/warehouse/search_warehouse_service_impl.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/warehouse/warehouse_service.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/warehouse/warehouse_service_impl.dart';
import 'package:niaga_apps_mobile/services/packing_service.dart';
import 'package:niaga_apps_mobile/services/packing_service_impl.dart';
import 'package:niaga_apps_mobile/services/register_service.dart';
import 'package:niaga_apps_mobile/services/register_service_impl.dart';
import 'package:niaga_apps_mobile/services/tracking_detail_service.dart';
import 'package:niaga_apps_mobile/services/tracking_detail_service_impl.dart';
import 'package:niaga_apps_mobile/services/wa_service.dart';
import 'package:niaga_apps_mobile/services/wa_service_impl.dart';
import 'package:niaga_apps_mobile/shared/constants.dart';
import 'package:niaga_apps_mobile/shared/exception/error.dart';
import 'package:niaga_apps_mobile/shared/exception/server_exception.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;
final sl2 = GetIt.asNewInstance();
final sl3 = GetIt.asNewInstance();
final sl4 = GetIt.asNewInstance();
final sl5 = GetIt.asNewInstance();
final sl6 = GetIt.asNewInstance();
final sl7 = GetIt.asNewInstance();

// void setupServiceLocator() {
//   sl.registerLazySingleton(() => Dio());
//   sl.registerLazySingleton(() => FlutterSecureStorage());

//   sl.registerLazySingleton<UOCCreateAccountService>(
//     () => UOCCreateAccountServiceImpl(
//       dio: sl<Dio>(),
//       storage: sl<FlutterSecureStorage>(),
//     ),
//   );
// }

Future<void> init() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(
    () => sharedPreferences,
  );

  sl.registerLazySingleton(
    () => const FlutterSecureStorage(),
  );

  // sl.registerLazySingleton<SetupService>(
  //   () => SetupServiceImpl(
  //     dio: sl(),
  //     preferences: sl(),
  //   ),
  // );

  sl.registerLazySingleton<AuthService>(
    () => AuthServiceImpl(
      dio: sl(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<PackingService>(
    () => PackingServiceImpl(
      dio: sl(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<JadwalKapalService>(
    () => JadwalKapalServiceImpl(
      dio: sl(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<ReportInvoiceService>(
    () => ReportInvoiceServiceImpl(
      dio: sl(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<WAService>(
    () => WAServiceImpl(
      dio: sl2(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<InvoiceService>(
    () => InvoiceServiceImpl(
      dio: sl(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<InvoiceDetailService>(
    () => InvoiceDetailServiceImpl(
      dio: sl(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<TrackingDetailService>(
    () => TrackingDetailServiceImpl(
      dio: sl(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<ReportPackingService>(
    () => ReportPackingServiceImpl(
      dio: sl(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<RegisterService>(
    () => RegisterServiceImpl(
      dio: sl5(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<SyaratCreateUserService>(
    () => SyaratCreateUserServiceImpl(
      dio: sl5(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<AuthNiagaService>(
    () => AuthServiceNiagaImpl(
      dio: sl(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<InvoiceOpenService>(
    () => InvoiceOpenServiceImpl(
      dio: sl6(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<TrackingNiagaService>(
    () => TrackingNiagaServiceImpl(
      dio: sl6(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<PackingNiagaCompleteService>(
    () => PackingNiagaCompleteServiceImpl(
      dio: sl6(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<PackingNiagaUnCompleteService>(
    () => PackingNiagaUnCompleteServiceImpl(
      dio: sl6(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<WarehouseService>(
    () => WarehouseNiagaServiceImpl(
      dio: sl6(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<ReportWarehouseService>(
    () => ReportWarehouseServiceImpl(
      dio: sl(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<PortAsalFCLService>(
    () => PortAsalFCLServiceImpl(
      dio: sl6(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<PortTujuanFCLService>(
    () => PortTujuanFCLServiceImpl(
      dio: sl6(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<InvoiceCloseService>(
    () => InvoiceCloseServiceImpl(
      dio: sl6(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<DetailWarehouseService>(
    () => DetailWarehouseNiagaServiceImpl(
      dio: sl6(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<KantorCabangService>(
    () => KantorCabangServiceImpl(
      dio: sl6(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<HubungiKamiService>(
    () => HubungiKamiServiceImpl(
      dio: sl6(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<PopularDestinationService>(
    () => PopularDestinationServiceImpl(
      dio: sl6(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<TrackingNiagaDTDCOSLService>(
    () => TrackingNiagaDTDCOSLServiceImpl(
      dio: sl6(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<TrackingNiagaDTPCOSLService>(
    () => TrackingNiagaDTPCOSLServiceImpl(
      dio: sl6(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<TrackingNiagaPTDCOSDService>(
    () => TrackingNiagaPTDCOSDServiceImpl(
      dio: sl6(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<TrackingNiagaPTDCOSLService>(
    () => TrackingNiagaPTDCOSLServiceImpl(
      dio: sl6(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<TrackingNiagaPTPCOSLService>(
    () => TrackingNiagaPTPCOSLServiceImpl(
      dio: sl6(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<DataLoginService>(
    () => DataLoginServiceImpl(
      dio: sl(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<IdAccountService>(
    () => IdAccountServiceImpl(
      dio: sl(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<DetailInvoiceLCLService>(
    () => DetailInvoiceLCLServiceImpl(
      dio: sl6(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<DetailInvoiceFCLService>(
    () => DetailInvoiceFCLServiceImpl(
      dio: sl6(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<PencarianBarangService>(
    () => PencarianBarangServiceImpl(
      dio: sl6(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<BarangDashboardService>(
    () => BarangDashboardServiceImpl(
      dio: sl6(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<DetailPencarianBarangService>(
    () => DetailPencarianBarangServiceImpl(
      dio: sl6(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<SimulasiHargaService>(
    () => SimulasiHargaServiceImpl(
      dio: sl6(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<WAPushOTPService>(
    () => WAPushOTPServiceImpl(
      dio: sl6(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<WAVerifikasiService>(
    () => WAVerifikasiServiceImpl(
      dio: sl6(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<JadwalKapalNiagaService>(
    () => JadwalKapalNiagaServiceImpl(
      dio: sl6(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<InvoiceSummaryService>(
    () => InvoiceSummaryServiceImpl(
      dio: sl6(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<SearchWarehouseService>(
    () => SearchWarehouseNiagaServiceImpl(
      dio: sl6(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<SearchPencarianBarangService>(
    () => SearchPencarianBarangServiceImpl(
      dio: sl6(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<TrackingPencarianService>(
    () => TrackingPencarianServiceImpl(
      dio: sl6(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<SearchPackingService>(
    () => SearchPackingServiceImpl(
      dio: sl6(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<SearchUncompletedPackingService>(
    () => SearchUncompletedPackingServiceImpl(
      dio: sl6(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<TrackingNiagaAstraMotorService>(
    () => TrackingNiagaAstraMotorServiceImpl(
      dio: sl6(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<UOCListSearchService>(
    () => UOCListSearchServiceImpl(
      dio: sl6(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<UpdateFlagWAService>(
    () => UpdateFlagWAServiceImpl(
      dio: sl(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<EspayPaymentService>(
    () => EspayPaymentServiceImpl(
      dio: sl(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<ChangePasswordService>(
    () => ChangePasswordImpl(
      dio: sl(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<ForgotPasswordService>(
    () => ForgotPasswordServiceImpl(
      dio: sl(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<ImageJadwalKapalService>(
    () => ImageJadwalKapalServiceImpl(
      dio: sl(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<AlamatBongkarService>(
    () => AlamatBongkarServiceImpl(
      dio: sl(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<AlamatMuatService>(
    () => AlamatMuatServiceImpl(
      dio: sl(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<ContainerSizeService>(
    () => ContainerSizeServiceImpl(
      dio: sl6(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<ContractService>(
    () => ContractServiceImpl(
      dio: sl6(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<ContractFCLService>(
    () => ContractFCLServiceImpl(
      dio: sl6(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<ContractLCLService>(
    () => ContractLCLServiceImpl(
      dio: sl6(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<CekHargaFCLService>(
    () => CekHargaFCLServiceImpl(
      dio: sl6(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<CekHargaLCLService>(
    () => CekHargaLCLServiceImpl(
      dio: sl6(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<UOMService>(
    () => UOMServiceImpl(
      dio: sl6(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<AlamatMuatLCLService>(
    () => AlamatMuatLCLServiceImpl(
      dio: sl6(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<PortAsalHargaService>(
    () => PortAsalHargaServiceImpl(
      dio: sl6(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<PortTujuanHargaService>(
    () => PortTujuanHargaServiceImpl(
      dio: sl6(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<RefreshTokenNiagaService>(
    () => RefreshTokenServiceNiagaImpl(
      dio: sl(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<ImageSliderService>(
    () => ImageSliderServiceImpl(
      dio: sl(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<CreateOrderFCLService>(
    () => CreateOrderFCLServiceImpl(
      dio: sl(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<CreateOrderLCLService>(
    () => CreateOrderLCLServiceImpl(
      dio: sl(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<AddressService>(
    () => AddressServiceImpl(
      dio: sl(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<RiwayatPembayaranService>(
    () => RiwayatPembayaranServiceImpl(
      dio: sl(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<AddAddressService>(
    () => AddAddressServiceImpl(
      dio: sl(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<InvoiceGroupService>(
    () => InvoiceGroupServiceImpl(
      dio: sl6(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<SingleInvoiceService>(
    () => SingleInvoiceServiceImpl(
      dio: sl6(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<DeleteInvoiceService>(
    () => DeleteInvoiceServiceImpl(
      dio: sl6(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<BankCodeService>(
    () => BankCodeServiceImpl(
      dio: sl(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<BayarSekarangService>(
    () => BayarSekarangServiceImpl(
      dio: sl6(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<DaftarPesananService>(
    () => DaftarPesananServiceImpl(
      dio: sl(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<PesananCompletedService>(
    () => PesananCompletedServiceImpl(
      dio: sl(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<PesananCancelService>(
    () => PesananCancelServiceImpl(
      dio: sl(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<SearchProgressService>(
    () => SearchProgressServiceImpl(
      dio: sl(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<SearchCompletedService>(
    () => SearchCompletedServiceImpl(
      dio: sl(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<SearchCancelService>(
    () => SearchCancelServiceImpl(
      dio: sl(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<SearchInvoiceService>(
    () => SearchInvoiceServiceImpl(
      dio: sl6(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<UOCCreateAccountService>(
    () => UOCCreateAccountServiceImpl(
      dio: sl6(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<PoinService>(
    () => PoinServiceImpl(
      dio: sl6(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<PushOrderService>(
    () => PushOrderServiceImpl(
      dio: sl6(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<InvoiceOnProcessService>(
    () => InvoiceOnProcessServiceImpl(
      dio: sl6(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<LogNiagaService>(
    () => LogNiagaServiceImpl(
      dio: sl(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<LogNiagaService2>(
    () => LogNiagaServiceImpl2(
      dio: sl(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<LogNiagaService3>(
    () => LogNiagaServiceImpl3(
      dio: sl(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<LogNiagaService4>(
    () => LogNiagaServiceImpl4(
      dio: sl(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<LogNiagaService5>(
    () => LogNiagaServiceImpl5(
      dio: sl(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<LogNiagaService6>(
    () => LogNiagaServiceImpl6(
      dio: sl(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<LogNiagaService7>(
    () => LogNiagaServiceImpl7(
      dio: sl(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<LogNiagaService8>(
    () => LogNiagaServiceImpl8(
      dio: sl(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<LogNiagaService9>(
    () => LogNiagaServiceImpl9(
      dio: sl(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<LogNiagaService10>(
    () => LogNiagaServiceImpl10(
      dio: sl(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<LogNiagaService11>(
    () => LogNiagaServiceImpl11(
      dio: sl(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<LogNiagaService12>(
    () => LogNiagaServiceImpl12(
      dio: sl(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<LogNiagaService13>(
    () => LogNiagaServiceImpl13(
      dio: sl(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<LogNiagaService14>(
    () => LogNiagaServiceImpl14(
      dio: sl(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<LogNiagaService15>(
    () => LogNiagaServiceImpl15(
      dio: sl(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<LogNiagaService16>(
    () => LogNiagaServiceImpl16(
      dio: sl(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<LogNiagaService17>(
    () => LogNiagaServiceImpl17(
      dio: sl(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<LogNiagaService18>(
    () => LogNiagaServiceImpl18(
      dio: sl(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<LogNiagaService19>(
    () => LogNiagaServiceImpl19(
      dio: sl(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<LogNiagaService20>(
    () => LogNiagaServiceImpl20(
      dio: sl(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<LogNiagaService21>(
    () => LogNiagaServiceImpl21(
      dio: sl(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<LogNiagaService22>(
    () => LogNiagaServiceImpl22(
      dio: sl(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<LogNiagaService23>(
    () => LogNiagaServiceImpl23(
      dio: sl(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<LogNiagaService24>(
    () => LogNiagaServiceImpl24(
      dio: sl(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<LogNiagaService25>(
    () => LogNiagaServiceImpl25(
      dio: sl(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<LogNiagaService26>(
    () => LogNiagaServiceImpl26(
      dio: sl(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<LogNiagaService27>(
    () => LogNiagaServiceImpl27(
      dio: sl(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<LogNiagaService28>(
    () => LogNiagaServiceImpl28(
      dio: sl(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<PortAsalLCLService>(
    () => PortAsalLCLServiceImpl(
      dio: sl(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<UlasanService>(
    () => UlasanServiceImpl(
      dio: sl(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<DetailPesananLineService>(
    () => DetailPesananLineServiceImpl(
      dio: sl(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<DetailPesananHeaderService>(
    () => DetailPesananHeaderServiceImpl(
      dio: sl(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<HasilUlasanService>(
    () => HasilUlasanServiceImpl(
      dio: sl(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<DetailInvoiceGroupService>(
    () => DetailInvoiceGroupServiceImpl(
      dio: sl6(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<TipeAlamatService>(
    () => TipeAlamatServiceImpl(
      dio: sl(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<FeeEspayService>(
    () => FeeEspayServiceImpl(
      dio: sl(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<LogOutService>(
    () => LogOutServiceImpl(
      dio: sl6(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<MasterLokasiMuatService>(
    () => MasterLokasiMuatServiceImpl(
      dio: sl6(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<MasterLokasiBongkarService>(
    () => MasterLokasiBongkarServiceImpl(
      dio: sl6(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<KebijakanPrivasiService>(
    () => KebijakanPrivasiServiceImpl(
      dio: sl(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<TentangNiagaService>(
    () => TentangNiagaServiceImpl(
      dio: sl(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<SyaratKetentuanService>(
    () => SyaratKetentuanServiceImpl(
      dio: sl(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<CheckEmailService>(
    () => CheckEmailServiceImpl(
      dio: sl(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<MerchantCodeService>(
    () => MerchantCodeServiceImpl(
      dio: sl(),
      storage: sl(),
    ),
  );
  // sl.registerLazySingleton<NotificationService>(
  //   () => NotificationServiceImpl(
  //     dio: sl(),
  //     storage: sl(),
  //   ),
  // );

  sl.registerLazySingleton(() {
    // final String host = sl<SharedPreferences>().getString(Keys.authHost) ?? '';
    final BaseOptions optionsOpusB = BaseOptions(
      // baseUrl: 'https://myactio-dev.opusb.co.id/api/',
      // baseUrl: 'https://dev.opusb.co.id/hcmdev/api/v1/',
      // baseUrl: 'http://192.168.9.63:4041/api/',
      //lama
      // baseUrl: 'https://elogistic-dev.opusb.co.id/api/',
      baseUrl: 'https://niagaapps.niaga-logistics.com/api/',
      // baseUrl: host
      // sl<Dio>().options.baseUrl,
      // baseUrl: 'https://$host/api/',
      // validateStatus: (statusCode) {
      //   if (statusCode == null) {
      //     return false;
      //   }
      //   if (statusCode == 422) {
      //     // your http status code
      //     return true;
      //   } else {
      //     return statusCode >= 200 && statusCode < 300;
      //   }
      // },
    );

    Dio dioOpusB = Dio(optionsOpusB);
    dioOpusB.interceptors
        .add(InterceptorsWrapper(onRequest: (request, handler) async {
      final method = request.method;
      final uri = request.uri;
      final path = uri.path;
      request.headers[HttpHeaders.contentTypeHeader] ??=
          Headers.jsonContentType;
      request.headers[HttpHeaders.acceptHeader] ??= Headers.jsonContentType;
      if (path.contains('/api/authenticate') && method == 'POST') {
        // no token required
      } else {
        final token = await sl<FlutterSecureStorage>().read(
          key: AuthKey.token.toString(),
          //* SET encryptedSharedPreferences to true for flutter V3
          aOptions: const AndroidOptions(
            encryptedSharedPreferences: true,
          ),
        );
        // setSharePref("token", token, "String");
        request.headers[HttpHeaders.authorizationHeader] = 'Bearer $token';
      }

      return handler.next(request);
    }, onError: (e, handler) {
      // final log = getLogger('DioError');
      getLogger('DioError');
      final response = e.response;
      //* FLUTTER3 CHANGE DioErrorType
      // if (e.type == DioErrorType.response) {
      // if (e.type == DioErrorType.badResponse) {
      if (e.type == DioExceptionType.unknown) {
        String message = e.message!;
        if (response!.data.toString().isNotEmpty) {
          // message = HttpStatusCode.fromJson(json.decode(response.data)).detail;
        }
        var statusCode = response.statusCode;
        if (statusCode == 403) {
          // throw HttpCodeException('Forbidden Access. $message');
        } else if (statusCode == 500) {
          // print(statusCode);
          // print(response.data['detail']);
          throw ErrorMsg(message);
          // throw ErrorMsg(e.response!.data['detail']);
        } else if (statusCode == 401) {
        } else if (statusCode == 400) {
          throw ErrorMsg(message);
        } else {
          // print('halo');
          throw ServerException(message);
        }
      } else {
        // print('halo disini');
        // throw ServerException(e.message!);
        throw ServerException(e.response!.data['detail']);
      }
    }, onResponse: (response, handler) async {
      // print('halo 2');
      return handler.next(response);
    }));

    (dioOpusB.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) {
        return true;
      };
      return null;
    };

    return dioOpusB;
  });

  sl2.registerLazySingleton(() {
    final BaseOptions optionsOpusB = BaseOptions(
      baseUrl: 'https://api.whatsapp.com/',
    );

    Dio dioOpusB = Dio(optionsOpusB);
    dioOpusB.interceptors
        .add(InterceptorsWrapper(onRequest: (request, handler) async {
      final method = request.method;
      final uri = request.uri;
      final path = uri.path;
      request.headers[HttpHeaders.contentTypeHeader] ??=
          Headers.jsonContentType;
      request.headers[HttpHeaders.acceptHeader] ??= Headers.jsonContentType;
      request.headers[HttpHeaders.authorizationHeader] =
          'Bearer 2724bcfef70c182e7b20eede438443e5f86eb601aa157d4886ca25868a628544267ea96d7fa5667d';

      return handler.next(request);
    }, onError: (e, handler) {
      // final log = getLogger('DioError');
      getLogger('DioError');
      final response = e.response;
      //* FLUTTER3 CHANGE DioErrorType
      // if (e.type == DioErrorType.response) {
      // if (e.type == DioErrorType.badResponse) {
      if (e.type == DioExceptionType.unknown) {
        String message = e.message!;
        if (response!.data.toString().isNotEmpty) {
          // message = HttpStatusCode.fromJson(json.decode(response.data)).detail;
        }
        var statusCode = response.statusCode;
        if (statusCode == 403) {
          // throw HttpCodeException('Forbidden Access. $message');
        } else if (statusCode == 500) {
          // print(statusCode);
          // print(response.data['detail']);
          throw ErrorMsg(message);
          // throw ErrorMsg(e.response!.data['detail']);
        } else if (statusCode == 401) {
        } else if (statusCode == 400) {
          throw ErrorMsg(message);
        } else {
          // print('halo');
          throw ServerException(message);
        }
      } else {
        // print('halo disini');
        // throw ServerException(e.message!);
        throw ServerException(e.response!.data['detail']);
      }
    }, onResponse: (response, handler) async {
      // print('halo 2');
      return handler.next(response);
    }));

    (dioOpusB.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) {
        return true;
      };
      return null;
    };

    return dioOpusB;
  });

  sl3.registerLazySingleton(() {
    final BaseOptions optionsOpusB = BaseOptions(
      baseUrl:
          'https://parseapi.back4app.com/classes/Indonesiacities_Indonesia_Cities_Database?limit=450&order=asciiname',
    );

    Dio dioOpusB = Dio(optionsOpusB);
    dioOpusB.interceptors
        .add(InterceptorsWrapper(onRequest: (request, handler) async {
      final method = request.method;
      final uri = request.uri;
      final path = uri.path;
      request.headers[HttpHeaders.contentTypeHeader] ??=
          Headers.jsonContentType;
      request.headers[HttpHeaders.acceptHeader] ??= Headers.jsonContentType;
      request.headers[HttpHeaders.authorizationHeader] =
          'Bearer 2724bcfef70c182e7b20eede438443e5f86eb601aa157d4886ca25868a628544267ea96d7fa5667d';

      return handler.next(request);
    }, onError: (e, handler) {
      // final log = getLogger('DioError');
      getLogger('DioError');
      final response = e.response;
      //* FLUTTER3 CHANGE DioErrorType
      // if (e.type == DioErrorType.response) {
      // if (e.type == DioErrorType.badResponse) {
      if (e.type == DioExceptionType.unknown) {
        String message = e.message!;
        if (response!.data.toString().isNotEmpty) {
          // message = HttpStatusCode.fromJson(json.decode(response.data)).detail;
        }
        var statusCode = response.statusCode;
        if (statusCode == 403) {
          // throw HttpCodeException('Forbidden Access. $message');
        } else if (statusCode == 500) {
          // print(statusCode);
          // print(response.data['detail']);
          throw ErrorMsg(message);
          // throw ErrorMsg(e.response!.data['detail']);
        } else if (statusCode == 401) {
        } else if (statusCode == 400) {
          throw ErrorMsg(message);
        } else {
          // print('halo');
          throw ServerException(message);
        }
      } else {
        // print('halo disini');
        // throw ServerException(e.message!);
        throw ServerException(e.response!.data['detail']);
      }
    }, onResponse: (response, handler) async {
      // print('halo 2');
      return handler.next(response);
    }));

    (dioOpusB.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) {
        return true;
      };
      return null;
    };

    return dioOpusB;
  });

  sl4.registerLazySingleton(() {
    final BaseOptions optionsOpusB = BaseOptions(
      baseUrl: 'https://app.sandbox.midtrans.com/snap/v1/transactions',
    );

    Dio dioOpusB = Dio(optionsOpusB);
    dioOpusB.interceptors
        .add(InterceptorsWrapper(onRequest: (request, handler) async {
      final method = request.method;
      final uri = request.uri;
      final path = uri.path;
      request.headers[HttpHeaders.contentTypeHeader] ??=
          Headers.jsonContentType;
      request.headers[HttpHeaders.acceptHeader] ??= Headers.jsonContentType;
      request.headers[HttpHeaders.authorizationHeader] =
          'Basic SB-Mid-server-zbiWPVrVAVdsDSmCh8fMBxpu';

      return handler.next(request);
    }, onError: (e, handler) {
      // final log = getLogger('DioError');
      getLogger('DioError');
      final response = e.response;
      //* FLUTTER3 CHANGE DioErrorType
      // if (e.type == DioErrorType.response) {
      // if (e.type == DioErrorType.badResponse) {
      if (e.type == DioExceptionType.unknown) {
        String message = e.message!;
        if (response!.data.toString().isNotEmpty) {
          // message = HttpStatusCode.fromJson(json.decode(response.data)).detail;
        }
        var statusCode = response.statusCode;
        if (statusCode == 403) {
          // throw HttpCodeException('Forbidden Access. $message');
        } else if (statusCode == 500) {
          // print(statusCode);
          // print(response.data['detail']);
          throw ErrorMsg(message);
          // throw ErrorMsg(e.response!.data['detail']);
        } else if (statusCode == 401) {
        } else if (statusCode == 400) {
          throw ErrorMsg(message);
        } else {
          // print('halo');
          throw ServerException(message);
        }
      } else {
        // print('halo disini');
        // throw ServerException(e.message!);
        throw ServerException(e.response!.data['detail']);
      }
    }, onResponse: (response, handler) async {
      // print('halo 2');
      return handler.next(response);
    }));

    (dioOpusB.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) {
        return true;
      };
      return null;
    };

    return dioOpusB;
  });

  //link REGISTER + CAPTCHA
  sl5.registerLazySingleton(() {
    // final String host = sl<SharedPreferences>().getString(Keys.authHost) ?? '';
    final BaseOptions optionsOpusB = BaseOptions(
      // baseUrl: 'https://elogistic-dev.opusb.co.id/',
      // baseUrl: 'https://dev-apps.niaga-logistics.com/api/',
      // baseUrl: 'https://elogistic-dev.opusb.co.id/api/',
      baseUrl: 'https://niagaapps.niaga-logistics.com/api/',
    );

    Dio dioOpusB = Dio(optionsOpusB);
    dioOpusB.interceptors
        .add(InterceptorsWrapper(onRequest: (request, handler) async {
      final method = request.method;
      final uri = request.uri;
      final path = uri.path;
      request.headers[HttpHeaders.contentTypeHeader] ??=
          Headers.jsonContentType;
      request.headers[HttpHeaders.acceptHeader] ??= Headers.jsonContentType;
      if (path.contains('register') && method == 'POST') {
        // no token required
      } else {
        final token = await sl<FlutterSecureStorage>().read(
          key: AuthKey.token.toString(),
          //* SET encryptedSharedPreferences to true for flutter V3
          aOptions: const AndroidOptions(
            encryptedSharedPreferences: true,
          ),
        );
        // setSharePref("token", token, "String");
        // request.headers[HttpHeaders.authorizationHeader] = 'Bearer $token';
        request.headers[HttpHeaders.authorizationHeader] = 'Bearer $token';
      }

      return handler.next(request);
    }, onError: (e, handler) {
      // final log = getLogger('DioError');
      getLogger('DioError');
      final response = e.response;
      //* FLUTTER3 CHANGE DioErrorType
      // if (e.type == DioErrorType.response) {
      // if (e.type == DioErrorType.badResponse) {
      if (e.type == DioExceptionType.unknown) {
        String message = e.message!;
        if (response!.data.toString().isNotEmpty) {
          // message = HttpStatusCode.fromJson(json.decode(response.data)).detail;
        }
        var statusCode = response.statusCode;
        if (statusCode == 403) {
          // throw HttpCodeException('Forbidden Access. $message');
        } else if (statusCode == 500) {
          // print(statusCode);
          // print(response.data['detail']);
          throw ErrorMsg(message);
          // throw ErrorMsg(e.response!.data['detail']);
        } else if (statusCode == 401) {
        } else if (statusCode == 400) {
          throw ErrorMsg(message);
        } else {
          // print('halo');
          throw ServerException(message);
        }
      } else {
        // print('halo disini');
        // throw ServerException(e.message!);
        throw ServerException(e.response!.data['detail']);
      }
    }, onResponse: (response, handler) async {
      // print('halo 2');
      return handler.next(response);
    }));

    (dioOpusB.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) {
        return true;
      };
      return null;
    };

    return dioOpusB;
  });

//LINK NIAGA
  sl6.registerLazySingleton(() {
    // final String host = sl<SharedPreferences>().getString(Keys.authHost) ?? '';
    final BaseOptions optionsOpusB = BaseOptions(
      baseUrl: 'https://api-app.niaga-logistics.com/',
    );

    Dio dioOpusB = Dio(optionsOpusB);
    dioOpusB.interceptors
        .add(InterceptorsWrapper(onRequest: (request, handler) async {
      final method = request.method;
      final uri = request.uri;
      final path = uri.path;
      request.headers[HttpHeaders.contentTypeHeader] ??=
          Headers.jsonContentType;
      request.headers[HttpHeaders.acceptHeader] ??= Headers.jsonContentType;
      if (path.contains('authenticateniaga') && method == 'POST') {
        // no token required
      } else {
        final token = await sl<FlutterSecureStorage>().read(
          key: AuthKey.accessToken.toString(),
          //* SET encryptedSharedPreferences to true for flutter V3
          aOptions: const AndroidOptions(
            encryptedSharedPreferences: true,
          ),
        );
        // setSharePref("token", token, "String");
        request.headers[HttpHeaders.authorizationHeader] = 'Bearer $token';
      }

      return handler.next(request);
    }, onError: (e, handler) {
      // final log = getLogger('DioError');
      getLogger('DioError');
      final response = e.response;
      //* FLUTTER3 CHANGE DioErrorType
      // if (e.type == DioErrorType.response) {
      // if (e.type == DioErrorType.badResponse) {
      if (e.type == DioExceptionType.unknown) {
        String message = e.message!;
        if (response!.data.toString().isNotEmpty) {
          // message = HttpStatusCode.fromJson(json.decode(response.data)).detail;
        }
        var statusCode = response.statusCode;
        if (statusCode == 403) {
          // throw HttpCodeException('Forbidden Access. $message');
        } else if (statusCode == 500) {
          // print(statusCode);
          // print(response.data['detail']);
          throw ErrorMsg(message);
          // throw ErrorMsg(e.response!.data['detail']);
        } else if (statusCode == 401) {
        } else if (statusCode == 400) {
          throw ErrorMsg(message);
        } else {
          // print('halo');
          throw ServerException(message);
        }
      } else {
        // print('halo disini');
        // throw ServerException(e.message!);
        throw ServerException(e.response!.data['detail']);
      }
    }, onResponse: (response, handler) async {
      // print('halo 2');
      return handler.next(response);
    }));

    (dioOpusB.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) {
        return true;
      };
      return null;
    };

    return dioOpusB;
  });

  //LINK NIAGA DGN OWNER CODE & EMAIL
  // sl6.registerLazySingleton(() {
  //   // final String host = sl<SharedPreferences>().getString(Keys.authHost) ?? '';
  //   final BaseOptions optionsOpusB = BaseOptions(
  //     baseUrl: 'https://api-app.niaga-logistics.com/',
  //   );

  //   Dio dioOpusB = Dio(optionsOpusB);
  //   dioOpusB.interceptors
  //       .add(InterceptorsWrapper(onRequest: (request, handler) async {
  //     final method = request.method;
  //     final uri = request.uri;
  //     final path = uri.path;
  //     request.headers[HttpHeaders.contentTypeHeader] ??=
  //         Headers.jsonContentType;
  //     request.headers[HttpHeaders.acceptHeader] ??= Headers.jsonContentType;

  //     // Retrieve ownerCode
  //     final ownerCode = await sl<FlutterSecureStorage>().read(
  //       key: AuthKey.ownerCode.toString(),
  //       aOptions: const AndroidOptions(
  //         encryptedSharedPreferences: true,
  //       ),
  //     );
  //     if (path.contains('authenticateniaga') && method == 'POST') {
  //       // no token required
  //     } else {
  //       final token = await sl<FlutterSecureStorage>().read(
  //         key: AuthKey.accessToken.toString(),
  //         //* SET encryptedSharedPreferences to true for flutter V3
  //         aOptions: const AndroidOptions(
  //           encryptedSharedPreferences: true,
  //         ),
  //       );
  //       // setSharePref("token", token, "String");
  //       request.headers[HttpHeaders.authorizationHeader] = 'Bearer $token';
  //     }

  //     return handler.next(request);
  //   }, onError: (e, handler) {
  //     // final log = getLogger('DioError');
  //     getLogger('DioError');
  //     final response = e.response;
  //     //* FLUTTER3 CHANGE DioErrorType
  //     // if (e.type == DioErrorType.response) {
  //     // if (e.type == DioErrorType.badResponse) {
  //     if (e.type == DioExceptionType.unknown) {
  //       String message = e.message!;
  //       if (response!.data.toString().isNotEmpty) {
  //         // message = HttpStatusCode.fromJson(json.decode(response.data)).detail;
  //       }
  //       var statusCode = response.statusCode;
  //       if (statusCode == 403) {
  //         // throw HttpCodeException('Forbidden Access. $message');
  //       } else if (statusCode == 500) {
  //         // print(statusCode);
  //         // print(response.data['detail']);
  //         throw ErrorMsg(message);
  //         // throw ErrorMsg(e.response!.data['detail']);
  //       } else if (statusCode == 401) {
  //       } else if (statusCode == 400) {
  //         throw ErrorMsg(message);
  //       } else {
  //         // print('halo');
  //         throw ServerException(message);
  //       }
  //     } else {
  //       // print('halo disini');
  //       // throw ServerException(e.message!);
  //       throw ServerException(e.response!.data['detail']);
  //     }
  //   }, onResponse: (response, handler) async {
  //     // print('halo 2');
  //     return handler.next(response);
  //   }));

  //   (dioOpusB.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate =
  //       (client) {
  //     client.badCertificateCallback =
  //         (X509Certificate cert, String host, int port) {
  //       return true;
  //     };
  //     return null;
  //   };

  //   return dioOpusB;
  // });

  //DIRECT WA LINK PHONE NUMBER
  sl7.registerLazySingleton(() {
    final BaseOptions optionsOpusB = BaseOptions(
      baseUrl: 'https://wa.me/',
    );

    Dio dioOpusB = Dio(optionsOpusB);
    dioOpusB.interceptors
        .add(InterceptorsWrapper(onRequest: (request, handler) async {
      final method = request.method;
      final uri = request.uri;
      final path = uri.path;
      request.headers[HttpHeaders.contentTypeHeader] ??=
          Headers.jsonContentType;
      request.headers[HttpHeaders.acceptHeader] ??= Headers.jsonContentType;
      // request.headers[HttpHeaders.authorizationHeader] =
      //     'Bearer 2724bcfef70c182e7b20eede438443e5f86eb601aa157d4886ca25868a628544267ea96d7fa5667d';

      return handler.next(request);
    }, onError: (e, handler) {
      // final log = getLogger('DioError');
      getLogger('DioError');
      final response = e.response;
      //* FLUTTER3 CHANGE DioErrorType
      // if (e.type == DioErrorType.response) {
      // if (e.type == DioErrorType.badResponse) {
      if (e.type == DioExceptionType.unknown) {
        String message = e.message!;
        if (response!.data.toString().isNotEmpty) {
          // message = HttpStatusCode.fromJson(json.decode(response.data)).detail;
        }
        var statusCode = response.statusCode;
        if (statusCode == 403) {
          // throw HttpCodeException('Forbidden Access. $message');
        } else if (statusCode == 500) {
          // print(statusCode);
          // print(response.data['detail']);
          throw ErrorMsg(message);
          // throw ErrorMsg(e.response!.data['detail']);
        } else if (statusCode == 401) {
        } else if (statusCode == 400) {
          throw ErrorMsg(message);
        } else {
          // print('halo');
          throw ServerException(message);
        }
      } else {
        // print('halo disini');
        // throw ServerException(e.message!);
        throw ServerException(e.response!.data['detail']);
      }
    }, onResponse: (response, handler) async {
      // print('halo 2');
      return handler.next(response);
    }));

    (dioOpusB.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) {
        return true;
      };
      return null;
    };

    return dioOpusB;
  });
}
