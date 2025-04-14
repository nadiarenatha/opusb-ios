import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:niaga_apps_mobile/login/login_body.dart';
import '../Invoice/my_invoice_niaga.dart';
import '../cubit/niaga/barang_dashboard_cubit.dart';
import '../cubit/niaga/data_login_cubit.dart';
// import '../keterangan-data/data_kosong.dart';
import '../cubit/niaga/log_out_cubit.dart';
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
import '../profile/setting_akun_niaga.dart';
import '../shared/constants.dart';
import '../shared/functions/flutter_secure_storage.dart';
import '../stok-barang-gudang/stok_barang_niaga.dart';
import 'home_niaga.dart';

class ProfileNiagaHomePage extends StatefulWidget {
  const ProfileNiagaHomePage({Key? key}) : super(key: key);

  @override
  State<ProfileNiagaHomePage> createState() => _ProfileNiagaHomePageState();
}

class _ProfileNiagaHomePageState extends State<ProfileNiagaHomePage> {
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
    _clearAssigner();
    // context.read<BarangDashboardCubit>().barangDashboard();
    BlocProvider.of<BarangDashboardCubit>(context).barangDashboard();
    BlocProvider.of<BarangDashboardCubit>(context).logBarangGudangDashboard();
    BlocProvider.of<BarangDashboardCubit>(context).invoiceSummary();
    BlocProvider.of<BarangDashboardCubit>(context).logInvoiceDashboard();
  }

  Future<void> _clearAssigner() async {
    final storage = FlutterSecureStorage();
    await storage.write(
      key: AuthKey.assigner.toString(),
      value: 'false',
      aOptions: const AndroidOptions(
        encryptedSharedPreferences: true,
      ),
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
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () async {
                      clearLocalStorage();
                      await storage.delete(
                        key: AuthKey.niagaToken.toString(),
                        aOptions: const AndroidOptions(
                          encryptedSharedPreferences: true,
                        ),
                      );

                      final updatedData = {
                        "id": dataLogin?.userId,
                        "active": dataLogin?.active ?? "",
                        "phone": dataLogin?.phone,
                        "city": dataLogin?.city ?? "",
                        "nik": dataLogin?.nik ?? "",
                        "address": dataLogin?.address ?? "",
                        "position": dataLogin?.position ?? "",
                        "employee": dataLogin?.employee ?? "",
                        "waVerified": dataLogin?.waVerified ?? "",
                        "failedLoginCount": dataLogin?.failedLoginCount ?? "",
                        "concurrentUserAccess":
                            dataLogin?.concurrentUserAccess ?? "",
                        "lastLoginDate": dataLogin?.lastLoginDate ?? "",
                        "userId": dataLogin?.userId ?? "",
                        "userLogin": dataLogin?.email ?? "",
                        "firstName": "",
                        "lastName": dataLogin?.lastName ?? "",
                        "email": dataLogin?.email ?? "",
                        "adOrganizationId": dataLogin?.adOrganizationId ?? "",
                        "adOrganizationName":
                            dataLogin?.adOrganizationName ?? "",
                        "name": "",
                        "businessUnit": dataLogin?.businessUnit ?? "",
                        "entitas": dataLogin?.entitas ?? "",
                        "ownerCode": dataLogin?.ownerCode ?? "",
                        "picName": dataLogin?.picName,
                        "contractFlag": dataLogin?.contractFlag ?? "",
                        "npwp": dataLogin?.npwp ?? "",
                        "assigner": false,
                      };

                      context.read<DataLoginCubit>().updateDataLogin(
                            updatedData["id"] as int,
                            updatedData["active"] as bool,
                            updatedData["phone"] as String,
                            updatedData["city"] as String,
                            updatedData["nik"] as String? ?? "",
                            updatedData["address"] as String,
                            updatedData["position"] as String,
                            updatedData["employee"] as bool,
                            updatedData["failedLoginCount"] as int,
                            updatedData["concurrentUserAccess"] as int,
                            updatedData["lastLoginDate"] as String,
                            updatedData["userId"] as int,
                            updatedData["userLogin"] as String,
                            updatedData["firstName"] as String,
                            updatedData["lastName"] as String,
                            updatedData["email"] as String,
                            updatedData["adOrganizationId"] as int,
                            updatedData["adOrganizationName"] as String,
                            updatedData["name"] as String,
                            updatedData["businessUnit"] as String,
                            updatedData["entitas"] as String,
                            updatedData["ownerCode"] as String,
                            updatedData["picName"] as String,
                            updatedData["waVerified"] as bool,
                            updatedData["contractFlag"]
                                as bool, // Ensure contractFlag is treated as String
                            updatedData["npwp"] as String? ?? "",
                            updatedData["assigner"] as bool,
                          );

                      BlocProvider.of<LogOutCubit>(context).logOutApp();
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => LoginBody()),
                        (Route<dynamic> route) => false,
                      );
                    },
                    child: Text(
                      "Ya",
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Poppins Med',
                          fontWeight: FontWeight.w800),
                    ),
                  ),
                  SizedBox(width: 10),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: Text(
                      "Tidak",
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Poppins Med',
                          fontWeight: FontWeight.w800),
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

  Future<bool> _onWillPop() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeNiagaPage()),
    );
    return false; // Prevent default back navigation
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
      bool isLoading = state is DataLoginInProgress;
      return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
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
                  padding:
                      const EdgeInsets.only(left: 20.0, top: 32, right: 10),
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
                              dataLogin?.lastName ?? '',
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
                        onTap: isLoading
                            ? null
                            : () {
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
            body: Stack(
              children: [
                BlocConsumer<BarangDashboardCubit, BarangDashboardState>(
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
                                                          height:
                                                              50, // Frame height
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
                                            color:
                                                Color.fromARGB(255, 204, 136, 136),
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
                                                    // '${invoiceSummary?.formattedTotalTagihan ?? 'Rp0,00'}',
                                                    '${invoiceSummary?.formattedTotalTagihan ?? 'Rp0'}',
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
                                                          height:
                                                              50, // Frame height
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
                                            color:
                                                Color.fromARGB(255, 204, 136, 136),
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
                                                  barangDalamPerjalananLCL
                                                          .isNotEmpty
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
                                                          height:
                                                              50, // Frame height
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
                                            color:
                                                Color.fromARGB(255, 204, 136, 136),
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
                                                  barangDalamPerjalananFCL
                                                          .isNotEmpty
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
                                                          height:
                                                              50, // Frame height
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
                                          Navigator.push(context,
                                              MaterialPageRoute(builder: (context) {
                                            return DaftarPembayaranNiagaPage();
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
                                            // return PencarianBarangNiagaPage();
                                            return PackingTrackingListNiagaPage();
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
                                                // 'assets/pencarian profil.png',
                                                'assets/Packing-List.png',
                                                width: 26, // Adjust size as needed
                                                height: 26,
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            Column(
                                              children: [
                                                Text(
                                                  // 'Pencarian',
                                                  'Packing',
                                                  style: TextStyle(
                                                      fontSize: 11,
                                                      fontFamily: 'Poppins Med'),
                                                ),
                                                Text(
                                                  // 'Barang',
                                                  'List',
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
                if (isLoading)
                  Center(
                    child: CircularProgressIndicator(),
                  ),
              ],
            )),
      );
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
