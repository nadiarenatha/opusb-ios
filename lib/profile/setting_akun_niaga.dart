import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:niaga_apps_mobile/profile/profil_niaga.dart';
import '../Invoice/menu_invoice_niaga.dart';
import '../cubit/niaga/data_login_cubit.dart';
import '../model/data_login.dart';
import '../order/menu_order_niaga.dart';
import '../screen-niaga/home_niaga.dart';
import '../shared/constants.dart';
import '../shared/functions/flutter_secure_storage.dart';
import '../tracking/menu_tracking_niaga.dart';
import 'edit_akun_niaga.dart';

class SettingAkunNiagaPage extends StatefulWidget {
  const SettingAkunNiagaPage({Key? key}) : super(key: key);

  @override
  State<SettingAkunNiagaPage> createState() => _SettingAkunNiagaPageState();
}

class _SettingAkunNiagaPageState extends State<SettingAkunNiagaPage> {
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
  TextEditingController nikController = TextEditingController();

  DataLoginAccesses? dataLogin;

  //untuk BottomNavigationBarItem
  static List<Widget> _widgetOptions = <Widget>[
    MenuOrderNiagaPage(),
    MenuTrackingNiagaPage(resiNumber: 'your_resi_number_here'),
    HomeNiagaPage(),
    MenuInvoiceNiagaPage(),
    ProfileNiagaPage(),
  ];

