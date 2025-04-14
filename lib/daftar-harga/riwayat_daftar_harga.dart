import 'package:flutter/material.dart';
import 'package:niaga_apps_mobile/screen/dahboard.dart';
import 'package:niaga_apps_mobile/screen/profile.dart';
import 'package:niaga_apps_mobile/screen/home.dart';

class RiwayatDaftarHargaPage extends StatefulWidget {
  const RiwayatDaftarHargaPage({Key? key}) : super(key: key);

  @override
  State<RiwayatDaftarHargaPage> createState() => _RiwayatDaftarHargaPageState();
}

class _RiwayatDaftarHargaPageState extends State<RiwayatDaftarHargaPage> {
  @override
  //untuk BottomNavigationBarItem
  int _selectedIndex = 0;
  //untuk BottomNavigationBarItem
  bool isSelected = false;

  //untuk calendar pada pop up dialog search dengan nama _dateController
  //2 nama berbeda karena tgl di calendar berbeda
  TextEditingController _dateController1 = TextEditingController();
  TextEditingController _dateController2 = TextEditingController();

  //untuk no SJM/nama barang pada pop up dialog search
  TextEditingController _NoSJMController = TextEditingController();

  //untuk BottomNavigationBarItem
  static List<Widget> _widgetOptions = <Widget>[
    DashboardPage(),
    HomePage(),
    ProfilePage(),
  ];

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  //untuk BottomNavigationBarItem
  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DashboardPage()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
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
      default:
        break; // Adding a default case with break to handle all cases
    }
  }

  //untuk fungsi calendar pada pop up dialog search dengan nama _dateController
  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Current date
      firstDate: DateTime(2000), // The earliest date the user can pick
      lastDate: DateTime(2101), // The latest date the user can pick
    );
    if (picked != null) {
      setState(() {
        controller.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  //untuk fungsi pop up dialog search
  Future searchMyInvoice() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            //untuk memberi border melengkung
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            //untuk mengatur letak dari close icon
            titlePadding: EdgeInsets.zero,
            contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 3),
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
            content: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 900, maxWidth: 300),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "No SJM/Nama Barang",
                    style: TextStyle(color: Colors.black, fontFamily: 'Poppin'),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'masukkan no SJM/nama barang',
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Range Tanggal",
                    style: TextStyle(color: Colors.black, fontFamily: 'Poppin'),
                  ),
                  SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: TextFormField(
                      //controller 1 digunakan untuk input tgl di calendar
                      controller: _dateController1,
                      decoration: InputDecoration(
                          hintText: 'dd/mm/yyyy',
                          //untuk mengatur letak hint text
                          //horizontal ke kanan kiri
                          //vertical ke atas  bawah
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 15.0),
                          border: InputBorder.none,
                          //untuk tambah icon calendar
                          suffixIcon: IconButton(
                            icon: Icon(Icons.calendar_today),
                            onPressed: () =>
                                _selectDate(context, _dateController1),
                          )),
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: TextFormField(
                      //controller 2 digunakan untuk input tgl di calendar
                      controller: _dateController2,
                      decoration: InputDecoration(
                          hintText: 'dd/mm/yyyy',
                          //untuk mengatur letak hint text
                          //horizontal ke kanan kiri
                          //vertical ke atas  bawah
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 15.0),
                          border: InputBorder.none,
                          //untuk tambah icon calendar
                          suffixIcon: IconButton(
                            icon: Icon(Icons.calendar_today),
                            onPressed: () =>
                                _selectDate(context, _dateController2),
                          )),
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Material(
                      borderRadius: BorderRadius.circular(7.0),
                      color: Colors.red[900],
                      child: MaterialButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'Terapkan',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ));

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
          //untuk setting letak dan warna tulisan My Invoice
          // flexibleSpace: Container(
          //   alignment: Alignment.bottomLeft,
          //   padding: EdgeInsets.only(left: 45, bottom: 6),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       Text(
          //         "Daftar Harga",
          //         style: TextStyle(
          //             fontSize: 20,
          //             color: Colors.red[900],
          //             fontFamily: 'Poppin',
          //             fontWeight: FontWeight.w900),
          //       ),
          //       //untuk lingkaran & icons search
          //       Positioned(
          //         bottom: 16,
          //         left: 16,
          //         child: Container(
          //           width: 40,
          //           height: 40,
          //           decoration: BoxDecoration(
          //               color: Colors.white,
          //               // borderRadius: BorderRadius.circular(50),
          //               shape: BoxShape.circle,
          //               boxShadow: [
          //                 BoxShadow(
          //                   color:
          //                       Color(0xFFB0BEC5), // A color close to grey[350]
          //                   offset: Offset(0, 2),
          //                   blurRadius: 5,
          //                   spreadRadius: 1,
          //                 )
          //               ]),
          //           child: IconButton(
          //               icon: Icon(
          //                 Icons.search,
          //                 color: Colors.black,
          //               ),
          //               onPressed: () {
          //                 _NoSJMController.text = '';
          //                 _dateController1.text = '';
          //                 _dateController2.text = '';
          //                 searchMyInvoice();
          //               }),
          //         ),
          //       )
          //     ],
          //   ),
          // ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  "Daftar Harga",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.red[900],
                    fontFamily: 'Poppin',
                    fontWeight: FontWeight.w900,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                // width: 30,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFFB0BEC5), // A color close to grey[350]
                      offset: Offset(0, 2),
                      blurRadius: 5,
                      spreadRadius: 1,
                    )
                  ],
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                  iconSize: 24,
                  onPressed: () {
                    _NoSJMController.text = '';
                    _dateController1.text = '';
                    _dateController2.text = '';
                    searchMyInvoice();
                  },
                ),
              ),
            ],
          ),
          toolbarHeight: 0.07 * MediaQuery.of(context).size.height,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            children: [
              SizedBox(height: 40),
              Image.asset('assets/notif history pengiriman.png'),
              SizedBox(height: 50),
              Center(
                child: Text(
                  'Oops! Anda tidak memiliki Riwayat Daftar Harga!',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w900),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 15),
              Text(
                'Silahkan lakukan pemesanan online, seluruh riwayat harga anda akan tersimpan di halaman ini.',
                style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 200),
              Material(
                borderRadius: BorderRadius.circular(7.0),
                color: Colors.red[900],
                //membuat bayangan pada button Detail
                shadowColor: Colors.grey[350],
                elevation: 5,
                child: MaterialButton(
                  onPressed: () {},
                  child: Text(
                    'Pesan Sekarang',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
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
        selectedItemColor:
            isSelected == true ? Colors.red[900] : Colors.grey[600],
        onTap: _onItemTapped,
      ),
    );
  }
}
