import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:niaga_apps_mobile/screen/qr_scan.dart';
import '../cubit/niaga/data_login_cubit.dart';
import '../cubit/niaga/hubungi_kami_cubit.dart';
import '../cubit/niaga/image_slider_cubit.dart';
import '../cubit/niaga/kantor_cabang_cubit.dart';
import '../cubit/niaga/log_niaga_cubit.dart';
import '../cubit/niaga/popular_destination_cubit.dart';
import '../cubit/niaga/wa_push_otp_cubit.dart';
import '../cubit/niaga/wa_verifikasi_cubit.dart';
import '../jadwal-kapal/menu_jadwal_kapal_niaga.dart';
import '../model/data_login.dart';
import '../model/niaga/dashboard/hubungi_kami.dart';
import '../model/niaga/dashboard/kantor_cabang.dart';
import '../model/niaga/image_slider.dart';
import '../model/niaga/popular_destination.dart';
import '../order-online/notif_fcl.dart';
import '../order-online/notif_lcl.dart';
import '../order-online/rute_fcl.dart';
import '../order-online/rute_lcl.dart';
import '../packing/packing_tracking_niaga.dart';
import '../profile/pencarian_barang.dart';
import '../simulasi-pengiriman/simulasi_pengiriman_niaga.dart';
import '../stok-barang-gudang/stok_barang_niaga.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:carousel_slider/carousel_slider.dart';
// import 'package:showcaseview/showcaseview.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import '../shared/constants.dart';

import '../tracking/tracking_niaga.dart';
import '../tracking/tracking_pencarian.dart';
import 'home_niaga.dart';
// import 'package:barcode_scan/barcode_scan.dart;

class HomePageScreenNiaga extends StatefulWidget {
  final String? qrResult;
  //untuk navigate ke hlmn tracking
  final String resiNumber;
  const HomePageScreenNiaga({
    Key? key,
    this.qrResult,
    //untuk navigate ke hlmn tracking
    required this.resiNumber,
  }) : super(key: key);

  @override
  State<HomePageScreenNiaga> createState() => _HomePageScreenNiagaState();
}

class _HomePageScreenNiagaState extends State<HomePageScreenNiaga> {
  late TextEditingController _resiController;
  // Define keys to identify the showcase targets
  final GlobalKey _fclKey = GlobalKey();
  final GlobalKey _lclKey = GlobalKey();
  List<HubungiKamiAccesses> hubungiKamilist = [];
  List<KantorCabangAccesses> kantorCabangList = [];
  List<PopularDestinationAccesses> popularDestinations = [];
  List<ImageSliderAccesses> ImageList = [];
  DataLoginAccesses? dataLogin;
  final FlutterSecureStorage storage = FlutterSecureStorage();
  final List<TextEditingController> _otpControllers =
      List.generate(6, (_) => TextEditingController());

  @override
  void initState() {
    super.initState();
    _fetchAndLoginUser();
    // _logHubungiKami();
    // _logKantorCabang();
    // _logPopularDestination();
    _resiController =
        TextEditingController(text: widget.qrResult ?? widget.resiNumber);

    // Print the qrResult to the console
    print('QR Result in HomePage: ${widget.qrResult}');
    context.read<KantorCabangCubit>().kantorcabang();
    context.read<KantorCabangCubit>().logKantorCabang();
    context.read<HubungiKamiCubit>().hubungiKami();
    context.read<HubungiKamiCubit>().logHubungiKamiNiaga();
    context.read<PopularDestinationCubit>().popularDestination();
    context.read<PopularDestinationCubit>().logPopularDestinationNiaga();
    BlocProvider.of<ImageSliderCubit>(context).imageSlider(true);
  }

  Future<void> _fetchAndLoginUser() async {
    // Assuming you retrieve the userId from secure storage
    final userId = await storage.read(
      key: AuthKey.id.toString(),
      aOptions: const AndroidOptions(
        encryptedSharedPreferences: true,
      ),
    ); // Adjust this as needed
    print('User ID retrieved from storage: $userId');
    if (userId != null) {
      BlocProvider.of<DataLoginCubit>(context).dataLogin(id: int.parse(userId));
    }
  }

  // Future<void> _logHubungiKami() async {
  //   final fullUrl = await storage.read(
  //     key: AuthKey.fullUrl.toString(),
  //     aOptions: const AndroidOptions(
  //       encryptedSharedPreferences: true,
  //     ),
  //   );
  //   if (fullUrl != null) {
  //     print('Full Url nya Hubungi Kami: $fullUrl');
  //     BlocProvider.of<LogNiagaCubit>(context).logNiaga(fullUrl);
  //   } else {
  //     print('Full URL is null. Ensure it has been saved.');
  //   }
  // }

  // Future<void> _logKantorCabang() async {
  //   final fullUrlKantorCabang = await storage.read(
  //     key: AuthKey.fullUrlKantorCabang.toString(),
  //     aOptions: const AndroidOptions(
  //       encryptedSharedPreferences: true,
  //     ),
  //   );
  //   if (fullUrlKantorCabang != null) {
  //     print('Full Url nya Kantor Cabang: $fullUrlKantorCabang');
  //     BlocProvider.of<LogNiagaCubit>(context).logNiaga(fullUrlKantorCabang);
  //   } else {
  //     print('Full URL is null. Ensure it has been saved.');
  //   }
  // }

  // Future<void> _logPopularDestination() async {
  //   final fullUrlPopularDestination = await storage.read(
  //     key: AuthKey.fullUrlPopularDestination.toString(),
  //     aOptions: const AndroidOptions(
  //       encryptedSharedPreferences: true,
  //     ),
  //   );
  //   if (fullUrlPopularDestination != null) {
  //     print('Full Url nya popular destination: $fullUrlPopularDestination');
  //     BlocProvider.of<LogNiagaCubit>(context)
  //         .logNiaga(fullUrlPopularDestination);
  //   } else {
  //     print('Full URL popular destination is null. Ensure it has been saved.');
  //   }
  // }