  void _onItemTapped(int index) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => _widgetOptions[index]),
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchAndLoginUser();
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

  Future<bool> _onWillPop() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeNiagaPage(initialIndex: 4)),
    );
    return false; // Prevent default back navigation
  }

  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return WillPopScope(
      //WillPopScope: Catches the back button press from the phone's navigation bar.
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(
            0.07 * MediaQuery.of(context).size.height,
          ),
          child: AppBar(
            backgroundColor: Colors.white,
            //untuk ubah warna back color di My Invoice
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              onPressed: () {
                // Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomeNiagaPage(initialIndex: 4)),
                );
              },
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "Data Personal",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.red[900],
                        fontFamily: 'Poppins Extra Bold'),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            toolbarHeight: 0.07 * MediaQuery.of(context).size.height,
          ),
        ),
        body: BlocConsumer<DataLoginCubit, DataLoginState>(
            listener: (context, state) async {
          if (state is DataLoginSuccess) {
            setState(() {
              dataLogin = state.response;
            });
            print(
                'Ini Data nya yang akan di ambil di halaman profil : $dataLogin');
          }
        }, builder: (context, state) {
          if (state is DataLoginInProgress) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.amber[600],
              ),
            );
          }
          return Container(
            color: Colors.grey[200],
            height: screenSize.height,
            child: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color:
                      Colors.white, // White background color for the container
                  borderRadius:
                      BorderRadius.circular(15), // Circular border radius
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: Colors.grey.withOpacity(0.5),
                  //     spreadRadius: 2,
                  //     blurRadius: 5,
                  //     offset: Offset(0, 3),
                  //   ),
                  // ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                              icon: Icon(
                                Icons.edit,
                                color: Colors.red[900],
                              ),
                              onPressed: () {
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(builder: (context) {
                                  return EditAkunNiagaPage();
                                }));
                              }),
                        ],
                      ),
                      Text(
                        'Nama Perusahaan/Perorangan',
                        style:
                            TextStyle(fontSize: 13, fontFamily: 'Poppins Med'),
                      ),
                      SizedBox(height: 8),
                      Container(
                        width: screenSize.width,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              // 'PT Adikrasa Mitrajaya',
                              dataLogin?.lastName ?? '',
                              style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                  fontFamily: 'Poppins Regular'),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      Text(
                        'Email',
                        style:
                            TextStyle(fontSize: 13, fontFamily: 'Poppins Med'),
                      ),
                      SizedBox(height: 8),
                      Container(
                        width: screenSize.width,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              // 'adikrasamitrajaya@gmail.com',
                              dataLogin?.email ?? '',
                              style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                  fontFamily: 'Poppins Regular'),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      Text(
                        'Nama PIC',
                        style:
                            TextStyle(fontSize: 13, fontFamily: 'Poppins Med'),
                      ),
                      SizedBox(height: 8),
                      Container(
                        width: screenSize.width,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              // 'Jln.Kenangan Selatan No.77, RT.02, RW.03 Kecamatan Penjaringan , Jakarta Utara',
                              dataLogin?.picName ?? '',
                              style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                  fontFamily: 'Poppins Regular'),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      Text(
                        'Alamat',
                        style:
                            TextStyle(fontSize: 13, fontFamily: 'Poppins Med'),
                      ),
                      SizedBox(height: 8),
                      Container(
                        width: screenSize.width,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              // 'Jln.Kenangan Selatan No.77, RT.02, RW.03 Kecamatan Penjaringan , Jakarta Utara',
                              dataLogin?.address ?? '',
                              style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                  fontFamily: 'Poppins Regular'),
                              maxLines: null,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      Text(
                        'Kota',
                        style:
                            TextStyle(fontSize: 13, fontFamily: 'Poppins Med'),
                      ),
                      SizedBox(height: 8),
                      Container(
                        width: screenSize.width,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              // 'Surabaya',
                              dataLogin?.city ?? '',
                              style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                  fontFamily: 'Poppins Regular'),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      Text(
                        'No Telp',
                        style:
                            TextStyle(fontSize: 13, fontFamily: 'Poppins Med'),
                      ),
                      SizedBox(height: 8),
                      Container(
                        width: screenSize.width,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              // '+62813445678902',
                              dataLogin?.phone ?? '',
                              style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                  fontFamily: 'Poppins Regular'),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      Text(
                        'NIK/NPWP',
                        style:
                            TextStyle(fontSize: 13, fontFamily: 'Poppins Med'),
                      ),
                      SizedBox(height: 8),
                      //NPWP
                      if (dataLogin?.npwp?.isNotEmpty == true)
                        Container(
                          width: screenSize.width,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                dataLogin?.npwp ?? '',
                                style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                    fontFamily: 'Poppins Regular'),
                              ),
                            ),
                          ),
                        ),
                      //NIK
                      if (dataLogin?.nik?.isNotEmpty == true)
                        Container(
                          width: screenSize.width,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                dataLogin?.nik ?? '',
                                style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                    fontFamily: 'Poppins Regular'),
                              ),
                            ),
                          ),
                        ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
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
        //     items: <BottomNavigationBarItem>[
        //       const BottomNavigationBarItem(
        //         icon: Icon(
        //           Icons.dashboard,
        //           size: 27,
        //         ),
        //         label: 'Order',
        //       ),
        //       const BottomNavigationBarItem(
        //         icon: SizedBox(
        //           width: 23,
        //           child: ImageIcon(
        //             AssetImage('assets/tracking icon.png'),
        //           ),
        //         ),
        //         label: 'Tracking',
        //       ),
        //       BottomNavigationBarItem(
        //         icon: Stack(
        //           alignment:
        //               Alignment.center, // Centers the icon inside the circle
        //           children: <Widget>[
        //             Container(
        //               height: 50, // Adjust size of the circle
        //               width: 50,
        //               decoration: BoxDecoration(
        //                 color: Colors.red[900], // Red circle color
        //                 shape: BoxShape.circle,
        //               ),
        //             ),
        //             Icon(
        //               Icons.home,
        //               size: 28,
        //               color:
        //                   Colors.white, // Icon color (optional for visibility)
        //             ),
        //           ],
        //         ),
        //         label: '',
        //       ),
        //       const BottomNavigationBarItem(
        //         icon: SizedBox(
        //           width: 23,
        //           child: ImageIcon(
        //             AssetImage('assets/invoice icon.png'),
        //           ),
        //         ),
        //         label: 'Invoice',
        //       ),
        //       const BottomNavigationBarItem(
        //         icon: Icon(
        //           Icons.person,
        //           size: 27,
        //         ),
        //         label: 'Profil',
        //       ),
        //     ],
        //     currentIndex: _selectedIndex,
        //     selectedItemColor: Colors.grey[600],
        //     onTap: _onItemTapped,
        //   ),
        // )
      ),
    );
  }
}
