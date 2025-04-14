import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:niaga_apps_mobile/cubit/auth_cubit.dart';
import 'package:niaga_apps_mobile/cubit/invoice_cubit.dart';
import 'package:niaga_apps_mobile/cubit/invoice_detail_cubit.dart';
import 'package:niaga_apps_mobile/cubit/payment_cubit.dart';
import 'package:niaga_apps_mobile/cubit/register_cubit.dart';
import 'package:niaga_apps_mobile/cubit/wa_cubit.dart';
import 'package:niaga_apps_mobile/screen-niaga/home_niaga.dart';
import 'package:niaga_apps_mobile/servicelocator.dart';
import 'package:niaga_apps_mobile/shared/constants.dart';
import 'package:niaga_apps_mobile/shared/functions/flutter_secure_storage.dart';
import 'package:niaga_apps_mobile/shared/functions/simple_bloc_observer.dart';
import 'package:overlay_support/overlay_support.dart';
import 'cubit/check_email_cubit.dart';
import 'cubit/jadwal_kapal_cubit.dart';
import 'cubit/niaga/address_cubit.dart';
import 'cubit/niaga/alamat_cubit.dart';
import 'cubit/niaga/auth_niaga_cubit.dart';
import 'cubit/niaga/barang_dashboard_cubit.dart';
import 'cubit/niaga/contract_cubit.dart';
import 'cubit/niaga/create_order_cubit.dart';
import 'cubit/niaga/daftar_pesanan_cubit.dart';
import 'cubit/niaga/data_login_cubit.dart';
import 'cubit/niaga/espay_cubit.dart';
import 'cubit/niaga/hubungi_kami_cubit.dart';
import 'cubit/niaga/id_account_cubit.dart';
import 'cubit/niaga/image_slider_cubit.dart';
import 'cubit/niaga/invoice_group_cubit.dart';
import 'cubit/niaga/invoice_niaga_cubit.dart';
import 'cubit/niaga/jadwal_kapal_cubit.dart';
import 'cubit/niaga/kantor_cabang_cubit.dart';
import 'cubit/niaga/kebijakan_privasi_cubit.dart';
import 'cubit/niaga/log_out_cubit.dart';
import 'cubit/niaga/order_online_fcl_cubit.dart';
import 'cubit/niaga/packing_niaga_cubit.dart';
import 'cubit/niaga/password_cubit.dart';
import 'cubit/niaga/pencarian_barang_cubit.dart';
import 'cubit/niaga/popular_destination_cubit.dart';
import 'cubit/niaga/riwayat_pembayaran_cubit.dart';
import 'cubit/niaga/simulasi_harga_cubit.dart';
import 'cubit/niaga/syarat_create_user_cubit.dart';
import 'cubit/niaga/syarat_ketentuan_cubit.dart';
import 'cubit/niaga/tentang_niaga_cubit.dart';
import 'cubit/niaga/tracking_niaga_cubit.dart';
import 'cubit/niaga/uoc_list_search_cubit.dart';
import 'cubit/niaga/wa_push_otp_cubit.dart';
import 'cubit/niaga/wa_verifikasi_cubit.dart';
import 'cubit/niaga/warehouse_niaga_cubit.dart';
import 'cubit/packing_cubit.dart';
import 'cubit/tracking_detail_cubit.dart';
// import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:niaga_apps_mobile/cek-waktu/SessionTimeoutListener.dart';

