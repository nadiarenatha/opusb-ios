import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:niaga_apps_mobile/pemesanan/detail_barang.dart';
import 'package:niaga_apps_mobile/screen/profile.dart';

import '../screen-niaga/home_niaga.dart';
import '../screen-niaga/home_screen_niaga.dart';
import '../screen-niaga/invoice_home_niaga.dart';
import '../screen-niaga/order_niaga.dart';
import '../screen-niaga/tracking_home_niaga.dart';
import '../shared/constants.dart';
// import 'package:google_maps_webservice/places.dart';
// import 'package:location/location.dart';

class NotifFCL extends StatefulWidget {
  final String? orderNumber;
  // const NotifFCL({super.key});
  const NotifFCL({Key? key, required this.orderNumber}) : super(key: key);

  @override
  State<NotifFCL> createState() => _NotifFCLState();
}

class _NotifFCLState extends State<NotifFCL> {
  int _selectedIndex = 0;
  bool isSelected = false;
  //check list box
  bool _isChecked = false;

  void dispose() {
    // _namaPengirimController.dispose();
    super.dispose();
  }

  // static List<Widget> _widgetOptions = <Widget>[
  //   OrderHomeNiagaPage(),
  //   TrackingHomeNiagaPage(resiNumber: 'your_resi_number_here'),
  //   HomePageScreenNiaga(qrResult: null, resiNumber: 'masukkan nomor resi'),
  //   MyInvoiceHomeNiagaPage(),
  //   ProfilePage(),
  // ];

  @override
  void initState() {
    super.initState();
  }

  // void _onItemTapped(int index) {
  //   Navigator.pushReplacement(
  //     context,
  //     MaterialPageRoute(builder: (context) => _widgetOptions[index]),
  //   );
  // }

  Future<bool> _onWillPop() async {
    await setAssignerFalse();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeNiagaPage()),
    );
    return false; // Prevent default back navigation
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(
            0.08 * MediaQuery.of(context).size.height,
          ),
          child: AppBar(
            backgroundColor: Colors.white,
            //untuk ubah warna back color di My Invoice
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              onPressed: () async{
                // Navigator.of(context).pop();
                await setAssignerFalse();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomeNiagaPage()),
                );
              },
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(height: 10),
                Text(
                  "Pemesanan FCL",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.red[900],
                      fontFamily: 'Poppins Extra Bold'),
                ),
                // ),
                SizedBox(height: 10),
              ],
            ),
            //agar tulisan di appbar berada di tengah tinggi bar
            toolbarHeight: 0.08 * MediaQuery.of(context).size.height,
          ),
        ),
        body: Container(
          height: screenSize.height,
          width: screenSize.width,
          color: Colors.white,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      Center(child: Image.asset('assets/konfirmasi order.png')),
                      SizedBox(height: 20),
                      Center(
                        child: Text(
                          'Pesanan Berhasil Dibuat',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontFamily: 'Poppinss'),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 10),
                      Center(
                        child: Text(
                          // 'COSL/SBY/2024.08/001332/OL',
                          widget.orderNumber ?? '',
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Poppins Reg',
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 25),
                      Text(
                        'Menunggu Konfirmasi Admin',
                        style: TextStyle(
                          color: Colors.orange[400],
                          fontSize: 20,
                          fontFamily: 'Poppins Reg',
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 25),
                      Text(
                        'Konfirmasi oleh Admin akan dilakukan hanya pada saat hari dan jam Kerja',
                        style: TextStyle(
                          color: Colors.red[600],
                          fontSize: 15,
                          fontFamily: 'Poppins Reg',
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10),
                      Text(
                        '(Senin - Jumat pukul 08.00 - 16.00 dan Sabtu pukul 08.00 -13.00)',
                        style: TextStyle(
                          color: Colors.red[600],
                          fontSize: 15,
                          fontFamily: 'Poppins Reg',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40),
                Center(
                  child: SizedBox(
                    width: 130,
                    height: 40,
                    child: Material(
                      borderRadius: BorderRadius.circular(7.0),
                      color: Colors.white,
                      // shadowColor: Colors.grey[350],
                      // elevation: 5,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          minimumSize: Size(200, 50),
                          side: BorderSide(color: Colors.red[900]!, width: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7.0),
                          ),
                          backgroundColor: Colors.white,
                        ),
                        onPressed: () async {
                          await setAssignerFalse();
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) {
                            return HomeNiagaPage();
                          }));
                        },
                        child: Text(
                          'Kembali',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.red[900],
                            fontFamily: 'Poppins Med',
                          ),
                        ),
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
  }
  
  setAssignerFalse() async{
    final storage = FlutterSecureStorage();
    await storage.write(
      key: AuthKey.assigner.toString(),
      value: 'false',
      aOptions: const AndroidOptions(
        encryptedSharedPreferences: true,
      ),
    );
  }
}
