import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:niaga_apps_mobile/screen/dahboard.dart';
import 'package:niaga_apps_mobile/screen/home.dart';
import 'package:niaga_apps_mobile/screen/profile.dart';

import '../screen-niaga/home_screen_niaga.dart';
import '../screen-niaga/invoice_home_niaga.dart';
import '../screen-niaga/order_niaga.dart';
import '../screen-niaga/tracking_home_niaga.dart';

class CustomerFeedbackNiagaPage extends StatefulWidget {
  const CustomerFeedbackNiagaPage({Key? key}) : super(key: key);

  @override
  State<CustomerFeedbackNiagaPage> createState() =>
      _CustomerFeedbackNiagaPageState();
}

class _CustomerFeedbackNiagaPageState extends State<CustomerFeedbackNiagaPage> {
  @override

  //untuk BottomNavigationBarItem
  int _selectedIndex = 0;

  //untuk BottomNavigationBarItem
  // static List<Widget> _widgetOptions = <Widget>[
  //   OrderHomeNiagaPage(),
  //   TrackingHomeNiagaPage(resiNumber: 'your_resi_number_here'),
  //   HomePageScreenNiaga(qrResult: null, resiNumber: 'masukkan nomor resi'),
  //   MyInvoiceHomeNiagaPage(),
  //   ProfilePage(),
  // ];

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
    final mediaQuery = MediaQuery.of(context);

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
                  "Customer Feedback",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.red[900],
                    fontFamily: 'Poppin',
                    fontWeight: FontWeight.w900,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          toolbarHeight: 0.07 * MediaQuery.of(context).size.height,
        ),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            //untuk container grey
            Container(
              height: mediaQuery.size.height * 0.82,
              width: mediaQuery.size.width,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                // borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFFB0BEC5), // A color close to grey[350]
                    offset: Offset(0, 6),
                    blurRadius: 10,
                    spreadRadius: 1,
                  )
                ],
              ),
            ),
            //untuk container white inside grey container
            Positioned(
              top: 30,
              left: 30,
              right: 30,
              bottom: 30,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFFB0BEC5), // A color close to grey[350]
                      offset: Offset(0, 6),
                      blurRadius: 10,
                      spreadRadius: 1,
                    )
                  ],
                ),
                //untuk logo profile
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        'assets/Profile.png', // Update with the correct path to your image
                        fit: BoxFit.cover,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      //untuk nama perusahaan
                      Text(
                        'Nama Perusahaan/Perorangan',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      //container + isi nya nama perusahaan
                      Container(
                        // width: 320,
                        width: mediaQuery.size.width,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        //untuk tulisan PT Adikrasa (Nama perusahaan)
                        child: TextFormField(
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Masukkan email Anda",
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 15.0),
                              fillColor: Colors.grey[600],
                              labelStyle: TextStyle(fontFamily: 'Montserrat')),
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14.0,
                              fontFamily: 'Montserrat'),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      //untuk email
                      Text(
                        'Email',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      //container + isi nya email
                      Container(
                        // width: 320,
                        width: mediaQuery.size.width,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        //untuk tulisan PT Adikrasa (Nama perusahaan)
                        child: TextFormField(
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "adikrasamitrajaya@gmail.com",
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 15.0),
                              fillColor: Colors.grey[600],
                              labelStyle: TextStyle(fontFamily: 'Montserrat')),
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14.0,
                              fontFamily: 'Montserrat'),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      //untuk masukan dan saran
                      Text(
                        'Masukan dan Saran',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      //container + isi nya masukan dan saran
                      Container(
                        // width: 320,
                        width: mediaQuery.size.width,
                        height: 180,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        //untuk tulisan PT Adikrasa (Nama perusahaan)
                        child: TextFormField(
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "",
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 15.0),
                              fillColor: Colors.grey[600],
                              labelStyle: TextStyle(fontFamily: 'Montserrat')),
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14.0,
                              fontFamily: 'Montserrat'),
                        ),
                      ),
                      //button kirim
                      SizedBox(height: 20),
                      //jika pakai expanded posisi tombol akan di kanan bawah
                      Expanded(
                        //jika pakai alignment bottom right posisi di kanan
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: Material(
                            borderRadius: BorderRadius.circular(7.0),
                            color: Colors.red[900],
                            //membuat bayangan pada button kirim
                            shadowColor: Colors.grey[350],
                            elevation: 5,
                            child: MaterialButton(
                              onPressed: () {},
                              child: Text(
                                'Kirim',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
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
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.dashboard), label: 'Order'),
            BottomNavigationBarItem(
              icon: SizedBox(
                width: 20,
                child: ImageIcon(
                  AssetImage('assets/tracking icon.png'),
                ),
              ),
              label: 'Tracking',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
              icon: SizedBox(
                width: 12,
                child: ImageIcon(
                  AssetImage('assets/invoice icon.png'),
                ),
              ),
              label: 'Invoice',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.grey[600],
          // unselectedItemColor: Colors.grey[600],
          // onTap: _onItemTapped,
        ),
      ),
    );
  }
}
