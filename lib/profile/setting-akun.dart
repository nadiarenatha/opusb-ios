import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:niaga_apps_mobile/screen/dahboard.dart';
import 'package:niaga_apps_mobile/screen/home.dart';
import 'package:niaga_apps_mobile/screen/profile.dart';

class SettingAkunPage extends StatefulWidget {
  const SettingAkunPage({Key? key}) : super(key: key);

  @override
  State<SettingAkunPage> createState() => _SettingAkunPageState();
}

class _SettingAkunPageState extends State<SettingAkunPage> {
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

  //untuk BottomNavigationBarItem
  static List<Widget> _widgetOptions = <Widget>[
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
          //untuk setting letak dan warna tulisan customer feedback
          flexibleSpace: Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.only(left: 46, top: 52),
            child: Row(
              children: [
                Text(
                  "Pengaturan Akun",
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.red[900],
                      fontFamily: 'Poppin',
                      fontWeight: FontWeight.w900),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: IntrinsicHeight(
          child: Container(
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
            child: Padding(
              padding: const EdgeInsets.all(20.0),
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
                      Row(
                        children: [
                          Image.asset(
                            'assets/Profile.png', // Update with the correct path to your image
                            fit: BoxFit.cover,
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.topRight,
                              child: IconButton(
                                  icon: Icon(
                                    Icons.edit,
                                    color: Colors.black,
                                  ),
                                  onPressed: () {}),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 30),
                      //untuk nama perusahaan
                      Text(
                        'Nama Perusahaan/Perorangan',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 8),
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
                          controller: emailPerusahaanController,
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
                      SizedBox(height: 20),
                      //alamat
                      Text(
                        'Alamat',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 8),
                      //alamat +isi
                      Container(
                        // width: 320,
                        width: mediaQuery.size.width,
                        height: 90,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        //untuk tulisan PT Adikrasa (Nama perusahaan)
                        child: TextFormField(
                          controller: alamatController,
                          textInputAction: TextInputAction.next,
                          maxLines: 4,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText:
                                  "Jln.Kenangan Selatan No.77, RT.02, RW.03 Kecamatan Penjaringan , Jakarta Utara",
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
                      SizedBox(height: 20),
                      //kota
                      Text(
                        'Kota',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 8),
                      //kota+isi
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
                          controller: kotaController,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Surabaya",
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
                      //no telp
                      SizedBox(height: 20),
                      //untuk telp
                      Text(
                        'No Telp',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 8),
                      //no telp + isi
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
                          controller: telpController,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "+62813445678902",
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
                      //no fax
                      SizedBox(height: 20),
                      //untuk fax
                      Text(
                        'No Fax',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 8),
                      //no fax + isi
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
                          controller: faxController,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "0984466781",
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
                      //npwp
                      SizedBox(height: 20),
                      //untuk npwp
                      Text(
                        'NPWP',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 8),
                      //npwp + isi
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
                          controller: npwpController,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "7789653477009812",
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
                      SizedBox(height: 20),
                      //untuk email
                      Text(
                        'Email',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 8),
                      //container + isi nya email
                      Container(
                        // width: 320,
                        // width: mediaQuery.size.width,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        //untuk tulisan PT Adikrasa (Nama perusahaan)
                        child: TextFormField(
                          controller: emailController,
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
                              onPressed: () {
                                String email = emailController.text;
                                String emailperusahaan =
                                    emailPerusahaanController.text;
                                String alamat = alamatController.text;
                                String kota = kotaController.text;
                                String telp = telpController.text;
                                String fax = faxController.text;
                                String npwp = npwpController.text;
                              },
                              child: Text(
                                'Simpan',
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
          ),
        ),
        //   ],
        // ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        //warna merah jika icon di pilih
        selectedItemColor: Colors.red[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