  @override
  void dispose() {
    _resiController.dispose();
    super.dispose();
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  Future<void> _scanQRCode() async {
    // setState(() {
    //   _resiController.text = ''; // Clear the previous result
    // });
    _resiController.clear();

    final result = await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => QRViewExample()),
    );

    if (result != null) {
      setState(() {
        _resiController.text = result;

        // Print the new scanned result to the console
        print('New Scanned QR Code: $result');
      });
    }
  }

  //untuk fungsi tombol track
  // void _navigateToTrackingPage() {
  //   if (_resiController.text.isNotEmpty) {
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) =>
  //             // TrackingNiagaPage(resiNumber: _resiController.text),
  //             TrackingPencarianNiaga(noPL: _resiController.text),
  //       ),
  //     );
  //   } else {
  //     print('Resi number is empty!');
  //   }
  // }

  // void _navigateToTrackingPage() async {
  //   if (_resiController.text.isNotEmpty) {
  //     final result = await Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) =>
  //             TrackingPencarianNiaga(noPL: _resiController.text),
  //       ),
  //     );

  //     if (result == true) {
  //       setState(() {
  //         _resiController.clear(); // Reset the input field when returning
  //       });
  //     }
  //   } else {
  //     print('Resi number is empty!');
  //   }
  // }

  void _navigateToTrackingPage() async {
    if (_resiController.text.isNotEmpty) {
      final shouldReset = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              TrackingPencarianNiaga(noPL: _resiController.text),
        ),
      );

      // If user clicks back and returns `true`, clear the input field
      if (shouldReset == true) {
        setState(() {
          _resiController.clear();
        });
      }
    } else {
      print('Resi number is empty!');
    }
  }

  void openWhatsApp(String phoneNumber) async {
    final String url = 'https://wa.me/$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  // final List<String> imagePaths = [
  //   'assets/niaga-home.png',
  //   'assets/image home 2.png',
  //   'assets/image home 3.png',
  // ];

  Future verifikasiWA() => showDialog(
      context: context,
      builder: (BuildContext context) => Center(
            child: SingleChildScrollView(
              child: AlertDialog(
                  //untuk memberi border melengkung
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  //untuk mengatur letak dari close icon
                  titlePadding: EdgeInsets.zero,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 25, vertical: 3),
                  title: Row(
                    //supaya berada di kanan
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () {
                            Navigator.of(context).pop();
                          })
                    ],
                  ),
                  content: verifikasi()),
            ),
          ));

  verifikasi() {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Align content to start
        children: [
          Center(
            child: Text(
              "Verifikasi Nomor WhatsApp",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontFamily: 'Poppins Bold'),
            ),
          ),
          SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              color: Colors.white, // Background color
              border: Border.all(color: Colors.grey), // Grey border
              borderRadius: BorderRadius.circular(12), // Circular border
            ),
            padding: EdgeInsets.all(16),
            child: Text(
              'Lakukan verifikasi nomor anda untuk melakukan pemesanan. Kode OTP akan dikirimkan via WhatsApp ke nomor Anda yang telah terdaftar: ${dataLogin?.phone ?? 'nomor tidak tersedia'}',
              style: TextStyle(fontFamily: 'Poppins Med', fontSize: 12),
              textAlign: TextAlign.justify,
            ),
          ),
          SizedBox(height: 20),
          BlocBuilder<WAPushOTPCubit, WAPushOTPState>(
              builder: (context, state) {
            return Center(
              child: SizedBox(
                height: 40,
                width: 140,
                child: Material(
                  borderRadius: BorderRadius.circular(7.0),
                  color: Colors.red[900],
                  child: MaterialButton(
                    minWidth: 150, // Set a smaller minimum width
                    height: 40, // Set a fixed height for the button
                    padding: EdgeInsets.symmetric(
                        horizontal: 20.0), // Adjust padding
                    onPressed: () {
                      kodeOTP();
                      if (dataLogin != null &&
                          dataLogin!.phone != null &&
                          dataLogin!.email != null) {
                        BlocProvider.of<WAPushOTPCubit>(context)
                            .waPushOtp(dataLogin!.phone!, dataLogin!.email!);
                      }
                    },
                    child: Text(
                      "Kirim OTP",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          letterSpacing: 1.5,
                          fontSize: 12,
                          color: Colors.white,
                          fontFamily: 'Poppins Bold'),
                    ),
                  ),
                ),
              ),
            );
          }),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  Future kodeOTP() => showDialog(
        context: context,
        builder: (BuildContext context) {
          int remainingSeconds = 120; // Initialize countdown in dialog
          Timer? timer;

          void startCountdown(StateSetter setState) {
            timer?.cancel();
            timer = Timer.periodic(Duration(seconds: 1), (timer) {
              if (remainingSeconds > 0) {
                setState(() {
                  remainingSeconds--;
                });
              } else {
                timer.cancel();
              }
            });
          }

          return Center(
            child: SingleChildScrollView(
              child: AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                titlePadding: EdgeInsets.zero,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 25, vertical: 3),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [],
                ),
                content: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    // Start the countdown only once when the dialog is first built
                    if (remainingSeconds == 120) {
                      startCountdown(setState);
                    }

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 5),
                          Center(
                            child: Text(
                              "Masukkan Kode OTP",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontFamily: 'Poppins Bold',
                              ),
                            ),
                          ),
                          SizedBox(height: 30),
                          Text(
                            "Kode OTP telah dikirimkan via",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontFamily: 'Poppins Med',
                            ),
                          ),
                          Text(
                            "WhatsApp ke nomor ${dataLogin?.phone ?? 'nomor tidak tersedia'}.",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontFamily: 'Poppins Med',
                            ),
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: List.generate(6, (index) {
                              return Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                  border: Border.all(
                                      color: Colors.black, width: 1.0),
                                ),
                                child: TextFormField(
                                  controller: _otpControllers[index],
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(1),
                                  ],
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 15.0),
                                    fillColor: Colors.grey[600],
                                  ),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 14.0),
                                  onChanged: (value) {
                                    if (value.length == 1 && index < 5) {
                                      FocusScope.of(context).nextFocus();
                                    }
                                  },
                                ),
                              );
                            }),
                          ),
                          SizedBox(height: 20),
                          Center(
                            child: Text(
                              "Masukkan kode OTP dalam",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontFamily: 'Poppins Med',
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Center(
                            child: Text(
                              "${_formatTime(remainingSeconds)}",
                              style: TextStyle(
                                color: Colors.red[900],
                                fontSize: 12,
                                fontFamily: 'Poppins Bold',
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          if (remainingSeconds == 0) ...[
                            Text(
                              "Belum menerima Kode?",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontFamily: 'Poppins Med',
                              ),
                            ),
                            SizedBox(height: 5),
                            InkWell(
                              onTap: () {
                                if (dataLogin != null &&
                                    dataLogin!.phone != null &&
                                    dataLogin!.email != null) {
                                  BlocProvider.of<WAPushOTPCubit>(context)
                                      .waPushOtp(
                                          dataLogin!.phone!, dataLogin!.email!);
                                }
                                // Reset timer to 120 seconds and restart countdown
                                setState(() {
                                  remainingSeconds = 120; // Reset timer
                                  print(remainingSeconds);
                                });
                                startCountdown(setState);
                              },
                              child: Text(
                                "Kirim Ulang",
                                style: TextStyle(
                                  color: Colors.red[900],
                                  fontSize: 12,
                                  fontFamily: 'Poppins Bold',
                                ),
                              ),
                            ),
                          ],
                          SizedBox(height: 15),
                          Center(
                            child: SizedBox(
                                width: 130,
                                height: 35,
                                child: Material(
                                  borderRadius: BorderRadius.circular(7.0),
                                  color: Colors.red[900],
                                  child: BlocConsumer<WAVerifikasiCubit,
                                      WAVerifikasiState>(
                                    listener: (context, state) {
                                      if (state is WAVerifikasiFlagUpdated) {
                                        verifikasiBerhasil();
                                      } else if (state is WAVerifikasiFailure) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                'Verification failed, please try again'),
                                          ),
                                        );
                                      }
                                    },
                                    builder: (context, state) {
                                      if (state is WAVerifikasiInProgress) {
                                        return Center(
                                          child: CircularProgressIndicator(
                                            color: Colors.amber[600],
                                          ),
                                        );
                                      }
                                      return MaterialButton(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20.0),
                                        onPressed: () async {
                                          String otp = _otpControllers
                                              .map((controller) =>
                                                  controller.text)
                                              .join();
                                          await BlocProvider.of<
                                                  WAVerifikasiCubit>(context)
                                              .waVerifikasi(
                                            dataLogin?.phone ?? '',
                                            dataLogin?.email ?? '',
                                            otp,
                                          );
                                        },
                                        child: Text(
                                          "Verifikasi",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            letterSpacing: 1.5,
                                            fontSize: 12,
                                            color: Colors.white,
                                            fontFamily: 'Poppins Bold',
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                )),
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      );

  Future verifikasiBerhasil() => showDialog(
      context: context,
      builder: (BuildContext context) => Center(
            child: SingleChildScrollView(
              child: AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  titlePadding: EdgeInsets.zero,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 25, vertical: 3),
                  title: Row(
                    //supaya berada di kanan
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [],
                  ),
                  content: verifBerhasil()),
            ),
          ));

  verifBerhasil() {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 200, maxWidth: 300),
      child: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Column(
            children: [
              SizedBox(height: 10),
              SizedBox(
                height: 40.0, // Adjust the height as needed
                child: Image.asset('assets/notif register.png'),
              ),
              SizedBox(height: 20),
              Text(
                'Verifikasi Berhasil !',
                style: TextStyle(fontSize: 20, fontFamily: 'Poppins Bold'),
              ),
              SizedBox(height: 40),
              Material(
                borderRadius: BorderRadius.circular(7.0),
                color: Colors.red[900],
                child: MaterialButton(
                  minWidth: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) {
                      return HomeNiagaPage();
                    }));
                  },
                  child: Text(
                    "Ok",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        letterSpacing: 1.5,
                        fontSize: 12,
                        color: Colors.white,
                        fontFamily: 'Poppins Bold'),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return BlocConsumer<KantorCabangCubit, KantorCabangState>(
      listener: (context, state) {
        if (state is KantorCabangFailure) {
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to load Kantor Cabang')),
          );
        } else if (state is KantorCabangSuccess) {
          kantorCabangList.clear();
          kantorCabangList = state.response;
        }
      },
      builder: (context, state) {
        return BlocConsumer<HubungiKamiCubit, HubungiKamiState>(
            listener: (context, state) async {
          if (state is HubungiKamiSuccess) {
            hubungiKamilist.clear();
            hubungiKamilist = state.response;
          }
        }, builder: (context, state) {
          return BlocConsumer<PopularDestinationCubit, PopularDestinationState>(
              listener: (context, state) {
            if (state is PopularDestinationSuccess) {
              popularDestinations.clear();
              popularDestinations = state.response;

              if (popularDestinations.isEmpty) {
                popularDestinations.add(
                  PopularDestinationAccesses(
                    kota: 'Tujuan Favorit Belum Tersedia',
                    fcl: 0,
                    lcl: 0,
                  ),
                );
              }
            }
          }, builder: (context, state) {
            return BlocConsumer<ImageSliderCubit, ImageSliderState>(
                listener: (context, state) async {
              if (state is ImageSliderSuccess) {
                ImageList.clear();
                ImageList = state.response;
              }
            }, builder: (context, state) {
              return BlocConsumer<DataLoginCubit, DataLoginState>(
                  listener: (context, state) async {
                if (state is DataLoginSuccess) {
                  setState(() {
                    dataLogin = state.response;
                  });
                  print(
                      'Ini Data nya yang akan di ambil untuk WA : $dataLogin');
                }
              }, builder: (context, state) {
                bool isLoading = state is DataLoginInProgress;
                return Stack(
                    // child:
                    children: [
                      SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            CarouselSlider(
                              options: CarouselOptions(
                                aspectRatio: 16 / 8,
                                // Adjusts how many items are shown
                                viewportFraction: 1.0,
                                autoPlay: true, // Enable automatic sliding
                                autoPlayInterval: Duration(seconds: 3),
                                enlargeCenterPage:
                                    true, // Option to slightly enlarge the center image
                              ),
                              // items: imagePaths.map((imagePath) {
                              //   return Builder(
                              //     builder: (BuildContext context) {
                              //       return Image.asset(
                              //         imagePath,
                              //         fit: BoxFit
                              //             .contain, // Ensures the image covers the entire slider area
                              //         // width: MediaQuery.of(context).size.width,
                              //       );
                              //     },
                              //   );
                              // }).toList(),
                              items: ImageList.map((slider) {
                                return Builder(
                                  builder: (BuildContext context) {
                                    return Image.network(
                                      slider.attachmentUrl ?? '',
                                      fit: BoxFit.contain,
                                      errorBuilder: (context, error,
                                              stackTrace) =>
                                          Icon(Icons
                                              .broken_image), // Fallback if image fails
                                    );
                                  },
                                );
                              }).toList(),
                            ),
                            Container(
                              color: Color.fromARGB(255, 252, 230, 233),
                              height: 60,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    height: 35,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Center(
                                      child: TextFormField(
                                        controller: _resiController,
                                        decoration: InputDecoration(
                                          hintText:
                                              "Masukkan Nomor Packing List",
                                          hintStyle: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                            fontFamily: 'Poppins Med',
                                          ),
                                          fillColor: Colors.white,
                                          filled: true,
                                          contentPadding: EdgeInsets.symmetric(
                                            horizontal: 20,
                                            vertical: 6,
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide: BorderSide(
                                              color: Color.fromARGB(
                                                  255, 236, 236, 236),
                                              width: 2.0, // Border width
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide: BorderSide(
                                              color: Color.fromARGB(
                                                  255, 236, 236, 236),
                                              width: 2.0, // Border width
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide: BorderSide(
                                              color: Color.fromARGB(
                                                  255, 236, 236, 236),
                                              width: 2.0, // Border width
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 80,
                                    height: 35,
                                    child: Material(
                                      borderRadius: BorderRadius.circular(12.0),
                                      color: Colors.red[900],
                                      child: MaterialButton(
                                        padding: EdgeInsets.fromLTRB(
                                            20.0, 5.0, 20.0, 5.0),
                                        onPressed: () {
                                          _navigateToTrackingPage();
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                                  builder: (context) {
                                            return TrackingPencarianNiaga(
                                                noPL: _resiController.text);
                                          }));
                                        },
                                        child: Text(
                                          "Cari",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              letterSpacing: 1.5,
                                              fontSize: 12,
                                              color: Colors.white,
                                              fontFamily: 'Poppinss'),
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: _scanQRCode,
                                    child: SizedBox(
                                      height: 25.0,
                                      child: Image.asset('assets/scan-QR.png'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 2,
                              width: MediaQuery.of(context).size.width,
                              color: Color.fromARGB(255, 236, 236, 236),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 12, right: 12, bottom: 12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 10),
                                    Text(
                                      "Order Online",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'Poppinss',
                                        fontWeight: FontWeight.w700,
                                        color: Colors.red[900],
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Flexible(
                                          child: InkWell(
                                            // onTap: () {
                                            //   // Navigator.push(context,
                                            //   //     MaterialPageRoute(
                                            //   //         builder: (context) {
                                            //   //   return RuteFCL();
                                            //   // }));
                                            //   if (dataLogin?.waVerified ==
                                            //           null ||
                                            //       dataLogin?.waVerified !=
                                            //           true) {
                                            //     verifikasiWA();
                                            //   } else {
                                            //     Navigator.push(context,
                                            //         MaterialPageRoute(
                                            //             builder: (context) {
                                            //       return RuteFCL();
                                            //     }));
                                            //   }
                                            //   print(
                                            //       'Status WA FCL nya : ${dataLogin?.waVerified}');
                                            // },
                                            //NEW JIKA MASIH LOADING UNTUK GET waVerified MAKA TIDAK BISA MSK KE MENU FCL
                                            onTap: isLoading
                                                ? null
                                                : () {
                                                    if (dataLogin?.waVerified ==
                                                            null ||
                                                        dataLogin?.waVerified !=
                                                            true) {
                                                      verifikasiWA();
                                                    } else {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              RuteFCL(),
                                                        ),
                                                      );
                                                    }
                                                    print(
                                                        'Status WA FCL nya : ${dataLogin?.waVerified}');
                                                  },
                                            child: Container(
                                              width: 180,
                                              height: 80,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                gradient: LinearGradient(
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                  colors: [
                                                    Color.fromARGB(
                                                        255, 212, 25, 25),
                                                    Color.fromARGB(
                                                        255, 243, 208, 175)
                                                  ],
                                                ),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(12.0),
                                                child: SizedBox(
                                                  height: 60.0,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      Image.asset(
                                                        'assets/order fcl icon.png',
                                                        width:
                                                            40, // Set the width of the image as needed
                                                        height:
                                                            40, // Set the height of the image as needed
                                                      ),
                                                      Flexible(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(6.0),
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              Text(
                                                                'Pemesanan',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontFamily:
                                                                      'Poppinss',
                                                                  fontSize: 11,
                                                                ),
                                                              ),
                                                              Text(
                                                                'FCL',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontFamily:
                                                                      'Poppinss',
                                                                  fontSize: 11,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Flexible(
                                          child: InkWell(
                                            // onTap: () {
                                            //   // Navigator.push(context,
                                            //   //     MaterialPageRoute(
                                            //   //         builder: (context) {
                                            //   //   return RuteLCL();
                                            //   // }));
                                            //   if (dataLogin?.waVerified ==
                                            //           null ||
                                            //       dataLogin?.waVerified !=
                                            //           true) {
                                            //     verifikasiWA();
                                            //   } else {
                                            //     Navigator.push(context,
                                            //         MaterialPageRoute(
                                            //             builder: (context) {
                                            //       return RuteLCL();
                                            //     }));
                                            //   }
                                            //   print(
                                            //       'Status WA LCL nya : ${dataLogin?.waVerified}');
                                            // },
                                            //NEW
                                            onTap: isLoading
                                                ? null
                                                : () {
                                                    if (dataLogin?.waVerified ==
                                                            null ||
                                                        dataLogin?.waVerified !=
                                                            true) {
                                                      verifikasiWA();
                                                    } else {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              RuteLCL(),
                                                        ),
                                                      );
                                                    }
                                                    print(
                                                        'Status WA LCL nya : ${dataLogin?.waVerified}');
                                                  },
                                            child: Container(
                                              width: 180,
                                              height: 80,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                gradient: LinearGradient(
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                  colors: [
                                                    Color.fromARGB(
                                                        255, 212, 25, 25)!,
                                                    Color.fromARGB(
                                                        255, 243, 208, 175)
                                                  ],
                                                ),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(12.0),
                                                child: SizedBox(
                                                  height: 60.0,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      Image.asset(
                                                        'assets/order lcl icon.png',
                                                        width:
                                                            40, // Set the width of the image as needed
                                                        height:
                                                            40, // Set the height of the image as needed
                                                      ),
                                                      Flexible(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(6.0),
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              Text(
                                                                'Pemesanan',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontFamily:
                                                                      'Poppinss',
                                                                  fontSize: 11,
                                                                ),
                                                              ),
                                                              Text(
                                                                'LCL',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontFamily:
                                                                      'Poppinss',
                                                                  fontSize: 11,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 25),
                                    Text(
                                      "Fitur Lainnya",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'Poppinss',
                                        fontWeight: FontWeight.w700,
                                        color: Colors.red[900],
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        //jadwal kapal
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              // return JadwalKapalNiagaPage();
                                              return MenuJadwalKapalNiagaPage();
                                            }));
                                          },
                                          child: Column(
                                            children: [
                                              Container(
                                                height: 55,
                                                width: 55,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  gradient: LinearGradient(
                                                    begin: Alignment.topCenter,
                                                    end: Alignment.bottomCenter,
                                                    colors: [
                                                      Colors.blue[200]!,
                                                      Colors.white
                                                    ],
                                                  ),
                                                ),
                                                child: SizedBox(
                                                  height: 115.0,
                                                  child: Image.asset(
                                                      'assets/Jadwal-Kapal.png'),
                                                ),
                                              ),
                                              SizedBox(height: 8),
                                              Text(
                                                "Jadwal",
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  fontFamily: 'Poppinss',
                                                  color: Color(0xFF333333),
                                                ),
                                              ),
                                              SizedBox(height: 2),
                                              Text(
                                                "Kapal",
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  // fontWeight: FontWeight.bold,
                                                  fontFamily: 'Poppinss',
                                                  color: Color(0xFF333333),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        //simulasi pengiriman
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              // return SimulasiPengirimanPage();
                                              return SimulasiPengirimanNiagaPage();
                                            }));
                                          },
                                          child: Column(
                                            children: [
                                              Container(
                                                height: 55,
                                                width: 55,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  gradient: LinearGradient(
                                                    begin: Alignment.topCenter,
                                                    end: Alignment.bottomCenter,
                                                    colors: [
                                                      // Colors.yellow[200]!,
                                                      // Colors.white
                                                      Colors.blue[200]!,
                                                      Colors.white
                                                    ],
                                                  ),
                                                ),
                                                child: SizedBox(
                                                  height: 115.0,
                                                  child: Image.asset(
                                                      'assets/Simulasi-Pengiriman.png'),
                                                ),
                                              ),
                                              SizedBox(height: 8),
                                              Text(
                                                "Simulasi",
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  fontFamily: 'Poppinss',
                                                  // fontWeight: FontWeight.bold,
                                                  color: Color(0xFF333333),
                                                ),
                                              ),
                                              SizedBox(height: 2),
                                              Text(
                                                "Pengiriman",
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  // fontWeight: FontWeight.bold,
                                                  fontFamily: 'Poppinss',
                                                  color: Color(0xFF333333),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        //barang dalam gudang
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              // return StokBarangPage();
                                              return StokBarangNiagaPage();
                                            }));
                                          },
                                          child: Column(
                                            children: [
                                              Container(
                                                height: 55,
                                                width: 55,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  gradient: LinearGradient(
                                                    begin: Alignment.topCenter,
                                                    end: Alignment.bottomCenter,
                                                    colors: [
                                                      // Colors.red[100]!,
                                                      // Colors.white
                                                      Colors.blue[200]!,
                                                      Colors.white
                                                    ],
                                                  ),
                                                  // boxShadow: [
                                                  //   BoxShadow(
                                                  //     color: Colors.grey.withOpacity(
                                                  //         0.5), // Shadow color
                                                  //     spreadRadius:
                                                  //         2, // How much the shadow spreads
                                                  //     blurRadius:
                                                  //         5, // How blurry the shadow is
                                                  //     offset: Offset(0,
                                                  //         3), // Position of the shadow (x, y)
                                                  //   ),
                                                  // ],
                                                ),
                                                child: SizedBox(
                                                  height: 115.0,
                                                  child: Image.asset(
                                                      'assets/Stok-Barang.png'),
                                                ),
                                              ),
                                              SizedBox(height: 8),
                                              Text(
                                                "Barang Dalam",
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  // fontWeight: FontWeight.bold,
                                                  fontFamily: 'Poppinss',
                                                  color: Color(0xFF333333),
                                                ),
                                              ),
                                              SizedBox(height: 2),
                                              Text(
                                                "Gudang",
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  // fontWeight: FontWeight.bold,
                                                  fontFamily: 'Poppinss',
                                                  color: Color(0xFF333333),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        //packing list
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              // return PackingListPage();
                                              // return PackingListNiagaPage();
                                              //NEW
                                              // return PackingTrackingListNiagaPage();
                                              return PencarianBarangNiagaPage();
                                            }));
                                          },
                                          child: Column(
                                            children: [
                                              Container(
                                                height: 55,
                                                width: 55,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  gradient: LinearGradient(
                                                    begin: Alignment.topCenter,
                                                    end: Alignment.bottomCenter,
                                                    colors: [
                                                      Colors.blue[200]!,
                                                      Colors.white
                                                    ],
                                                  ),
                                                ),
                                                child: SizedBox(
                                                  height: 115.0,
                                                  child: Image.asset(
                                                    // 'assets/Packing-List.png'
                                                    'assets/pencarian profil.png',
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 8),
                                              Text(
                                                // "Packing",
                                                "Pencarian",
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  // fontWeight: FontWeight.bold,
                                                  fontFamily: 'Poppinss',
                                                  color: Color(0xFF333333),
                                                ),
                                              ),
                                              SizedBox(height: 2),
                                              Text(
                                                // "List",
                                                "Barang",
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  // fontWeight: FontWeight.bold,
                                                  fontFamily: 'Poppinss',
                                                  color: Color(0xFF333333),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 25),
                                    Text(
                                      "Tujuan Favorit",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'Poppinss',
                                        fontWeight: FontWeight.w700,
                                        color: Colors.red[900],
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    // SingleChildScrollView(
                                    //   scrollDirection: Axis.horizontal,
                                    //   child: Row(
                                    //     children: [
                                    //       //surabaya
                                    //       Container(
                                    //         padding: EdgeInsets.all(12.0),
                                    //         decoration: BoxDecoration(
                                    //           color: Colors
                                    //               .white, // Background color (optional)
                                    //           border: Border.all(
                                    //             color: Colors.grey, // Grey border color
                                    //             width: 2.0, // Border width
                                    //           ),
                                    //           borderRadius: BorderRadius.circular(
                                    //               10), // Rounded corners (optional)
                                    //           boxShadow: [
                                    //             BoxShadow(
                                    //               color: Colors.grey.withOpacity(
                                    //                   0.5), // Grey shadow color with opacity
                                    //               spreadRadius:
                                    //                   2, // How much the shadow spreads
                                    //               blurRadius:
                                    //                   5, // How blurry the shadow is
                                    //               offset: Offset(0,
                                    //                   3), // Position of the shadow (x, y)
                                    //             ),
                                    //           ],
                                    //         ),
                                    //         child: Column(
                                    //           crossAxisAlignment: CrossAxisAlignment.start,
                                    //           children: [
                                    //             Center(
                                    //               child: Text(
                                    //                 'Surabaya',
                                    //                 style: TextStyle(
                                    //                     fontWeight: FontWeight.w700,
                                    //                     fontSize: 16),
                                    //               ),
                                    //             ),
                                    //             SizedBox(height: 5),
                                    //             Text(
                                    //               'FCL: 8 Container',
                                    //               style: TextStyle(
                                    //                   fontSize: 16),
                                    //             ),
                                    //             Text(
                                    //               'LCL: 20 cbm',
                                    //               style: TextStyle(
                                    //                   fontSize: 16),
                                    //             ),
                                    //           ],
                                    //         ),
                                    //       ),
                                    //       SizedBox(width: 16),
                                    //       //jakarta
                                    //       Container(
                                    //         padding: EdgeInsets.all(12.0),
                                    //         decoration: BoxDecoration(
                                    //           color: Colors
                                    //               .white, // Background color (optional)
                                    //           border: Border.all(
                                    //             color: Colors.grey, // Grey border color
                                    //             width: 2.0, // Border width
                                    //           ),
                                    //           borderRadius: BorderRadius.circular(
                                    //               10), // Rounded corners (optional)
                                    //           boxShadow: [
                                    //             BoxShadow(
                                    //               color: Colors.grey.withOpacity(
                                    //                   0.5), // Grey shadow color with opacity
                                    //               spreadRadius:
                                    //                   2, // How much the shadow spreads
                                    //               blurRadius:
                                    //                   5, // How blurry the shadow is
                                    //               offset: Offset(0,
                                    //                   3), // Position of the shadow (x, y)
                                    //             ),
                                    //           ],
                                    //         ),
                                    //         child: Column(
                                    //           crossAxisAlignment: CrossAxisAlignment.start,
                                    //           children: [
                                    //             Text(
                                    //               'Jakarta',
                                    //               style: TextStyle(
                                    //                   fontWeight: FontWeight.w700,
                                    //                   fontSize: 16),
                                    //             ),
                                    //             SizedBox(height: 5),
                                    //             Text(
                                    //               'FCL: 8 Container',
                                    //               style: TextStyle(
                                    //                   fontSize: 16),
                                    //             ),
                                    //             Text(
                                    //               'LCL: 11 cbm',
                                    //               style: TextStyle(
                                    //                   fontSize: 16),
                                    //             ),
                                    //           ],
                                    //         ),
                                    //       ),
                                    //       SizedBox(width: 16),
                                    //       //makassar
                                    //       Container(
                                    //         padding: EdgeInsets.all(12.0),
                                    //         decoration: BoxDecoration(
                                    //           color: Colors
                                    //               .white, // Background color (optional)
                                    //           border: Border.all(
                                    //             color: Colors.grey, // Grey border color
                                    //             width: 2.0, // Border width
                                    //           ),
                                    //           borderRadius: BorderRadius.circular(
                                    //               10), // Rounded corners (optional)
                                    //           boxShadow: [
                                    //             BoxShadow(
                                    //               color: Colors.grey.withOpacity(
                                    //                   0.5), // Grey shadow color with opacity
                                    //               spreadRadius:
                                    //                   2, // How much the shadow spreads
                                    //               blurRadius:
                                    //                   5, // How blurry the shadow is
                                    //               offset: Offset(0,
                                    //                   3), // Position of the shadow (x, y)
                                    //             ),
                                    //           ],
                                    //         ),
                                    //         child: Column(
                                    //           crossAxisAlignment: CrossAxisAlignment.start,
                                    //           children: [
                                    //             Text(
                                    //               'Makassar',
                                    //               style: TextStyle(
                                    //                   fontWeight: FontWeight.w700,
                                    //                   fontSize: 16),
                                    //             ),
                                    //             SizedBox(height: 5),
                                    //             Text(
                                    //               'FCL: 8 Container',
                                    //               style: TextStyle(
                                    //                   fontSize: 16),
                                    //             ),
                                    //             Text(
                                    //               'LCL: 11 cbm',
                                    //               style: TextStyle(
                                    //                   fontSize: 16),
                                    //             ),
                                    //           ],
                                    //         ),
                                    //       ),
                                    //       SizedBox(width: 16),
                                    //       //sorong
                                    //       Container(
                                    //         padding: EdgeInsets.all(12.0),
                                    //         decoration: BoxDecoration(
                                    //           color: Colors
                                    //               .white, // Background color (optional)
                                    //           border: Border.all(
                                    //             color: Colors.grey, // Grey border color
                                    //             width: 2.0, // Border width
                                    //           ),
                                    //           borderRadius: BorderRadius.circular(
                                    //               10), // Rounded corners (optional)
                                    //           boxShadow: [
                                    //             BoxShadow(
                                    //               // Grey shadow color with opacity
                                    //               color: Colors.grey.withOpacity(0.5),
                                    //               spreadRadius:
                                    //                   2, // How much the shadow spreads
                                    //               blurRadius:
                                    //                   5, // How blurry the shadow is
                                    //               // Position of the shadow (x, y)
                                    //               offset: Offset(0, 3),
                                    //             ),
                                    //           ],
                                    //         ),
                                    //         child: Column(
                                    //           crossAxisAlignment: CrossAxisAlignment.start,
                                    //           children: [
                                    //             Text(
                                    //               'Sorong',
                                    //               style: TextStyle(
                                    //                   fontWeight: FontWeight.w700,
                                    //                   fontSize: 16),
                                    //             ),
                                    //             SizedBox(height: 5),
                                    //             Text(
                                    //               'FCL: 8 Container',
                                    //               style: TextStyle(
                                    //                   fontSize: 16),
                                    //             ),
                                    //             Text(
                                    //               'LCL: 11 cbm',
                                    //               style: TextStyle(
                                    //                   fontSize: 16),
                                    //             ),
                                    //           ],
                                    //         ),
                                    //       ),
                                    //       SizedBox(width: 16),
                                    //       //timika
                                    //       Container(
                                    //         padding: EdgeInsets.all(12.0),
                                    //         decoration: BoxDecoration(
                                    //           color: Colors
                                    //               .white, // Background color (optional)
                                    //           border: Border.all(
                                    //             color: Colors.grey, // Grey border color
                                    //             width: 2.0, // Border width
                                    //           ),
                                    //           borderRadius: BorderRadius.circular(
                                    //               10), // Rounded corners (optional)
                                    //           boxShadow: [
                                    //             BoxShadow(
                                    //               // Grey shadow color with opacity
                                    //               color: Colors.grey.withOpacity(0.5),
                                    //               spreadRadius:
                                    //                   2, // How much the shadow spreads
                                    //               blurRadius:
                                    //                   5, // How blurry the shadow is
                                    //               // Position of the shadow (x, y)
                                    //               offset: Offset(0, 3),
                                    //             ),
                                    //           ],
                                    //         ),
                                    //         child: Column(
                                    //           crossAxisAlignment: CrossAxisAlignment.start,
                                    //           children: [
                                    //             Text(
                                    //               'Timika',
                                    //               style: TextStyle(
                                    //                   fontWeight: FontWeight.w700,
                                    //                   fontSize: 16),
                                    //             ),
                                    //             SizedBox(height: 5),
                                    //             Text(
                                    //               'FCL: 8 Container',
                                    //               style: TextStyle(
                                    //                   fontSize: 16),
                                    //             ),
                                    //             Text(
                                    //               'LCL: 11 cbm',
                                    //               style: TextStyle(
                                    //                   fontSize: 16),
                                    //             ),
                                    //           ],
                                    //         ),
                                    //       ),
                                    //     ],
                                    //   ),
                                    // ),
                                    //Tujuan Favorit api lama
                                    // SingleChildScrollView(
                                    //   scrollDirection: Axis.horizontal,
                                    //   child: Row(
                                    //     children: popularDestinations.map((destination) {
                                    //       return Container(
                                    //         margin: EdgeInsets.only(
                                    //             right:
                                    //                 16), // Adjust the right margin here
                                    //         padding: EdgeInsets.all(12.0),
                                    //         decoration: BoxDecoration(
                                    //           color: Colors.white,
                                    //           border: Border.all(
                                    //             color: Colors.grey,
                                    //             width: 2.0,
                                    //           ),
                                    //           borderRadius: BorderRadius.circular(10),
                                    //           boxShadow: [
                                    //             BoxShadow(
                                    //               color: Colors.grey.withOpacity(0.5),
                                    //               spreadRadius: 2,
                                    //               blurRadius: 5,
                                    //               offset: Offset(0, 3),
                                    //             ),
                                    //           ],
                                    //         ),
                                    //         child: Text(
                                    //           destination.populer ?? 'Unknown',
                                    //           style: TextStyle(
                                    //             fontWeight: FontWeight.w700,
                                    //             fontSize: 16,
                                    //           ),
                                    //         ),
                                    //       );
                                    //     }).toList(),
                                    //   ),
                                    // ),
                                    //tujuan favorit baru
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: popularDestinations
                                            .map((destination) {
                                          return Container(
                                            // padding: EdgeInsets.all(12.0),
                                            padding: EdgeInsets.only(
                                                left: 12,
                                                right: 20,
                                                top: 6,
                                                bottom: 12),
                                            margin: EdgeInsets.only(
                                                right:
                                                    10), // Spacing between items
                                            decoration: BoxDecoration(
                                              color: Color.fromARGB(
                                                  255, 253, 242, 248),
                                              border: Border.all(
                                                  color: Color.fromARGB(
                                                      255, 236, 236, 236),
                                                  width: 2.0),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Column(
                                              children: [
                                                Text(
                                                  destination.kota
                                                      .toString(), // City name from the model
                                                  style: TextStyle(
                                                    // fontWeight: FontWeight.w700,
                                                    fontFamily: 'Poppinss',
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(height: 5),
                                                    Text(
                                                      'FCL : ${destination.fcl} Container', // FCL from the model
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        fontFamily:
                                                            'Poppins Med',
                                                      ),
                                                    ),
                                                    Text(
                                                      'LCL : ${destination.lcl} cbm', // LCL from the model
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        fontFamily:
                                                            'Poppins Med',
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                    SizedBox(height: 25),
                                    Text(
                                      "Kantor dan Cabang Kami",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'Poppinss',
                                        fontWeight: FontWeight.w700,
                                        color: Colors.red[900],
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    //kantor cabang api
                                    IntrinsicHeight(
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children:
                                              kantorCabangList.map((kantor) {
                                            return Container(
                                              width: 220,
                                              margin:
                                                  EdgeInsets.only(right: 10),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                border: Border.all(
                                                    color: Colors.grey,
                                                    width: 2.0),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                image: DecorationImage(
                                                  // Image URL as background
                                                  image: NetworkImage(
                                                      kantor.image ?? ''),
                                                  // Ensures the image covers the container area
                                                  fit: BoxFit.cover,
                                                  colorFilter: ColorFilter.mode(
                                                    // Adds overlay to improve text readability
                                                    Colors.black
                                                        .withOpacity(0.4),
                                                    // Darkens the background for better contrast
                                                    BlendMode.darken,
                                                  ),
                                                ),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 18,
                                                    right: 10,
                                                    top: 8,
                                                    bottom: 14),
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      kantor.namaCabang
                                                          .toString(),
                                                      style: TextStyle(
                                                        // fontWeight: FontWeight.w700,
                                                        fontSize: 13,
                                                        fontFamily: 'Poppinss',
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    SizedBox(height: 10),
                                                    Text(
                                                      kantor.alamat.toString(),
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'Poppins Med',
                                                          fontSize: 12,
                                                          color: Colors.white),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 25),
                                    Text(
                                      "Hubungi Kami",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'Poppinss',
                                        fontWeight: FontWeight.w700,
                                        color: Colors.red[900],
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    //hubungi kami api
                                    IntrinsicHeight(
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: hubungiKamilist.map((item) {
                                            return Container(
                                              width: 170,
                                              margin:
                                                  EdgeInsets.only(right: 10),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                border: Border.all(
                                                    color: Color.fromARGB(
                                                        255, 236, 236, 236),
                                                    width: 2.0),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8,
                                                    bottom: 8,
                                                    right: 8,
                                                    top: 5),
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      item.nama ?? 'Unknown',
                                                      style: TextStyle(
                                                        // fontWeight: FontWeight.w700,
                                                        fontSize: 12,
                                                        fontFamily:
                                                            'Poppins Med',
                                                        color:
                                                            Colors.yellow[900],
                                                      ),
                                                    ),
                                                    SizedBox(height: 5),
                                                    Text(
                                                      item.area ??
                                                          'Unknown Area',
                                                      style: TextStyle(
                                                        fontFamily:
                                                            'Poppins Med',
                                                        fontSize: 12,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                    SizedBox(height: 5),
                                                    GestureDetector(
                                                      onTap: () {
                                                        if (item.noWa != null) {
                                                          openWhatsApp(item
                                                              .noWa!); // Open WhatsApp using the noWa value
                                                        } else {
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                            SnackBar(
                                                                content: Text(
                                                                    'No WhatsApp number available')),
                                                          );
                                                        }
                                                      },
                                                      child: Text(
                                                        item.nomor ??
                                                            'Unknown No.',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontSize: 12,
                                                            color: Colors.blue),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 15),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        GestureDetector(
                                          onTap: () async {
                                            const url =
                                                'https://wa.me/6282245465151';
                                            if (await canLaunch(url)) {
                                              await launch(url);
                                            } else {
                                              // Handle error
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                    content: Text(
                                                        'Could not launch WhatsApp')),
                                              );
                                            }
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                color: Color.fromARGB(
                                                    255, 236, 236, 236),
                                                width: 2.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 15,
                                                  right: 10,
                                                  top: 3,
                                                  bottom: 3),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'Layanan Pelanggan',
                                                    style: TextStyle(
                                                      fontFamily: 'Poppinss',
                                                      fontSize: 12,
                                                      color: Colors.black,
                                                    ),
                                                    maxLines: 2,
                                                  ),
                                                  Image.asset(
                                                    'assets/layanan pelanggan.png',
                                                    // height: 60,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // Positioned(
                            //   bottom: -100,
                            //   left: 0,
                            //   right: 0,
                            //   child: Image.asset(
                            //     'assets/color bg.png',
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                      if (state is DataLoginInProgress)
                        Center(
                          child: CircularProgressIndicator(
                            color: Colors.amber[600],
                          ),
                        ),
                    ]);
              });
            });
          });
        });
      },
    );
  }
}