import 'login/splash_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
NavigatorState get _navigator => navigatorKey.currentState!;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await FlutterDownloader.initialize(debug: true);

  // Initialize secure storage
  final storage = FlutterSecureStorage();

  final niagaToken = await storage.read(
    key: AuthKey.niagaToken.toString(),
    aOptions: const AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

  var tokenNya = await storage.read(
    key: AuthKey.token.toString(),
    aOptions: const AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

  final savedTokenTimeStr = await storage.read(
    key: AuthKey.tokenExpiryTime.toString(),
    aOptions: const AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

  bool isSessionValid = false;

  // DateTime? savedTokenTime;
  // if (savedTokenTimeStr != null) {
  //   savedTokenTime = DateTime.parse(savedTokenTimeStr);
  // }

  // Duration duration = Duration(minutes: 2);
  Duration duration = Duration(hours: 23);

  if (tokenNya != null && savedTokenTimeStr != null) {
    // final tokenAge = DateTime.now().difference(savedTokenTime);
    // if (tokenAge.inMinutes >= 2) {
    //   tokenNya = null;
    // } else {
    //   duration = Duration(minutes: 2) - tokenAge;
    // }
    DateTime? savedTokenTime = DateTime.tryParse(savedTokenTimeStr);
    if (savedTokenTime != null) {
      final tokenAge = DateTime.now().difference(savedTokenTime);
      // isSessionValid = tokenAge.inMinutes < 2; // Jika kurang dari 3 menit, tetap di Home
      isSessionValid =
          tokenAge.inHours < 23; // Jika kurang dari 3 menit, tetap di Home
    }
  }

  // Check if the token is older than 24 hours
  // final tokenTime = DateTime.now().subtract(Duration(minutes: 3));
  // Duration duration = Duration(minutes: 3);
  // if (tokenNya != null) {
  //   final tokenAge = DateTime.now().difference(tokenTime);
  //   if (tokenAge.inMinutes >= 3) {
  //     tokenNya = null;
  //   } else {
  //     duration = Duration(minutes: 3) - tokenAge;
  //   }
  // }

  BlocOverrides.runZoned(
    () {
      AuthCubit();
    },
    blocObserver: SimpleBlocObserver(),
  );

  await init().whenComplete(() {
    runApp(MyApp(
        niagaToken: niagaToken,
        duration: duration,
        isSessionValid: isSessionValid));
  });
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatelessWidget {
  final String? niagaToken;
  final Duration duration;

  const MyApp(
      {Key? key,
      this.niagaToken,
      required this.duration,
      required this.isSessionValid})
      : super(key: key);

  final bool isSessionValid;

  @override
  Widget build(BuildContext context) {
    return SessionTimeOutListener(
      context: context, // Pass the context here
      duration: duration,
      onTimeOut: () async {
        print("Time out apps berhasil");
        final storage = FlutterSecureStorage();
        // await storage.deleteAll();
        clearLocalStorage();
        await storage.delete(
          key: AuthKey.niagaToken.toString(),
          aOptions: const AndroidOptions(
            encryptedSharedPreferences: true,
          ),
        );
        if (navigatorKey.currentContext != null) {
          Navigator.of(navigatorKey.currentContext!).pushReplacement(
            MaterialPageRoute(builder: (context) => SplashScreen()),
          );
        }
      },
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthCubit(),
          ),
          BlocProvider(
            create: (context) => WACubit(),
          ),
          BlocProvider(
            create: (context) => PackingCubit(),
          ),
          BlocProvider(
            create: (context) => JadwalKapalCubit(),
          ),
          BlocProvider(
            create: (context) => InvoiceCubit(),
          ),
          BlocProvider(
            create: (context) => InvoiceDetailCubit(),
          ),
          BlocProvider(
            create: (context) => TrackingDetailCubit(),
          ),
          BlocProvider(
            create: (context) => PaymentCubit(),
          ),
          BlocProvider(
            create: (context) => RegisterCubit(),
          ),
          BlocProvider(
            create: (context) => AuthNiagaCubit(),
          ),
          BlocProvider(
            create: (context) => InvoiceNiagaCubit(),
          ),
          BlocProvider(
            create: (context) => TrackingNiagaCubit(),
          ),
          BlocProvider(
            create: (context) => PackingNiagaCubit(),
          ),
          BlocProvider(
            create: (context) => WarehouseNiagaCubit(),
          ),
          BlocProvider(
            create: (context) => OrderOnlineFCLCubit(),
          ),
          // BlocProvider(
          //   create: (context) => CariBarangCubit(),
          // ),
          BlocProvider(
            create: (context) => KantorCabangCubit(),
          ),
          BlocProvider(
            create: (context) => HubungiKamiCubit(),
          ),
          BlocProvider(
            create: (context) => PopularDestinationCubit(),
          ),
          BlocProvider(
            create: (context) => DataLoginCubit(),
          ),
          BlocProvider(
            create: (context) => IdAccountCubit(),
          ),
          BlocProvider(
            create: (context) => PencarianBarangCubit(),
          ),
          BlocProvider(
            create: (context) => BarangDashboardCubit(),
          ),
          BlocProvider(
            create: (context) => SimulasiHargaCubit(),
          ),
          BlocProvider(
            create: (context) => WAPushOTPCubit(),
          ),
          BlocProvider(
            create: (context) => WAVerifikasiCubit(),
          ),
          BlocProvider(
            create: (context) => EspayCubit(),
          ),
          BlocProvider(
            create: (context) => JadwalKapalNiagaCubit(),
          ),
          BlocProvider(
            create: (context) => PasswordCubit(),
          ),
          BlocProvider(
            create: (context) => UOCListSearchCubit(),
          ),
          BlocProvider(
            create: (context) => AlamatNiagaCubit(),
          ),
          BlocProvider(
            create: (context) => ContractNiagaCubit(),
          ),
          BlocProvider(
            create: (context) => ImageSliderCubit(),
          ),
          BlocProvider(
            create: (context) => CreateOrderCubit(),
          ),
          BlocProvider(
            create: (context) => AddressCubit(),
          ),
          BlocProvider(
            create: (context) => RiwayatPembayaranCubit(),
          ),
          BlocProvider(
            create: (context) => InvoiceGroupCubit(),
          ),
          BlocProvider(
            create: (context) => DaftarPesananCubit(),
          ),
          // BlocProvider(
          //   create: (context) => LogNiagaCubit(),
          // ),
          BlocProvider(
            create: (context) => LogOutCubit(),
          ),
          BlocProvider(
            create: (context) => KebijakanPrivasiCubit(),
          ),
          BlocProvider(
            create: (context) => TentangNiagaCubit(),
          ),
          BlocProvider(
            create: (context) => SyaratKetentuanCubit(),
          ),
          BlocProvider(
            create: (context) => SyaratCreateUserCubit(),
          ),
          BlocProvider(
            create: (context) => CheckEmailCubit(),
          ),
        ],
        child: OverlaySupport(
          child: MaterialApp(
            navigatorKey: navigatorKey,
            // home: niagaToken != null ? HomeNiagaPage() : SplashScreen(),
            // home: niagaToken != null && duration < Duration(hours: 24) ? HomeNiagaPage() : SplashScreen(),
            // home: niagaToken != null && duration < Duration(minutes: 3)
            //     ? HomeNiagaPage()
            //     : SplashScreen(),
            // home: (niagaToken != null && duration > Duration.zero)
            home: (niagaToken != null && isSessionValid)
                ? HomeNiagaPage()
                : SplashScreen(),
            builder: (context, child) {
              print('Niaga Token saat Login: $niagaToken');
              return child!;
            },
            debugShowCheckedModeBanner: false,
          ),
        ),
      ),
    );
  }
}
