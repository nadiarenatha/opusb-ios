import 'package:flutter/material.dart';
import 'package:niaga_apps_mobile/profile/profil_niaga.dart';
import '../Invoice/menu_invoice_niaga.dart';
import '../order/menu_order_niaga.dart';
import '../screen-niaga/home_niaga.dart';
import '../tracking/menu_tracking_niaga.dart';

class AboutAplikasiNiagaPage extends StatefulWidget {
  const AboutAplikasiNiagaPage({Key? key}) : super(key: key);

  @override
  State<AboutAplikasiNiagaPage> createState() => _AboutAplikasiNiagaPageState();
}

class _AboutAplikasiNiagaPageState extends State<AboutAplikasiNiagaPage> {
  @override

  //untuk BottomNavigationBarItem
  int _selectedIndex = 0;

  //untuk BottomNavigationBarItem
  static List<Widget> _widgetOptions = <Widget>[
    MenuOrderNiagaPage(),
    MenuTrackingNiagaPage(resiNumber: ''),
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

  //untuk BottomNavigationBarItem
  // void _onItemTapped(int index) {
  //   setState(() {
  //     _selectedIndex = index;
  //   });
  //   switch (index) {
  //     case 0:
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(builder: (context) => OrderHomeNiagaPage()),
  //       );
  //       break;
  //     case 1:
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //             builder: (context) =>
  //                 TrackingHomeNiagaPage(resiNumber: 'your_resi_number_here')),
  //       );
  //       break;
  //     case 2:
  //       Navigator.pop(
  //         context,
  //         MaterialPageRoute(
  //             builder: (context) => HomePageScreenNiaga(
  //                 qrResult: null, resiNumber: 'masukkan nomor resi')),
  //       );
  //       break;
  //     case 3:
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(builder: (context) => MyInvoiceHomeNiagaPage()),
  //       );
  //       break;
  //     case 4:
  //       Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(builder: (context) => ProfilePage()),
  //       );
  //       break;
  //   }
  // }

  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
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
                Navigator.of(context).pop();
              },
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "Tentang Aplikasi",
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
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'About Niaga Apps',
                  style: TextStyle(fontSize: 16, fontFamily: 'Poppins Bold'),
                ),
                SizedBox(height: 20),
                Text(
                  'VER 1.0.0',
                  style: TextStyle(fontSize: 12, fontFamily: 'Poppins Med'),
                  textAlign: TextAlign.justify,
                ),
                SizedBox(height: 15),
                Text(
                  'Build 1.0.0',
                  style: TextStyle(fontSize: 12, fontFamily: 'Poppins Med'),
                  textAlign: TextAlign.justify,
                ),
                SizedBox(height: 15),
                Text(
                  'Copyright 2024 @ Niaga Logistics',
                  style: TextStyle(fontSize: 12, fontFamily: 'Poppins Med'),
                  textAlign: TextAlign.justify,
                ),
                SizedBox(height: 510),
                // Center(
                //   child: Material(
                //     borderRadius: BorderRadius.circular(7.0),
                //     color: Colors.red[900],
                //     //membuat bayangan pada button Detail
                //     shadowColor: Colors.grey[350],
                //     elevation: 5,
                //     child: MaterialButton(
                //       minWidth: 150, // Adjust the width as needed
                //       height: 45, // Adjust the height as needed
                //       onPressed: () {
                //         Navigator.of(context).pop();
                //       },
                //       child: Text(
                //         'Kembali',
                //         style: TextStyle(fontSize: 18, color: Colors.white),
                //       ),
                //     ),
                //   ),
                // ),
                Center(
                  child: SizedBox(
                    width: 150,
                    height: 35,
                    child: Material(
                      borderRadius: BorderRadius.circular(7.0),
                      color: Colors.red[900],
                      // shadowColor: Colors.grey[350],
                      // elevation: 5,
                      child: MaterialButton(
                        padding: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "Kembali",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            letterSpacing: 1.5,
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
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
        //       // BottomNavigationBarItem(
        //       //   icon: Stack(
        //       //     alignment:
        //       //         Alignment.center, // Centers the icon inside the circle
        //       //     children: <Widget>[
        //       //       Container(
        //       //         height: 40, // Adjust size of the circle
        //       //         width: 40,
        //       //         decoration: BoxDecoration(
        //       //           color: Colors.red[900], // Red circle color
        //       //           shape: BoxShape.circle,
        //       //         ),
        //       //       ),
        //       //       Icon(
        //       //         Icons.home,
        //       //         color:
        //       //             Colors.white, // Icon color (optional for visibility)
        //       //       ),
        //       //     ],
        //       //   ),
        //       //   label: 'Home',
        //       // ),
        //       BottomNavigationBarItem(
        //         icon: Stack(
        //           alignment: Alignment.center,
        //           children: <Widget>[
        //             Container(
        //               height: 50, // Adjusted size of the circle
        //               width: 50,
        //               decoration: BoxDecoration(
        //                 color: Colors.red[900], // Red circle color
        //                 shape: BoxShape.circle,
        //               ),
        //             ),
        //             Icon(
        //               Icons.home,
        //               size: 28,
        //               color: Colors.white,
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
        );
  }
}
