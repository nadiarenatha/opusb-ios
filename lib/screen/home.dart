// import 'dart:js';
import 'package:flutter/material.dart';
import 'package:niaga_apps_mobile/login/login_body.dart';
import 'package:niaga_apps_mobile/screen/dahboard.dart';
import 'package:niaga_apps_mobile/screen/home_screen.dart';
import 'package:niaga_apps_mobile/screen/invoice_home.dart';
import 'package:niaga_apps_mobile/screen/profile.dart';
import 'package:niaga_apps_mobile/screen/tracking_home.dart';

class HomePage extends StatefulWidget {
  // final int index;
  const HomePage({
    Key? key,
    // this.index,s
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  //untuk set navigasi bar dashboard, home, profile
  int _selectedIndex = 2;
  // int _selectedIndex = widget.;
  bool isSelected = false;

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

  //untuk BottomNavigationBarItem
  static List<Widget> _widgetOptions = <Widget>[
    MyInvoiceHomePage(),
    DashboardPage(),
    // HomePageScreen(),
    //untuk navigate ke hlmn tracking
    HomePageScreen(qrResult: null, resiNumber: 'masukkan nomor resi'),
    TrackingHomePage(),
    ProfilePage(),
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
    return Scaffold(
      appBar: _selectedIndex == 0 ||
              _selectedIndex == 1 ||
              _selectedIndex == 3 ||
              _selectedIndex == 4
          ? null
          : PreferredSize(
              preferredSize: Size.fromHeight(
                0.07 * MediaQuery.of(context).size.height,
              ),
              child: AppBar(
                backgroundColor: Colors.white,
                flexibleSpace: Container(
                  alignment: Alignment.bottomLeft,
                  // padding: EdgeInsets.only(left: 16, bottom: 15),
                  child:
                      // _selectedIndex == 0
                      //     ? MyInvoicePage()
                      // _selectedIndex == 1
                      //     ? Padding(
                      //         padding: EdgeInsets.only(left: 16, bottom: 15),
                      //         child: Text(
                      //           'Dashboard',
                      //           style: TextStyle(
                      //               fontSize: 20,
                      //               color: Colors.red[900],
                      //               fontFamily: 'Poppin',
                      //               fontWeight: FontWeight.w900),
                      //         ),
                      //       )
                      // :
                      _selectedIndex == 2
                          ?
                          // Padding(
                          //     padding: EdgeInsets.only(left: 16, bottom: 15),
                          //     child:
                          Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'PT Adikrasa Mitrajaya',
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.black,
                                        fontFamily: 'Poppin',
                                        fontWeight: FontWeight.w900),
                                  ),
                                ],
                              ),
                            )
                          // )
                          // : _selectedIndex == 3
                          //     ? TrackingHomePage()
                          // : _selectedIndex == 4
                          //     ? Padding(
                          //         padding: EdgeInsets.only(left: 16, bottom: 5),
                          //         child: Row(
                          //           mainAxisAlignment:
                          //               MainAxisAlignment.spaceBetween,
                          //           children: [
                          //             Text(
                          //               'Profile',
                          //               style: TextStyle(
                          //                   fontSize: 20,
                          //                   color: Colors.red[900],
                          //                   fontFamily: 'Poppin',
                          //                   fontWeight: FontWeight.w900),
                          //             ),
                          //             IconButton(
                          //                 icon: Icon(
                          //                   Icons.logout,
                          //                   color: Colors.black,
                          //                 ),
                          //                 onPressed: () {
                          //                   logOut(context);
                          //                 }),
                          //           ],
                          //         ),
                          //       )
                          : SizedBox(), // Use SizedBox to avoid rendering an empty Container
                ),
                leading: Container(),
              ),
            ),
      body: _widgetOptions[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        // Set type to fixed for centered labels
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Order'),
          BottomNavigationBarItem(
              icon: SizedBox(
                width: 20,
                child: ImageIcon(
                  AssetImage('assets/tracking icon.png'),
                ),
              ),
              label: 'Tracking'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: SizedBox(
                width: 12,
                child: ImageIcon(
                  AssetImage('assets/invoice icon.png'),
                ),
              ),
              label: 'Invoice'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.red[900],
        unselectedItemColor: Colors.grey[600],
        onTap: _onItemTapped,
      ),
    );
  }
}
