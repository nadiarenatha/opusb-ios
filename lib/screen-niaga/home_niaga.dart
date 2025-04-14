// import 'dart:js';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:niaga_apps_mobile/login/login_body.dart';
import 'package:niaga_apps_mobile/screen-niaga/profile_niaga.dart';
import 'package:niaga_apps_mobile/screen-niaga/tracking_home_niaga.dart';
import '../cubit/niaga/contract_cubit.dart';
import '../cubit/niaga/data_login_cubit.dart';
import '../cubit/niaga/wa_push_otp_cubit.dart';
import '../cubit/niaga/wa_verifikasi_cubit.dart';
import '../model/data_login.dart';
import '../model/niaga/poin.dart';
import '../shared/constants.dart';
import 'home_screen_niaga.dart';
import 'invoice_home_niaga.dart';
import 'order_niaga.dart';
import 'package:flutter/services.dart';
import 'dart:async';

class HomeNiagaPage extends StatefulWidget {
  final int initialIndex;

  const HomeNiagaPage({Key? key, this.initialIndex = 2}) : super(key: key);

  @override
  State<HomeNiagaPage> createState() => _HomeNiagaPageState();
}

class _HomeNiagaPageState extends State<HomeNiagaPage> {
  OverlayEntry? _overlayEntry;
  bool _isTooltipActive = false;
  bool _isTooltipTrackingFinished = false;

  @override
  void initState() {
    super.initState();
    // Future.delayed(Duration(seconds: 5), () {
    //   _showTooltip(context);
    // });
    BlocProvider.of<ContractNiagaCubit>(context).cekPoin();
    BlocProvider.of<ContractNiagaCubit>(context).logCekPoin();
    _fetchAndLoginUser();
    if (widget.initialIndex == 2) {
      _getAssigner();
    }
    _selectedIndex = widget.initialIndex;
  }

