import 'package:flutter/material.dart';
import 'package:niaga_apps_mobile/Invoice/my_invoice.dart';
import 'package:niaga_apps_mobile/daftar-harga/cari_daftar_harga.dart';
import 'package:niaga_apps_mobile/daftar-harga/riwayat_daftar_harga.dart';
import 'package:niaga_apps_mobile/screen/dahboard.dart';
import 'package:niaga_apps_mobile/screen/profile.dart';
import 'package:niaga_apps_mobile/screen/home.dart';
import 'package:niaga_apps_mobile/tracking/tracking.dart';

class DaftarHargaPage extends StatefulWidget {
  const DaftarHargaPage({Key? key}) : super(key: key);

  @override
  State<DaftarHargaPage> createState() => _DaftarHargaPageState();
}

class _DaftarHargaPageState extends State<DaftarHargaPage> {
  @override
  //untuk BottomNavigationBarItem
  int _selectedIndex = 0;
  //untuk BottomNavigationBarItem
  bool isSelected = false;

  //list harga barang
  final List<Map<String, dynamic>> daftarHarga = [
    {
      'id': 1,
      'harga': 'Rp 10.000.000',
      'kota_awal': 'Jakarta',
      'kota_tujuan': 'Surabaya',
      'jenis_pengiriman': 'FCL (Full Container Load)',
    },
    {
      'id': 2,
      'harga': 'Rp 14.000.000',
      'kota_awal': 'Jakarta',
      'kota_tujuan': 'Palangkaraya',
      'jenis_pengiriman': 'FCL (Full Container Load)',
    },
    {
      'id': 3,
      'harga': 'Rp 20.000.000',
      'kota_awal': 'Jakarta',
      'kota_tujuan': 'Manado',
      'jenis_pengiriman': 'FCL (Full Container Load)',
    },
    {
      'id': 4,
      'harga': 'Rp 5.000.000',
      'kota_awal': 'Semarang',
      'kota_tujuan': 'Makassar',
      'jenis_pengiriman': 'FCL (Full Container Load)',
    },
  ];

  //untuk calendar pada pop up dialog search dengan nama _dateController
  //2 nama berbeda karena tgl di calendar berbeda
  TextEditingController _dateController1 = TextEditingController();
  TextEditingController _dateController2 = TextEditingController();

  //untuk no SJM/nama barang pada pop up dialog search
  TextEditingController _NoSJMController = TextEditingController();

  //untuk BottomNavigationBarItem
  static List<Widget> _widgetOptions = <Widget>[
    MyInvoicePage(),
    DashboardPage(),
    HomePage(),
    TrackingPage(),
    ProfilePage(),
  ];

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  //untuk BottomNavigationBarItem
  // void _onItemTapped(int index) {
  //   switch (index) {
  //     case 0:
  //       Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(builder: (context) => DashboardPage()),
  //       );
  //       break;
  //     case 1:
  //       Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(builder: (context) => HomePage()),
  //       );
  //       break;
  //     case 2:
  //       Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(builder: (context) => ProfilePage()),
  //       );
  //       break;
  //     default:
  //       break; // Adding a default case with break to handle all cases
  //   }
  // }

