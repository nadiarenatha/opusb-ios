import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:niaga_apps_mobile/Invoice/my_invoice.dart';
import 'package:niaga_apps_mobile/pemesanan/web_view.dart';
import 'package:niaga_apps_mobile/screen/dahboard.dart';
import 'package:niaga_apps_mobile/screen/home.dart';
import 'package:niaga_apps_mobile/screen/profile.dart';
import 'package:niaga_apps_mobile/tracking/tracking.dart';

import '../services/payment_service_impl.dart';

class KonfirmasiDetailBarang extends StatefulWidget {
  const KonfirmasiDetailBarang({super.key});

  @override
  State<KonfirmasiDetailBarang> createState() => _KonfirmasiDetailBarangState();
}

class _KonfirmasiDetailBarangState extends State<KonfirmasiDetailBarang> {
  int _selectedIndex = 0;
  bool isSelected = false;

  static List<Widget> _widgetOptions = <Widget>[
    MyInvoicePage(),
    DashboardPage(),
    HomePage(),
    TrackingPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => _widgetOptions[index]),
    );
  }

  final PaymentServiceImpl paymentService = PaymentServiceImpl(
    dio: Dio(),
    storage: FlutterSecureStorage(),
  );

  Future<void> handlePaymentValidation() async {
    try {
      final redirectUrl = await paymentService.paymentvalidation(
        serverKey: 'SB-Mid-server-zbiWPVrVAVdsDSmCh8fMBxpu',
        requestBody: {
          "transaction_details": {
            "order_id": "ORDER-113",
            "gross_amount": 10000
          },
          "credit_card": {"secure": true}
        },
      );
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => WebViewPage(url: redirectUrl),
      ));
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          0.12 * MediaQuery.of(context).size.height,
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
          flexibleSpace: Container(
            alignment: Alignment.bottomLeft,
            padding: EdgeInsets.only(left: 45, bottom: 20),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Pemesanan",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.red[900],
                            fontFamily: 'Poppin',
                            fontWeight: FontWeight.w900),
                      ),
                      SizedBox(height: 15),
                      Row(
                        children: [
                          _buildStepItem('1', 'Kontrak Perjanjian', 1),
                          _buildSeparator(),
                          _buildStepItem(
                              '2', 'Detail Barang & Layanan Pengiriman', 2),
                          _buildSeparator(),
                          _buildStepItem('3', 'Jadwal Stuffing', 3),
                          _buildSeparator(),
                          _buildStepItem('4', 'Konfirmasi Detail Barang', 4),
                          _buildSeparator(),
                          _buildStepItem('5', 'Pembayaran', 5),
                          _buildSeparator(),
                          _buildStepItem('6', 'Stuffing Barang', 6),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //tanggal
                  Text(
                    'Pengirim',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Column(
                        children: [
                          //icon location
                          Container(
                            child: Icon(
                              Icons.location_on,
                              size: 26,
                              color: Colors.blueGrey[400],
                            ),
                          ),
                          Container(
                            height: 80, // Adjust the height as needed
                            child: VerticalDivider(
                              color: Colors.grey[400],
                              thickness: 3,
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'PT Adikrasa Mitrajaya',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w800),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              '082121288440',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            // RichText(
                            //   maxLines: 2,
                            //   // overflow: TextOverflow.ellipsis,
                            //   text: TextSpan(
                            //     text:
                            //         'Jl.Kenangan Selatan No.77, RT.02, RW.03 Kecamatan Penjaringan, Jakarta Utara',
                            //     style: TextStyle(color: Colors.grey[600]),
                            //   ),
                            // ),
                            Text(
                                "Jl.Kenangan Selatan No.77, RT.02, RW.03 Kecamatan Penjaringan, Jakarta Utara",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 14),
                                maxLines: 4)
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Penerima',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //kolom 1 lingakaran + garis
                          Column(
                            children: [
                              //icon location
                              Container(
                                child: Icon(
                                  Icons.location_on,
                                  size: 26,
                                  color: Colors.red[900],
                                ),
                              ),
                              Container(
                                height: 80, // Adjust the height as needed
                                child: VerticalDivider(
                                  color: Colors.white,
                                  thickness: 3,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'PT Borwita',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w800),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              '082551274565',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              'Jl.Jajaran, Gubeng, Surabaya',
                              style: TextStyle(color: Colors.grey[600]),
                              maxLines: 4,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: 340,
                    height: 260,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey
                              .withOpacity(0.5), // Color of the shadow
                          spreadRadius: 2, // Spread radius
                          blurRadius: 5, // Blur radius
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Detail Produk',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.red[900],
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Mio 250 CC',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                'Barang kendaraan bermotor tipe LCL',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Table(
                            columnWidths: {
                              0: FlexColumnWidth(4),
                              1: FlexColumnWidth(1),
                              2: FlexColumnWidth(5),
                            },
                            children: [
                              TableRow(children: [
                                TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 2.0),
                                    child: Text(
                                      'Jenis',
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
                                    child: Text(
                                      'Kendaraan Bermotor',
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                )
                              ]),
                              //baris ke 2 tipe pengiriman
                              TableRow(children: [
                                TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 2.0),
                                    child: Text(
                                      'Tipe Pengiriman',
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
                                  child: Text(
                                    'LCL',
                                    textAlign: TextAlign.right,
                                  ),
                                ))
                              ]),
                              //tipe pelayanan
                              TableRow(children: [
                                TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 2.0),
                                    child: Text(
                                      'Tipe Pelayanan',
                                      style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                      ),
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
                                  child: Text(
                                    'DTD',
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black),
                                    textAlign: TextAlign.right,
                                  ),
                                ))
                              ]),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Setelah pembayaran, barang akan dicek oleh checker yang datang ke lokasi anda',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            //green container
            Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 90,
                  decoration: BoxDecoration(
                    color: Colors.green[600],
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Jadwal Stuffing',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          Text(
                            '21/06/2024 10.00 AM',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      Stack(
                        alignment: Alignment.centerRight,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 25, right: 15),
                            child: Image.asset('assets/courier.png',
                                width: 160.0,
                                fit: BoxFit
                                    .contain // Adjust how the image fits within the widget
                                ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Image.asset(
                              'assets/parcel.png', // Replace with your image path
                              width: 120.0,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Table(
                columnWidths: {
                  0: FlexColumnWidth(6),
                  1: FlexColumnWidth(1),
                  2: FlexColumnWidth(12),
                },
                children: [
                  TableRow(children: [
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 2.0),
                        child: Text(
                          'Harga Pengiriman',
                          style: TextStyle(fontWeight: FontWeight.normal),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 2.0),
                        child: Text(''),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 2.0),
                        child: Text(
                          'Rp 13.700.000',
                          textAlign: TextAlign.right,
                        ),
                      ),
                    )
                  ]),
                  //baris ke 2 PPN
                  TableRow(children: [
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 2.0),
                        child: Text(
                          'PPN',
                          style: TextStyle(fontWeight: FontWeight.normal),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 2.0),
                        child: Text(
                          '',
                          style: TextStyle(fontWeight: FontWeight.normal),
                        ),
                      ),
                    ),
                    TableCell(
                        child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 2.0),
                      child: Text(
                        'Rp 300.000',
                        textAlign: TextAlign.right,
                      ),
                    ))
                  ]),
                  //total
                  TableRow(children: [
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 2.0),
                        child: Text(
                          'Total',
                          style: TextStyle(
                              fontWeight: FontWeight.w900, fontSize: 20),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 2.0),
                        child: Text(
                          '',
                          style: TextStyle(fontWeight: FontWeight.normal),
                        ),
                      ),
                    ),
                    TableCell(
                        child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 2.0),
                      child: Text(
                        'Rp 14.000.000',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: Colors.red[900]),
                        textAlign: TextAlign.right,
                      ),
                    ))
                  ]),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Center(
              child: Column(
                children: [
                  Material(
                    borderRadius: BorderRadius.circular(7.0),
                    color: Colors.red[900],
                    //membuat bayangan pada button Detail
                    shadowColor: Colors.grey[350],
                    elevation: 5,
                    child: MaterialButton(
                      minWidth: 220, // Adjust the width as needed
                      height: 60, // Adjust the height as needed
                      onPressed: () async {
                        await handlePaymentValidation();
                      },
                      child: Text(
                        'Pilih Metode Pembayaran',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Material(
                    borderRadius: BorderRadius.circular(7.0),
                    color: Colors.white,
                    //membuat bayangan pada button Detail
                    shadowColor: Colors.grey[350],
                    elevation: 5,
                    child: MaterialButton(
                      minWidth: 220, // Adjust the width as needed
                      height: 60, // Adjust the height as needed
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Kembali',
                        style: TextStyle(fontSize: 16, color: Colors.red[900]),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            )
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

int _currentStep = 1;
Widget _buildStepItem(String number, String title, int stepNumber) {
  // bool isSelected = _currentStep == stepNumber;
  Color itemColor =
      // isSelected
      stepNumber == 4
          ? (Colors.red[900] ?? Colors.red)
          : (Colors.grey[400] ?? Colors.grey);
  Color textColor =
      // isSelected
      stepNumber == 4 ? Colors.white : Colors.black;

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0),
    child: Row(
      children: [
        Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(
                    color: itemColor,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                Text(
                  number,
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.w800,
                    fontSize: 20,
                  ),
                )
              ],
            ),
          ],
        ),
        SizedBox(width: 5),
        Text(
          title,
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
  );
}

Widget _buildSeparator() {
  return Container(
    width: 45,
    height: 3,
    color: Colors.grey[400],
    margin: EdgeInsets.symmetric(horizontal: 8),
  );
}