  Future<void> _getAssigner() async {
    final assigner = await storage.read(
      key: AuthKey.assigner.toString(),
      aOptions: const AndroidOptions(
        encryptedSharedPreferences: true,
      ),
    );

    print('assigner retrieved from storage: $assigner');

    // Check if assigner is 'true' and show the tooltip
    if (assigner == 'true') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showTooltip(context);
      });
    }
  }

  void _showTooltip(BuildContext context) {
    setState(() {
      _isTooltipActive = true;
    });
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
    OverlayState? overlayState = Overlay.of(context);
    debugPrint("Menampilkan tooltip");

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            Positioned(
              top: 175,
              left: 15,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: 200,
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Pilih Pemesanan FCL (Full Container Load) apabila anda ingin mengirimkan barang menggunakan satu atau beberapa unit container sekaligus',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          _removeTooltip();
                          _showTooltipLCL(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: Text('Lanjut',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 360,
              left: 90,
              child: Icon(Icons.arrow_drop_down,
                  size: 40, color: Colors.black.withOpacity(0.7)),
            ),
          ],
        );
      },
    );

    overlayState.insert(_overlayEntry!);
  }

  //LCL
  void _showTooltipLCL(BuildContext context) {
    setState(() {
      _isTooltipActive = true;
    });
    OverlayState? overlayState = Overlay.of(context);

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Stack(
          alignment: Alignment.topCenter,
          children: [
            Positioned(
              top: 160,
              right: 15,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: 200,
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(color: Colors.black26, blurRadius: 4),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Pilih Pemesanan LCL (Less Container Load) apabila anda ingin mengirimkan barang yang tidak membutuhkan kapasitas satu container penuh',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              _removeTooltip();
                              _showTooltip(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            child: Text('Kembali',
                                style: TextStyle(color: Colors.white)),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              _removeTooltip();
                              _showTooltipOrder(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            child: Text('Lanjut',
                                style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 360,
              right: 80,
              child: Icon(Icons.arrow_drop_down,
                  size: 40, color: Colors.black.withOpacity(0.7)),
            ),
          ],
        );
      },
    );

    overlayState.insert(_overlayEntry!);
  }

  //Order
  void _showTooltipOrder(BuildContext context) {
    setState(() {
      _isTooltipActive = true;
    });
    OverlayState? overlayState = Overlay.of(context);

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        // top: MediaQuery.of(context).size.height - 300, // Adjust position
        top: MediaQuery.of(context).size.height - 240, // Adjust position
        left: MediaQuery.of(context).size.width * 0.02, // Adjust position
        child: Column(
          children: [
            Material(
              color: Colors.transparent,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 200,
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black
                          .withOpacity(0.7), // Transparent black color
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            'Untuk melihat riwayat dari seluruh pesanan anda, klik menu ‘Order’',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                _removeTooltip();
                                _showTooltipLCL(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              child: Text('Kembali',
                                  style: TextStyle(color: Colors.white)),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                _removeTooltip();
                                _showTooltipTracking(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              child: Text('Lanjut',
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    overlayState.insert(_overlayEntry!);
  }

  //Tracking
  void _showTooltipTracking(BuildContext context) {
    setState(() {
      _isTooltipActive = true;
    });
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
    OverlayState? overlayState = Overlay.of(context);

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        // top: MediaQuery.of(context).size.height - 300, // Adjust position
        top: MediaQuery.of(context).size.height - 240, // Adjust position
        left: MediaQuery.of(context).size.width * 0.2, // Adjust position
        child: Column(
          children: [
            Material(
              color: Colors.transparent,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 200,
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black
                          .withOpacity(0.7), // Transparent black color
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Untuk melacak barang anda berdasarkan nomor Packing List, klik menu ‘Tracking’',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                _removeTooltip();
                                _showTooltipOrder(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              child: Text('Kembali',
                                  style: TextStyle(color: Colors.white)),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                _removeTooltip();
                                setState(() {
                                  _isTooltipTrackingFinished = true;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              child: Text('Selesai',
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    overlayState.insert(_overlayEntry!);
  }

  // void _removeTooltip() {
  //   _overlayEntry?.remove();
  //   _overlayEntry = null;
  // }

  void _removeTooltip() {
    setState(() {
      _isTooltipActive = false;
    });
    if (_overlayEntry != null) {
      debugPrint("Menghapus tooltip");
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
  }

  @override
  //untuk set navigasi bar dashboard, home, profile
  int _selectedIndex = 2;
  // int _selectedIndex = widget.;
  bool isSelected = false;
  DataLoginAccesses? dataLogin;
  final FlutterSecureStorage storage = FlutterSecureStorage();
  final List<TextEditingController> _otpControllers =
      List.generate(6, (_) => TextEditingController());
  PoinAccesses? cekPoin;

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
      // Trigger the dataLogin API call with the userId
      BlocProvider.of<DataLoginCubit>(context).dataLogin(id: int.parse(userId));
    }
  }

  Future<void> _refreshPage() async {
    // Add your refresh logic here
    await BlocProvider.of<ContractNiagaCubit>(context).cekPoin();
    await BlocProvider.of<ContractNiagaCubit>(context).logCekPoin();
    await _fetchAndLoginUser();
  }

  @override
  void dispose() {
    // Dispose of the controllers when the widget is disposed
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  Future<void> logOut(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        // Adjust the padding for the title and content
        titlePadding: EdgeInsets.zero,
        contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 3),
        content: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 900, maxWidth: 300),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Apakah Anda yakin ingin keluar?",
                style: TextStyle(color: Colors.black, fontFamily: 'Poppins'),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return LoginBody();
                      }));
                    },
                    child: Text(
                      "Ya",
                      style:
                          TextStyle(color: Colors.black, fontFamily: 'Poppins'),
                    ),
                  ),
                  SizedBox(width: 10),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: Text(
                      "Tidak",
                      style:
                          TextStyle(color: Colors.black, fontFamily: 'Poppins'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future verifikasiWA() => showDialog(
      context: context,
      //alert diberi SingleChildScrollView agar bisa di scroll
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

  Future kodeOTP() => showDialog(
        context: context,
        builder: (BuildContext context) {
          // Allow dialog dismissal with a tap outside
          int remainingSeconds = 120; // Initialize countdown in dialog
          // late Timer timer;
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
                                // Start a new countdown
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
      //alert diberi SingleChildScrollView agar bisa di scroll
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
                    children: [],
                  ),
                  content: verifBerhasil()),
            ),
          ));

  //untuk BottomNavigationBarItem
  static List<Widget> _widgetOptions = <Widget>[
    OrderHomeNiagaPage(),
    TrackingHomeNiagaPage(resiNumber: ''),
    // HomePageScreen(),
    //untuk navigate ke hlmn tracking
    HomePageScreenNiaga(qrResult: null, resiNumber: ''),
    MyInvoiceHomeNiagaPage(),
    ProfileNiagaHomePage(),
  ];

  //untuk BottomNavigationBarItem
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // isSelected = !isSelected;
    });
  }

  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return BlocConsumer<ContractNiagaCubit, ContractNiagaState>(
        listener: (context, state) async {
      if (state is CekPoinSuccess) {
        setState(() {
          cekPoin = state.response;
        });
        print('Ini Respon Poin nya : $cekPoin');
        print('Ini Poin nya : ${cekPoin?.point}');
      }
    }, builder: (context, state) {
      return BlocConsumer<DataLoginCubit, DataLoginState>(
          listener: (context, state) async {
        if (state is DataLoginSuccess) {
          // dataLogin = state.response;
          setState(() {
            dataLogin = state.response;
          });
          print('Ini Data nya yang akan di ambil : $dataLogin');
        }
      }, builder: (context, state) {
        bool isLoading = state is DataLoginInProgress;
        return Stack(
          children: [
            Scaffold(
                appBar: _selectedIndex == 0 ||
                        _selectedIndex == 1 ||
                        _selectedIndex == 3 ||
                        _selectedIndex == 4
                    ? null
                    : PreferredSize(
                        preferredSize: Size.fromHeight(
                          // 0.073 * MediaQuery.of(context).size.height,
                          // 0.10 * MediaQuery.of(context).size.height,
                          (dataLogin?.waVerified == true)
                              ? 0.073 * MediaQuery.of(context).size.height
                              : 0.10 * MediaQuery.of(context).size.height,
                        ),
                        child: AppBar(
                          backgroundColor: Colors.white,
                          flexibleSpace: Padding(
                            padding: const EdgeInsets.only(left: 20.0, top: 30),
                            child: _selectedIndex == 2
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Column(
                                          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(height: 5),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 5),
                                              child: Text(
                                                'Selamat Datang',
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.black,
                                                    fontFamily:
                                                        'Poppins Extra Bold'),
                                              ),
                                            ),
                                            // SizedBox(height: 7),
                                            Text(
                                              // 'PT Adikrasa Mitrajaya !',
                                              '${dataLogin?.lastName ?? ''} !',
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.red[900],
                                                  fontFamily: 'Poppins Extra Bold'),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            SizedBox(height: 8),
                                            // if (dataLogin?.waVerified == null)
                                            if (dataLogin?.waVerified == null ||
                                                dataLogin?.waVerified != true)
                                                InkWell(
                                                onTap: isLoading || _isTooltipActive
                                                  ? null
                                                  : () {
                                                    verifikasiWA();
                                                    },
                                                child: Row(
                                                  children: [
                                                  Image.asset('assets/info.png'),
                                                  Text(
                                                    ' Nomor WhatsApp Anda Belum Terverifikasi',
                                                    style: TextStyle(
                                                      color: Color.fromARGB(
                                                        255, 56, 28, 211),
                                                      fontWeight:
                                                        FontWeight.w900,
                                                      fontSize: 10),
                                                  )
                                                  ],
                                                ),
                                                )
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(right: 10),
                                        child: Container(
                                            width: 90,
                                            height: 35,
                                            // padding:
                                            //     EdgeInsets.all(8), // Optional padding
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors
                                                    .red[900]!, // Red border color
                                                width: 2.0, // Border width
                                              ),
                                              borderRadius: BorderRadius.circular(
                                                  8), // Optional border radius
                                            ),
                                            child: Center(
                                              child: Text(
                                                // '48 Points',
                                                (cekPoin?.point?.toString() ??
                                                        '0') +
                                                    ' Points',
                                                style: TextStyle(
                                                    fontSize: 11,
                                                    fontFamily: 'Poppinss'),
                                              ),
                                            )),
                                      )
                                    ],
                                  )
                                : SizedBox(), // Use SizedBox to avoid rendering an empty Container
                          ),
                          leading: Container(),
                        ),
                      ),
                body: RefreshIndicator(
                  onRefresh: _refreshPage,
                  child: _widgetOptions[_selectedIndex],
                ),
                // bottomNavigationBar: Container(
                //   decoration: BoxDecoration(
                //     boxShadow: [
                //       BoxShadow(
                //         color: Colors.grey.withOpacity(0.5), // Shadow color
                //         spreadRadius: 5, // How much the shadow spreads
                //         blurRadius: 7, // How soft the shadow looks
                //         offset: Offset(0, 3), // Changes position of the shadow
                //       ),
                //     ],
                //   ),
                //   child: BottomNavigationBar(
                //     type: BottomNavigationBarType.fixed,
                //     items: const <BottomNavigationBarItem>[
                //       BottomNavigationBarItem(
                //           icon: Icon(Icons.dashboard), label: 'Order'),
                //       BottomNavigationBarItem(
                //         icon: SizedBox(
                //           width: 20,
                //           child: ImageIcon(
                //             AssetImage('assets/tracking icon.png'),
                //           ),
                //         ),
                //         label: 'Tracking',
                //       ),
                //       BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                //       BottomNavigationBarItem(
                //         icon: SizedBox(
                //           width: 12,
                //           child: ImageIcon(
                //             AssetImage('assets/invoice icon.png'),
                //           ),
                //         ),
                //         label: 'Invoice',
                //       ),
                //       BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
                //     ],
                //     currentIndex: _selectedIndex,
                //     selectedItemColor: Colors.red[900],
                //     unselectedItemColor: Colors.grey[600],
                //     onTap: _onItemTapped,
                //   ),
                // ),
                //===NEW
                bottomNavigationBar: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5), // Shadow color
                        spreadRadius: 5, // How much the shadow spreads
                        blurRadius: 7, // How soft the shadow looks
                        offset: Offset(0, 3), // Changes position of the shadow
                      ),
                    ],
                  ),
                  child: BottomNavigationBar(
                    type: BottomNavigationBarType.fixed,
                    items: <BottomNavigationBarItem>[
                      const BottomNavigationBarItem(
                        icon: Icon(
                          Icons.dashboard,
                          size: 27,
                        ),
                        label: 'Order',
                      ),
                      const BottomNavigationBarItem(
                        icon: SizedBox(
                          // width: 20,
                          width: 23,
                          child: ImageIcon(
                            AssetImage('assets/tracking icon.png'),
                          ),
                        ),
                        label: 'Tracking',
                      ),
                      BottomNavigationBarItem(
                        icon: Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            Container(
                              height: 50, // Adjusted size of the circle
                              width: 50,
                              decoration: BoxDecoration(
                                color: Colors.red[900], // Red circle color
                                shape: BoxShape.circle,
                              ),
                            ),
                            Icon(
                              Icons.home,
                              size: 28,
                              color: Colors.white,
                            ),
                          ],
                        ),
                        label: '',
                      ),
                      const BottomNavigationBarItem(
                        icon: SizedBox(
                          width: 23,
                          child: ImageIcon(
                            AssetImage('assets/invoice icon.png'),
                          ),
                        ),
                        label: 'Invoice',
                      ),
                      const BottomNavigationBarItem(
                        icon: Icon(
                          Icons.person,
                          size: 27,
                        ),
                        label: 'Profil',
                      ),
                    ],
                    currentIndex: _selectedIndex,
                    selectedItemColor: Colors.red[900],
                    unselectedItemColor: Colors.grey[600],
                    onTap: _isTooltipActive ? null : _onItemTapped,
                  ),
                ),
              ),
              if (_isTooltipActive)
                ModalBarrier(
                  dismissible: false,
                  color: Colors.black.withOpacity(0.5),
                ),
          ],
        );
      });
    });
  }

  verifikasi() {
    return Padding(
      // padding: const EdgeInsets.all(8.0),
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
                      // return DetailInvoiceHomeNiagaPage();
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
}