  void _onItemTapped(int index) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => _widgetOptions[index]),
    );
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
          //agar tulisan di appbar berada di tengah tinggi bar
          toolbarHeight: 0.07 * MediaQuery.of(context).size.height,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
                shrinkWrap: true,
                // physics: NeverScrollableScrollPhysics() untuk scroll list view builder
                //In the context of your code, NeverScrollableScrollPhysics is used within the ListView.builder. This means that even if the content exceeds the available space, the list will not scroll.
                physics: NeverScrollableScrollPhysics(),
                // physics: AlwaysScrollableScrollPhysics(),
                itemCount: daftarHarga.length,
                controller: ScrollController(),
                itemBuilder: (context, index) {
                  var item = daftarHarga[index];

                  //jika container di klik dr false akan berubah menjadi true
                  return Container(
                    margin: EdgeInsets.all(18),
                    //setting tinggi & lebar container grey
                    height: mediaQuery.size.height * 0.25,
                    width: mediaQuery.size.height * 0.5,
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color:
                                Color(0xFFB0BEC5), // A color close to grey[350]
                            offset: Offset(0, 6),
                            blurRadius: 10,
                            spreadRadius: 1,
                          )
                        ]),
                    //untuk form
                    child: Stack(
                      children: [
                        // Main content
                        Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              if (item.containsKey('harga'))
                                Text(item['harga'],
                                    style: TextStyle(
                                        color: Colors.red[900],
                                        fontSize: 20,
                                        fontFamily: 'Poppin',
                                        fontWeight: FontWeight.bold)),
                              Table(
                                columnWidths: {
                                  0: FlexColumnWidth(
                                      3), // Adjust the width of the first column
                                  1: FlexColumnWidth(
                                      1), // Adjust the width of the second column
                                  2: FlexColumnWidth(
                                      5), // Adjust the width of the third column
                                },
                                children: [
                                  TableRow(children: [
                                    //kota awal
                                    TableCell(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 8.0, horizontal: 2.0),
                                        child: Text(
                                          'Kota Awal',
                                          style: TextStyle(
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 8.0, horizontal: 2.0),
                                        child: Text(':'),
                                      ),
                                    ),
                                    TableCell(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 8.0, horizontal: 2.0),
                                        child: (item.containsKey('kota_awal'))
                                            ? Text(item['kota_awal'])
                                            : Text(''),
                                      ),
                                    )
                                  ]),
                                  //kota tujuan
                                  TableRow(children: [
                                    TableCell(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 8.0, horizontal: 2.0),
                                        child: Text(
                                          'Kota Tujuan',
                                          style: TextStyle(
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 8.0, horizontal: 2.0),
                                        child: Text(
                                          ':',
                                          style: TextStyle(
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                        child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 8.0, horizontal: 2.0),
                                      child: (item.containsKey('kota_tujuan'))
                                          ? Text(item['kota_tujuan'])
                                          : Text(''),
                                    ))
                                  ]),
                                  //jenis pengiriman
                                  TableRow(children: [
                                    TableCell(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 8.0, horizontal: 2.0),
                                        child: Text(
                                          'Jenis Pengiriman',
                                          style: TextStyle(
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 8.0, horizontal: 2.0),
                                        child: Text(
                                          ':',
                                          style: TextStyle(
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                        child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 8.0, horizontal: 2.0),
                                      child:
                                          (item.containsKey('jenis_pengiriman'))
                                              ? Text(item['jenis_pengiriman'])
                                              : Text(''),
                                    ))
                                  ]),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
            Material(
              borderRadius: BorderRadius.circular(7.0),
              color: Colors.red[900],
              //membuat bayangan pada button Detail
              shadowColor: Colors.grey[350],
              elevation: 5,
              child: MaterialButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return RiwayatDaftarHargaPage();
                  }));
                },
                child: Text(
                  'Cek',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 20),
            Material(
              borderRadius: BorderRadius.circular(7.0),
              color: Colors.red[900],
              //membuat bayangan pada button Detail
              shadowColor: Colors.grey[350],
              elevation: 5,
              child: MaterialButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return CariDaftarHargaPage();
                  }));
                },
                child: Text(
                  'Cari',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.note), label: 'My Invoice'),
            BottomNavigationBarItem(
                icon: Icon(Icons.dashboard), label: 'Dashboard'),
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.track_changes_rounded), label: 'Tracking'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
          currentIndex: _selectedIndex,
          //warna merah jika icon di pilih
          selectedItemColor:
              isSelected == true ? Colors.red[900] : Colors.grey[600],
          // onTap: _onItemTapped,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
            _onItemTapped(index);
          }),
    );
  }
}
