import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:niaga_apps_mobile/login/login_body.dart';
import 'package:niaga_apps_mobile/screen-niaga/profile_niaga.dart';
import 'package:niaga_apps_mobile/screen-niaga/tracking_home_niaga.dart';
import '../Invoice/menu_invoice_niaga.dart';
import '../Invoice/my_invoice_niaga.dart';
import '../cubit/niaga/barang_dashboard_cubit.dart';
import '../cubit/niaga/data_login_cubit.dart';
// import '../keterangan-data/data_kosong.dart';
import '../model/data_login.dart';
import '../model/niaga/barang_dashboard.dart';
import '../model/niaga/invoice_summary.dart';
import '../order/menu_order_niaga.dart';
import '../packing/packing_list_niaga.dart';
import '../packing/packing_tracking_niaga.dart';
import '../profile/about_aplikasi_niaga.dart';
import '../profile/about_niaga.dart';
import '../profile/daftar_alamat.dart';
import '../profile/daftar_pembayaran.dart';
import '../profile/kebijakan_niaga.dart';
import '../profile/password_profil.dart';
import '../profile/pencarian_barang.dart';
import '../profile/profil_niaga.dart';
import '../profile/setting_akun_niaga.dart';
import '../shared/constants.dart';
import '../shared/functions/flutter_secure_storage.dart';
import '../stok-barang-gudang/stok_barang_niaga.dart';
import '../tracking/menu_tracking_niaga.dart';
import 'home_niaga.dart';
import 'home_screen_niaga.dart';
import 'invoice_home_niaga.dart';
import 'order_niaga.dart';

class ProfileNewNiagaHomePage extends StatefulWidget {
  const ProfileNewNiagaHomePage({Key? key}) : super(key: key);

  @override
  State<ProfileNewNiagaHomePage> createState() =>
      _ProfileNewNiagaHomePageState();
}

class _ProfileNewNiagaHomePageState extends State<ProfileNewNiagaHomePage> {
  @override

  //untuk BottomNavigationBarItem
  int _selectedIndex = 0;
  TextEditingController emailPerusahaanController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController alamatController = TextEditingController();
  TextEditingController kotaController = TextEditingController();
  TextEditingController telpController = TextEditingController();
  TextEditingController faxController = TextEditingController();
  TextEditingController npwpController = TextEditingController();
  DataLoginAccesses? dataLogin;
  // List<BarangDashboardAccesses> barangDashboard = [];
  List<BarangDashboardAccesses> barangDalamGudang = [];
  List<BarangDashboardAccesses> barangDalamPerjalananFCL = [];
  List<BarangDashboardAccesses> barangDalamPerjalananLCL = [];
  InvoiceSummaryAccesses? invoiceSummary;

  @override
  void initState() {
    super.initState();
    _fetchAndLoginUser();
    // context.read<BarangDashboardCubit>().barangDashboard();
    BlocProvider.of<BarangDashboardCubit>(context).barangDashboard();
    BlocProvider.of<BarangDashboardCubit>(context).invoiceSummary();
  }

  static List<Widget> _widgetOptions = <Widget>[
    MenuOrderNiagaPage(),
    MenuTrackingNiagaPage(resiNumber: ''),
    HomeNiagaPage(),
    MenuInvoiceNiagaPage(),
    ProfileNiagaPage(),
  ];

