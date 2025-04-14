import 'package:flutter/material.dart';
import 'package:niaga_apps_mobile/login/login_body.dart';
import 'package:niaga_apps_mobile/profile/customer-feedback.dart';
import 'package:niaga_apps_mobile/profile/setting-akun.dart';
import 'package:niaga_apps_mobile/screen/dahboard.dart';
import 'package:niaga_apps_mobile/screen/home.dart';
import '../history-pengiriman/history_pengiriman.dart';
import '../history-pengiriman/history_pengiriman_niaga.dart';
import '../profile/customer-feedback_niaga.dart';
import '../profile/setting_akun_niaga.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override

  //untuk BottomNavigationBarItem
  int _selectedIndex = 0;
  //untuk calendar pada pop up dialog search dengan nama _dateController
  //2 nama berbeda karena tgl di calendar berbeda
  TextEditingController _dateController1 = TextEditingController();
  TextEditingController _dateController2 = TextEditingController();
  TextEditingController emailPerusahaanController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController alamatController = TextEditingController();
  TextEditingController kotaController = TextEditingController();
  TextEditingController telpController = TextEditingController();
  TextEditingController faxController = TextEditingController();
  TextEditingController npwpController = TextEditingController();

  //untuk BottomNavigationBarItem
  static const List<Widget> _widgetOptions = <Widget>[
    DashboardPage(),
    HomePage(),
    ProfilePage(),
  ];

  //untuk BottomNavigationBarItem
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DashboardPage()),
        );
        break;
      case 1:
        Navigator.pop(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ProfilePage()),
        );
        break;
    }
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

  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(
            0.07 * MediaQuery.of(context).size.height,
          ),
          child: AppBar(
            backgroundColor: Colors.white,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: Text(
                    "Profile",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.red[900],
                      fontFamily: 'Poppin',
                      fontWeight: FontWeight.w900,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                    icon: Icon(
                      Icons.logout,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      logOut(context);
                    }),
              ],
            ),
            //agar tulisan di appbar berada di tengah tinggi bar
            toolbarHeight: 0.07 * MediaQuery.of(context).size.height,
            leading: Container(),
          ),
        ),
        body: SingleChildScrollView(
          child:
              // Stack(
              //   children: [
              //untuk container grey
              Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              // margin: EdgeInsets.all(16),
              height: mediaQuery.size.height * 0.8,
              width: mediaQuery.size.width,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFFB0BEC5), // A color close to grey[350]
                    offset: Offset(0, 6),
                    blurRadius: 10,
                    spreadRadius: 1,
                  )
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            'assets/Profile.png', // Update with the correct path to your image
                            // fit: BoxFit.cover,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 5),
                            Text(
                              'PT Adikrasa Mitrajaya',
                              style: TextStyle(
                                  color: Colors.grey[800],
                                  fontFamily: 'Poppin',
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  //untuk italic
                                  fontStyle: FontStyle.italic),
                            ),
                            SizedBox(height: 5),
                            Text(
                              '+62813445678902',
                              style: TextStyle(
                                  color: Colors.grey[800],
                                  fontFamily: 'Poppin',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  //untuk italic
                                  fontStyle: FontStyle.italic),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'joined since 22 Februari 2024',
                              style: TextStyle(
                                  color: Colors.grey[600],
                                  fontFamily: 'Poppin',
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Container(
                      height: 4,
                      color: Colors.grey[400],
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              // builder: (context) => HistoryPengirimanPage()),
                              builder: (context) =>
                                  HistoryPengirimanNiagaPage()),
                        );
                      },
                      child: Row(
                        children: [
                          //logo history pengiriman
                          Image.asset(
                            'assets/History Pengiriman.png', // Replace 'your_image.png' with your image asset path
                            height: 80, // Adjust height as needed
                            width: 80, // Adjust width as needed
                          ),
                          Text(
                            'History Pengiriman',
                            style: TextStyle(
                                fontFamily: 'Poppin',
                                fontSize: 16,
                                fontWeight: FontWeight.w800),
                          )
                        ],
                      ),
                    ),
                    Container(
                      height: 4,
                      color: Colors.grey[400],
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          // return CustomerFeedbackPage();
                          return CustomerFeedbackNiagaPage();
                        }));
                      },
                      child: Row(
                        children: [
                          //logo Customer feedback
                          Image.asset(
                            'assets/Customer Feedback.png', // Replace 'your_image.png' with your image asset path
                            height: 80, // Adjust height as needed
                            width: 80, // Adjust width as needed
                          ),
                          Text(
                            'Customer Feedback',
                            style: TextStyle(
                                fontFamily: 'Poppin',
                                fontSize: 16,
                                fontWeight: FontWeight.w800),
                          )
                        ],
                      ),
                    ),
                    Container(
                      height: 4,
                      color: Colors.grey[400],
                    ),
                    InkWell(
                      onTap: () {
                        emailPerusahaanController.clear();
                        emailController.clear();
                        alamatController.clear();
                        kotaController.clear();
                        telpController.clear();
                        faxController.clear();
                        npwpController.clear();
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          // return SettingAkunPage();
                          return SettingAkunNiagaPage();
                        }));
                      },
                      child: Row(
                        children: [
                          //logo Customer feedback
                          Image.asset(
                            'assets/Pengaturan Akun.png', // Replace 'your_image.png' with your image asset path
                            height: 80, // Adjust height as needed
                            width: 80, // Adjust width as needed
                          ),
                          Text(
                            'Pengaturan Akun',
                            style: TextStyle(
                                fontFamily: 'Poppin',
                                fontSize: 16,
                                fontWeight: FontWeight.w800),
                          )
                        ],
                      ),
                    ),
                    Container(
                      height: 4,
                      color: Colors.grey[400],
                    ),
                  ],
                ),
              ),
            ),
          ),
          //untuk gambar profile
          // Positioned(
          //   top: 30,
          //   left: 30,
          //   child:
          // ClipRRect(
          //   borderRadius: BorderRadius.circular(20),
          //   child: Image.asset(
          //     'assets/Profile.png', // Update with the correct path to your image
          //     fit: BoxFit.cover,
          //   ),
          // ),
          // ),
          //untuk tulisan PT Adikrasa Mitrajaya
          // Positioned(
          //   top: 45,
          //   left: 140,
          //   child:
          // Column(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: [
          //     Text(
          //       'PT Adikrasa Mitrajaya',
          //       style: TextStyle(
          //           color: Colors.grey[800],
          //           fontFamily: 'Poppin',
          //           fontSize: 20,
          //           fontWeight: FontWeight.w800,
          //           //untuk italic
          //           fontStyle: FontStyle.italic),
          //     ),
          //     SizedBox(
          //       height: 3,
          //     ),
          //     Text(
          //       '+62813445678902',
          //       style: TextStyle(
          //           color: Colors.grey[800],
          //           fontFamily: 'Poppin',
          //           fontSize: 18,
          //           fontWeight: FontWeight.w400,
          //           //untuk italic
          //           fontStyle: FontStyle.italic),
          //     ),
          //     SizedBox(
          //       height: 3,
          //     ),
          //     Text(
          //       'joined since 22 Februari 2024',
          //       style: TextStyle(
          //           color: Colors.grey[600],
          //           fontFamily: 'Poppin',
          //           fontSize: 14,
          //           fontWeight: FontWeight.normal),
          //     ),
          //   ],
          // ),
          // ),
          //untuk garis abu2 1
          // Positioned(
          //   top: 135,
          //   left: 30,
          //   right: 30,
          //   child:
          // Container(
          //   height: 4,
          //   color: Colors.grey[400],
          // ),
          // ),
          //untuk history pengiriman
          // Positioned(
          //   top: 140,
          //   left: 20,
          //   child:
          // GestureDetector(
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //           builder: (context) => HistoryPengirimanPage()),
          //     );
          //   },
          //   child: Row(
          //     children: [
          //       //logo history pengiriman
          //       Image.asset(
          //         'assets/History Pengiriman.png', // Replace 'your_image.png' with your image asset path
          //         height: 80, // Adjust height as needed
          //         width: 80, // Adjust width as needed
          //       ),
          //       Text(
          //         'History Pengiriman',
          //         style: TextStyle(
          //             fontFamily: 'Poppin',
          //             fontSize: 16,
          //             fontWeight: FontWeight.w800),
          //       )
          //     ],
          //   ),
          // ),
          // ),
          //untuk garis abu2
          // Positioned(
          //   top: 220,
          //   left: 30,
          //   right: 30,
          //   child:
          // Container(
          //   height: 4,
          //   color: Colors.grey[400],
          // ),
          // ),
          //untuk customer feedback
          // Positioned(
          //   top: 225,
          //   left: 20,
          //   child:
          // InkWell(
          //   onTap: () {
          //     Navigator.push(context,
          //         MaterialPageRoute(builder: (context) {
          //       return CustomerFeedbackPage();
          //     }));
          //   },
          //   child: Row(
          //     children: [
          //       //logo Customer feedback
          //       Image.asset(
          //         'assets/Customer Feedback.png', // Replace 'your_image.png' with your image asset path
          //         height: 80, // Adjust height as needed
          //         width: 80, // Adjust width as needed
          //       ),
          //       Text(
          //         'Customer Feedback',
          //         style: TextStyle(
          //             fontFamily: 'Poppin',
          //             fontSize: 16,
          //             fontWeight: FontWeight.w800),
          //       )
          //     ],
          //   ),
          // ),
          // ),
          //untuk garis abu2
          // Positioned(
          //   top: 305,
          //   left: 30,
          //   right: 30,
          //   child: Container(
          //     height: 4,
          //     color: Colors.grey[400],
          //   ),
          // ),
          //untuk pengaturan akun
          // Positioned(
          //   top: 310,
          //   left: 20,
          //   child:
          // InkWell(
          //   onTap: () {
          //     emailPerusahaanController.clear();
          //     emailController.clear();
          //     alamatController.clear();
          //     kotaController.clear();
          //     telpController.clear();
          //     faxController.clear();
          //     npwpController.clear();
          //     Navigator.push(context,
          //         MaterialPageRoute(builder: (context) {
          //       return SettingAkunPage();
          //     }));
          //   },
          //   child: Row(
          //     children: [
          //       //logo Customer feedback
          //       Image.asset(
          //         'assets/Pengaturan Akun.png', // Replace 'your_image.png' with your image asset path
          //         height: 80, // Adjust height as needed
          //         width: 80, // Adjust width as needed
          //       ),
          //       Text(
          //         'Pengaturan Akun',
          //         style: TextStyle(
          //             fontFamily: 'Poppin',
          //             fontSize: 16,
          //             fontWeight: FontWeight.w800),
          //       )
          //     ],
          //   ),
          // ),
          // ),
          //untuk garis abu2
          // Positioned(
          //   top: 390,
          //   left: 30,
          //   right: 30,
          //   child: Container(
          //     height: 4,
          //     color: Colors.grey[400],
          //   ),
          // ),
          //   ],
          // ),
        ));
  }
}