  //untuk BottomNavigationBarItem
  void _onItemTapped(int index) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => _widgetOptions[index]),
    );
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
      // Trigger the dataLogin API call with the userId
      BlocProvider.of<DataLoginCubit>(context).dataLogin(id: int.parse(userId));
    }
  }

  Future profil() => showDialog(
      context: context,
      builder: (BuildContext context) => Align(
            alignment: Alignment.topRight, // Align dialog to the top right
            child: SingleChildScrollView(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.65,
                child: AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  // titlePadding: EdgeInsets.zero,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 25, vertical: 3),
                  content: infoProfil(),
                ),
              ),
            ),
            // ),
          ));

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
                style: TextStyle(
                    color: Colors.black, fontFamily: 'Poppins Regular'),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      clearLocalStorage();
                      // Navigator.pushReplacement(context,
                      //     MaterialPageRoute(builder: (context) {
                      //   return LoginBody();
                      // }));
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => LoginBody()),
                        (Route<dynamic> route) => false,
                      );
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

  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return BlocConsumer<DataLoginCubit, DataLoginState>(
        listener: (context, state) async {
      if (state is DataLoginSuccess) {
        setState(() {
          dataLogin = state.response;
        });
        print('Ini Data nya yang akan di ambil di halaman profil : $dataLogin');
      }
    }, builder: (context, state) {
      return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(
              0.07 * MediaQuery.of(context).size.height,
            ),
            child: AppBar(
              backgroundColor: Colors.white,
              // title: Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Expanded(
              //       child: Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           Text(
              //             // "PT Adikrasa Mitrajaya",
              //             dataLogin?.name ?? '',
              //             style: TextStyle(
              //                 fontSize: 14,
              //                 color: Colors.red[900],
              //                 fontFamily: 'Poppins Bold'),
              //             overflow: TextOverflow.ellipsis,
              //           ),
              //           SizedBox(height: 5),
              //           Text(
              //             // "email@adikrasa.com",
              //             // dataLogin?.email ?? '',
              //             dataLogin?.email?.toLowerCase() ?? '',
              //             style: TextStyle(
              //                 fontSize: 12,
              //                 color: Colors.black,
              //                 fontFamily: 'Poppins Med'),
              //             overflow: TextOverflow.ellipsis,
              //           ),
              //         ],
              //       ),
              //     ),
              //     // IconButton(
              //     //     icon: Icon(
              //     //       Icons.logout,
              //     //       color: Colors.black,
              //     //     ),
              //     //     onPressed: () {
              //     //       logOut(context);
              //     //     }),
              //     GestureDetector(
              //       onTap: () {
              //         profil();
              //       },
              //       child: Container(
              //         width: 140,
              //         height: 35,
              //         padding:
              //             EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              //         decoration: BoxDecoration(
              //           color: Colors.red[900],
              //           borderRadius:
              //               BorderRadius.circular(20), // Circular border
              //         ),
              //         child: Center(
              //           child: Text(
              //             'Profil Saya',
              //             style: TextStyle(
              //                 color: Colors.white,
              //                 fontFamily: 'Poppinss',
              //                 fontSize: 14),
              //           ),
              //         ),
              //       ),
              //     )
              //   ],
              // ),
              flexibleSpace: Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 32, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 7),
                          Text(
                            // "PT Adikrasa Mitrajaya",
                            dataLogin?.name ?? '',
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.red[900],
                                fontFamily: 'Poppins Bold'),
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 5),
                          Text(
                            // "email@adikrasa.com",
                            // dataLogin?.email ?? '',
                            dataLogin?.email?.toLowerCase() ?? '',
                            style: TextStyle(
                                fontSize: 10,
                                color: Colors.black,
                                fontFamily: 'Poppins Med'),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        profil();
                      },
                      child: Container(
                        width: 140,
                        height: 35,
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                        decoration: BoxDecoration(
                          color: Colors.red[900],
                          borderRadius:
                              BorderRadius.circular(20), // Circular border
                        ),
                        child: Center(
                          child: Text(
                            'Profil Saya',
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Poppinss',
                                fontSize: 12),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              //agar tulisan di appbar berada di tengah tinggi bar
              toolbarHeight: 0.07 * MediaQuery.of(context).size.height,
              leading: Container(),
            ),
          ),
          body: BlocConsumer<BarangDashboardCubit, BarangDashboardState>(
              listener: (context, state) {
            if (state is BarangDashboardSuccess) {
              // barangDashboard.clear();
              // barangDashboard = state.response;
              barangDalamGudang.clear();
              barangDalamPerjalananFCL.clear();
              barangDalamPerjalananLCL.clear();

              for (var item in state.response) {
                if (item.description == 'JUMLAH BARANG') {
                  barangDalamGudang.add(item);
                } else if (item.description ==
                    'JUMLAH CONTAINER FCL YANG SEDANG DIKIRIM') {
                  barangDalamPerjalananFCL.add(item);
                } else if (item.description ==
                    'JUMLAH KUBIKASI LCL DALAM PERJALANAN') {
                  barangDalamPerjalananLCL.add(item);
                }
              }
            }
            if (state is InvoiceSummarySuccess) {
              invoiceSummary = state.response;
            }
          }, builder: (context, state) {
            return SingleChildScrollView(
              child: Stack(children: [
                Positioned(
                    top: -230,
                    right: -20,
                    child: Image.asset(
                      'assets/bg-color-grad.png',
                    )),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      //baris 1
                      IntrinsicHeight(
                        child: Row(
                          children: [
                            Flexible(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return StokBarangNiagaPage();
                                  }));
                                },
                                child: Container(
                                  // Reduce padding inside the container
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 253, 242, 248),
                                    border: Border.all(
                                      color: Color.fromARGB(
                                          255, 204, 136, 136), // Red border
                                      width: 2.0,
                                    ),
                                    // boxShadow: [
                                    //   BoxShadow(
                                    //     color: Colors.grey.withOpacity(
                                    //         0.5), // Grey shadow color
                                    //     spreadRadius: 2,
                                    //     blurRadius: 5,
                                    //     offset: Offset(
                                    //         0, 3), // Changes position of shadow
                                    //   ),
                                    // ],
                                    borderRadius: BorderRadius.circular(
                                        8), // Optional border radius
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Barang Dalam Gudang',
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontFamily: 'Poppinss'),
                                      ),
                                      SizedBox(
                                          height:
                                              20), // Reduce space between the texts
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            // '195 m3',
                                            barangDalamGudang.isNotEmpty
                                                ? '${barangDalamGudang.first.total} m3'
                                                : '0 m3',
                                            style: TextStyle(
                                                fontSize: 11,
                                                fontFamily: 'Poppins Med'),
                                          ),
                                          Flexible(
                                            child: Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                FittedBox(
                                                  fit: BoxFit.contain,
                                                  child: Image.asset(
                                                    'assets/storage.png',
                                                    width: 50, // Frame width
                                                    height: 50, // Frame height
                                                  ),
                                                ),
                                                // FittedBox(
                                                //   fit: BoxFit.contain,
                                                //   child: Image.asset(
                                                //     'assets/warehouse profil.png', // Image to place inside the frame
                                                //     width:
                                                //         24, // Adjust size as needed
                                                //     height: 24,
                                                //   ),
                                                // ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 16),
                            Flexible(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return MyInvoiceNiagaPage();
                                  }));
                                },
                                child: Container(
                                  // Reduce padding inside the container
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 253, 242, 248),
                                    border: Border.all(
                                      // color: Colors.red[900]!, // Red border
                                      color: Color.fromARGB(255, 204, 136, 136),
                                      width: 2.0,
                                    ),
                                    // boxShadow: [
                                    //   BoxShadow(
                                    //     // Grey shadow color
                                    //     color: Colors.grey.withOpacity(0.5),
                                    //     spreadRadius: 2,
                                    //     blurRadius: 5,
                                    //     // Changes position of shadow
                                    //     offset: Offset(0, 3),
                                    //   ),
                                    // ],
                                    // Optional border radius
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Tagihan Saya',
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontFamily: 'Poppinss'),
                                      ),
                                      SizedBox(height: 20),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                            child: Text(
                                              // 'Rp. 00000000000000000000000000000000000000000000000000000000000000000000000000000000',
                                              // invoiceSummary?.totalTagihan?.toString() ?? 'Rp. 0',
                                              // 'Rp. ${invoiceSummary?.totalTagihan?.toString() ?? '0'}',
                                              '${invoiceSummary?.formattedTotalTagihan ?? 'Rp0,00'}',
                                              style: TextStyle(
                                                  fontSize: 11,
                                                  fontFamily: 'Poppins Med'),
                                              maxLines: 4,
                                              // overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Flexible(
                                            child: Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                FittedBox(
                                                  fit: BoxFit.contain,
                                                  child: Image.asset(
                                                    'assets/invoice.png',
                                                    width: 50, // Frame width
                                                    height: 50, // Frame height
                                                  ),
                                                ),
                                                // FittedBox(
                                                //   fit: BoxFit.contain,
                                                //   child: Image.asset(
                                                //     'assets/invoice profil.png', // Image to place inside the frame
                                                //     width:
                                                //         30, // Adjust size as needed
                                                //     height: 30,
                                                //   ),
                                                // ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      //baris 2
                      IntrinsicHeight(
                        child: Row(
                          children: [
                            Flexible(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return PackingTrackingListNiagaPage();
                                    // return DataKosongPage();
                                  }));
                                },
                                child: Container(
                                  // Reduce padding inside the container
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 253, 242, 248),
                                    border: Border.all(
                                      color: Color.fromARGB(255, 204, 136, 136),
                                      width: 2.0,
                                    ),
                                    // boxShadow: [
                                    //   BoxShadow(
                                    //     // Grey shadow color
                                    //     color: Colors.grey.withOpacity(0.5),
                                    //     spreadRadius: 2,
                                    //     blurRadius: 5,
                                    //     // Changes position of shadow
                                    //     offset: Offset(0, 3),
                                    //   ),
                                    // ],
                                    // Optional border radius
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Barang Dalam Perjalanan LCL',
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontFamily: 'Poppinss'),
                                      ),
                                      // Reduce space between the texts
                                      SizedBox(height: 20),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            // '18 cbm',
                                            barangDalamPerjalananLCL.isNotEmpty
                                                ? '${barangDalamPerjalananLCL.first.total} cbm'
                                                : '0 cbm',
                                            style: TextStyle(
                                                fontSize: 11,
                                                fontFamily: 'Poppins Med'),
                                          ),
                                          //Flexible Image :
                                          //The image inside "Barang Dalam Perjalanan" now uses FittedBox to scale flexibly and fit within the available space without overflow
                                          //Flexible : The entire container for both columns uses Flexible, which helps the images and texts adapt to different screen sizes.
                                          Flexible(
                                            child: Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                FittedBox(
                                                  fit: BoxFit.contain,
                                                  child: Image.asset(
                                                    'assets/truck new.png',
                                                    width: 50, // Frame width
                                                    height: 50, // Frame height
                                                  ),
                                                ),
                                                // FittedBox(
                                                //   fit: BoxFit.contain,
                                                //   child: Image.asset(
                                                //     'assets/truck profil.png', // Image to place inside the frame
                                                //     width:
                                                //         24, // Adjust size as needed
                                                //     height: 24,
                                                //   ),
                                                // ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 16),
                            Flexible(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return PackingTrackingListNiagaPage();
                                  }));
                                },
                                child: Container(
                                  // Reduce padding inside the container
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 253, 242, 248),
                                    border: Border.all(
                                      color: Color.fromARGB(255, 204, 136, 136),
                                      width: 2.0,
                                    ),
                                    // boxShadow: [
                                    //   BoxShadow(
                                    //     // Grey shadow color
                                    //     color: Colors.grey.withOpacity(0.5),
                                    //     spreadRadius: 2,
                                    //     blurRadius: 5,
                                    //     // Changes position of shadow
                                    //     offset: Offset(0, 3),
                                    //   ),
                                    // ],
                                    // Optional border radius
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Barang Dalam Perjalanan FCL',
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontFamily: 'Poppinss'),
                                      ),
                                      // Reduce space between the texts
                                      SizedBox(height: 20),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            // '7 Container',
                                            barangDalamPerjalananFCL.isNotEmpty
                                                ? '${barangDalamPerjalananFCL.first.total} Container'
                                                : '0 Container',
                                            style: TextStyle(
                                                fontSize: 11,
                                                fontFamily: 'Poppins Med'),
                                          ),
                                          //Flexible Image :
                                          //The image inside "Barang Dalam Perjalanan" now uses FittedBox to scale flexibly and fit within the available space without overflow
                                          //Flexible : The entire container for both columns uses Flexible, which helps the images and texts adapt to different screen sizes.
                                          Flexible(
                                            child: Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                FittedBox(
                                                  fit: BoxFit.contain,
                                                  child: Image.asset(
                                                    'assets/container.png',
                                                    width: 50, // Frame width
                                                    height: 50, // Frame height
                                                  ),
                                                ),
                                                // FittedBox(
                                                //   fit: BoxFit.contain,
                                                //   child: Image.asset(
                                                //     'assets/fcl logo.png', // Image to place inside the frame
                                                //     width:
                                                //         24, // Adjust size as needed
                                                //     height: 24,
                                                //   ),
                                                // ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            // Flexible(
                            //   child: GestureDetector(
                            //     onTap: () {
                            //       Navigator.push(context,
                            //           MaterialPageRoute(builder: (context) {
                            //         return MenuOrderNiagaPage();
                            //       }));
                            //     },
                            //     child: Container(
                            //       // Reduce padding inside the container
                            //       padding: EdgeInsets.all(8),
                            //       decoration: BoxDecoration(
                            //         color: Colors.white,
                            //         border: Border.all(
                            //           color: Colors.red[900]!, // Red border
                            //           width: 2.0,
                            //         ),
                            //         boxShadow: [
                            //           BoxShadow(
                            //             // Grey shadow color
                            //             color: Colors.grey.withOpacity(0.5),
                            //             spreadRadius: 2,
                            //             blurRadius: 5,
                            //             // Changes position of shadow
                            //             offset: Offset(0, 3),
                            //           ),
                            //         ],
                            //         // Optional border radius
                            //         borderRadius: BorderRadius.circular(8),
                            //       ),
                            //       child: Column(
                            //         crossAxisAlignment: CrossAxisAlignment.start,
                            //         mainAxisAlignment:
                            //             MainAxisAlignment.spaceBetween,
                            //         children: [
                            //           Text(
                            //             'Menunggu Konfirmasi Admin',
                            //             style: TextStyle(
                            //                 fontSize: 16,
                            //                 fontWeight: FontWeight.w700),
                            //           ),
                            //           // Reduce space between the texts
                            //           SizedBox(height: 20),
                            //           Row(
                            //             mainAxisAlignment:
                            //                 MainAxisAlignment.spaceBetween,
                            //             children: [
                            //               Text(
                            //                 '0 order',
                            //                 style: TextStyle(fontSize: 14),
                            //               ),
                            //               Flexible(
                            //                 child: Stack(
                            //                   alignment: Alignment.center,
                            //                   children: [
                            //                     FittedBox(
                            //                       fit: BoxFit.contain,
                            //                       child: Image.asset(
                            //                         'assets/frame profil.png',
                            //                         width: 60, // Frame width
                            //                         height: 60, // Frame height
                            //                       ),
                            //                     ),
                            //                     FittedBox(
                            //                       fit: BoxFit.contain,
                            //                       child: Image.asset(
                            //                         'assets/checklist profil.png', // Image to place inside the frame
                            //                         width:
                            //                             26, // Adjust size as needed
                            //                         height: 26,
                            //                       ),
                            //                     ),
                            //                   ],
                            //                 ),
                            //               ),
                            //             ],
                            //           ),
                            //         ],
                            //       ),
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                      SizedBox(height: 25),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors
                              .white, // Background color of the outer container
                          border: Border.all(
                            color: Colors.grey, // Grey border color
                            width: 2.0, // Border width
                          ),
                          // boxShadow: [
                          //   BoxShadow(
                          //     // Grey shadow color with opacity
                          //     color: Colors.grey.withOpacity(0.5),
                          //     spreadRadius: 2, // How far the shadow spreads
                          //     blurRadius: 5, // How much the shadow is blurred
                          //     offset: Offset(0, 3), // Position of the shadow
                          //   ),
                          // ],
                          borderRadius: BorderRadius.circular(
                              8), // Optional: Add border radius
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              //alamat
                              Flexible(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return DaftarAlamatNiagaPage();
                                    }));
                                  },
                                  child: Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          // Grey background color for inner container
                                          color: Colors.grey[200],
                                          // border: Border.all(
                                          //   color:
                                          //       Colors.grey, // Black border color
                                          //   width: 2.0, // Border width
                                          // ),
                                          // boxShadow: [
                                          //   BoxShadow(
                                          //     // Grey shadow color with opacity
                                          //     color: Colors.grey.withOpacity(0.5),
                                          //     spreadRadius: 2,
                                          //     blurRadius: 5,
                                          //     offset: Offset(0, 3),
                                          //   ),
                                          // ],
                                          // Optional: Add border radius
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        // Optional: Add padding around the image
                                        padding: EdgeInsets.all(10),
                                        child: Image.asset(
                                          'assets/Simulasi-Pengiriman.png', // Image to place inside the frame
                                          width: 26, // Adjust size as needed
                                          height: 26,
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Column(
                                        children: [
                                          Text(
                                            'Daftar',
                                            style: TextStyle(
                                                fontSize: 11,
                                                fontFamily: 'Poppins Med'),
                                          ),
                                          Text(
                                            'Alamat',
                                            style: TextStyle(
                                                fontSize: 11,
                                                fontFamily: 'Poppins Med'),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              //daftar pembayaran
                              Flexible(
                                child: GestureDetector(
                                  onTap: () {
                                    // Navigator.push(context,
                                    //     MaterialPageRoute(builder: (context) {
                                    //   return DaftarPembayaranNiagaPage();
                                    // }));
                                  },
                                  child: Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          // Grey background color for inner container
                                          color: Colors.grey[200],
                                          // Optional: Add border radius
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        // Optional: Add padding around the image
                                        padding: EdgeInsets.all(10),
                                        child: Image.asset(
                                          'assets/pembayaran profil.png', // Image to place inside the frame
                                          width: 26, // Adjust size as needed
                                          height: 26,
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Column(
                                        children: [
                                          Text(
                                            'Riwayat',
                                            style: TextStyle(
                                                fontSize: 11,
                                                fontFamily: 'Poppins Med'),
                                          ),
                                          Text(
                                            'Pembayaran',
                                            style: TextStyle(
                                                fontSize: 11,
                                                fontFamily: 'Poppins Med'),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              //pencarian barang
                              Flexible(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return PencarianBarangNiagaPage();
                                    }));
                                  },
                                  child: Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          // Grey background color for inner container
                                          color: Colors.grey[200],
                                          // Optional: Add border radius
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        // Optional: Add padding around the image
                                        padding: EdgeInsets.all(10),
                                        child: Image.asset(
                                          'assets/pencarian profil.png', // Image to place inside the frame
                                          width: 26, // Adjust size as needed
                                          height: 26,
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Column(
                                        children: [
                                          Text(
                                            'Pencarian',
                                            style: TextStyle(
                                                fontSize: 11,
                                                fontFamily: 'Poppins Med'),
                                          ),
                                          Text(
                                            'Barang',
                                            style: TextStyle(
                                                fontSize: 11,
                                                fontFamily: 'Poppins Med'),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 25),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.grey,
                            width: 2.0,
                          ),
                          // boxShadow: [
                          //   BoxShadow(
                          //     // Grey shadow color with opacity
                          //     color: Colors.grey.withOpacity(0.5),
                          //     spreadRadius: 2, // How far the shadow spreads
                          //     blurRadius: 5, // How much the shadow is blurred
                          //     offset: Offset(0, 3), // Position of the shadow
                          //   ),
                          // ],
                          // Optional: Add border radius
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            children: [
                              //1
                              InkWell(
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return KebijakanNiagaPage();
                                  }));
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset(
                                          'assets/privasi profil.png',
                                          // width: 60, // Frame width
                                          // height: 60, // Frame height
                                        ),
                                        Text(
                                          ' Kebijakan Privasi',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: 'Poppinss'),
                                        ),
                                      ],
                                    ),
                                    Icon(
                                      Icons.navigate_next,
                                      size: 22,
                                      color: Colors.black,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20),
                              //2
                              InkWell(
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return AboutNiagaPage();
                                  }));
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset(
                                          'assets/informasi profil.png',
                                        ),
                                        Text(
                                          ' Tentang Niaga Logistics',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: 'Poppinss'),
                                        ),
                                      ],
                                    ),
                                    Icon(
                                      Icons.navigate_next,
                                      size: 22,
                                      color: Colors.black,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20),
                              //3
                              InkWell(
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return AboutAplikasiNiagaPage();
                                  }));
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset(
                                          'assets/aplikasi profil.png',
                                        ),
                                        Text(
                                          ' Tentang Aplikasi',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: 'Poppinss'),
                                        ),
                                      ],
                                    ),
                                    Icon(
                                      Icons.navigate_next,
                                      size: 22,
                                      color: Colors.black,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20),
                              //4
                              InkWell(
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return PasswordNiagaPage();
                                  }));
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset(
                                          'assets/password profil.png',
                                        ),
                                        Text(
                                          ' Ubah Password',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: 'Poppinss'),
                                        ),
                                      ],
                                    ),
                                    Icon(
                                      Icons.navigate_next,
                                      size: 22,
                                      color: Colors.black,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ]),
            );
          }),
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
                    // width: 12,
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
              onTap: _onItemTapped,
            ),
          ));
    });
  }

  infoProfil() {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 100),
      child: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              //1
              InkWell(
                onTap: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) {
                    return SettingAkunNiagaPage();
                  }));
                },
                child: Row(
                  children: [
                    Image.asset(
                      'assets/orang icon.png',
                    ),
                    Text(
                      ' Profil Saya',
                      style: TextStyle(fontSize: 12, fontFamily: 'Poppinss'),
                    ),
                  ],
                ),
              ),
              //2
              GestureDetector(
                onTap: () {
                  logOut(context);
                },
                child: Row(
                  children: [
                    Image.asset(
                      'assets/logout icon profil.png',
                    ),
                    Text(
                      ' Log Out',
                      style: TextStyle(fontSize: 12, fontFamily: 'Poppinss'),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
