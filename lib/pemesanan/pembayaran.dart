import 'package:flutter/material.dart';
import 'package:niaga_apps_mobile/Invoice/my_invoice.dart';
import 'package:niaga_apps_mobile/pemesanan/pembayaran_qris.dart';
import 'package:niaga_apps_mobile/pemesanan/pembayaran_transfer_bank.dart';
import 'package:niaga_apps_mobile/pemesanan/pembayaran_virtual.dart';
import 'package:niaga_apps_mobile/screen/dahboard.dart';
import 'package:niaga_apps_mobile/screen/home.dart';
import 'package:niaga_apps_mobile/screen/profile.dart';
import 'package:niaga_apps_mobile/tracking/tracking.dart';

class Pembayaran extends StatefulWidget {
  const Pembayaran({super.key});

  @override
  State<Pembayaran> createState() => _PembayaranState();
}

class _PembayaranState extends State<Pembayaran> {
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

  Future<void> AlertBayar(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
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
                "Anda belum memilih Metode Pembayaran !!",
                style: TextStyle(
                    color: Colors.red[900],
                    fontFamily: 'Poppins',
                    fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? _selectedPaymentMethod;
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
                  SizedBox(
                    height: 10,
                  ),
                  //metode pembayaran
                  Text(
                    'Metode Pembayaran',
                    style: TextStyle(
                        color: Colors.red[900],
                        fontSize: 18,
                        fontWeight: FontWeight.w900),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Pilih metode pembayaran yang akan anda gunakan',
                    style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 15,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  //QRIS
                  Container(
                    width: 340,
                    height: 100,
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
                    // padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Table(
                              columnWidths: {
                                0: FlexColumnWidth(2),
                                1: FlexColumnWidth(5),
                                2: FlexColumnWidth(2),
                              },
                              children: [
                                TableRow(children: [
                                  TableCell(
                                    child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 8.0, horizontal: 2.0),
                                        child: Image.asset(
                                          'assets/qris.png',
                                          height: 24.0,
                                        )),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 12.0, horizontal: 2.0),
                                      child: Text('QRIS'),
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 0.0, horizontal: 2.0),
                                        child: Radio<String>(
                                          value: 'QRIS',
                                          groupValue: _selectedPaymentMethod,
                                          onChanged: (String? value) {
                                            setState(() {
                                              _selectedPaymentMethod = value;
                                            });
                                          },
                                          activeColor: Colors.red[900],
                                        )),
                                  )
                                ]),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  //Transfer Bank
                  Container(
                    width: 340,
                    height: 100,
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
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Table(
                              columnWidths: {
                                0: FlexColumnWidth(2),
                                1: FlexColumnWidth(5),
                                2: FlexColumnWidth(2),
                              },
                              children: [
                                TableRow(children: [
                                  TableCell(
                                    child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 8.0, horizontal: 2.0),
                                        child: Icon(
                                          Icons.account_balance,
                                          size: 24.0,
                                          color: Colors.red[900],
                                        )),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 14.0, horizontal: 2.0),
                                      child: Text('Transfer Bank'),
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 0.0, horizontal: 2.0),
                                        child: Radio<String>(
                                          value: 'TRANSFER',
                                          groupValue: _selectedPaymentMethod,
                                          onChanged: (String? value) {
                                            setState(() {
                                              _selectedPaymentMethod = value;
                                            });
                                          },
                                          activeColor: Colors.red[900],
                                        )),
                                  )
                                ]),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  //Virtual Account
                  Container(
                    width: 340,
                    height: 100,
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
                    // padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Table(
                              columnWidths: {
                                0: FlexColumnWidth(2),
                                1: FlexColumnWidth(5),
                                2: FlexColumnWidth(2),
                              },
                              children: [
                                TableRow(children: [
                                  TableCell(
                                    child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 8.0, horizontal: 2.0),
                                        child: Icon(
                                          Icons.account_balance,
                                          size: 24.0,
                                          color: Colors.red[900],
                                        )),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 12.0, horizontal: 2.0),
                                      child: Text('Virtual Account (VA)'),
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 0.0, horizontal: 2.0),
                                        child: Radio<String>(
                                          value: 'VIRTUAL',
                                          groupValue: _selectedPaymentMethod,
                                          onChanged: (String? value) {
                                            setState(() {
                                              _selectedPaymentMethod = value;
                                            });
                                          },
                                          activeColor: Colors.red[900],
                                        )),
                                  )
                                ]),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  //E-Wallet (gopay / shopee pay / ovo)
                  Container(
                    width: 340,
                    height: 105,
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
                    // padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Table(
                              columnWidths: {
                                0: FlexColumnWidth(2),
                                1: FlexColumnWidth(5),
                                2: FlexColumnWidth(2),
                              },
                              children: [
                                TableRow(children: [
                                  TableCell(
                                    child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 8.0, horizontal: 2.0),
                                        child: Icon(
                                          Icons.account_balance,
                                          size: 24.0,
                                          color: Colors.red[900],
                                        )),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 12.0, horizontal: 2.0),
                                      child: Text(
                                          'E-Wallet (Gopay/Shopeepay/OVO/LinkAja)'),
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 0.0, horizontal: 2.0),
                                        child: Radio<String>(
                                          value: 'EWALLET',
                                          groupValue: _selectedPaymentMethod,
                                          onChanged: (String? value) {
                                            setState(() {
                                              _selectedPaymentMethod = value;
                                            });
                                          },
                                          activeColor: Colors.red[900],
                                        )),
                                  )
                                ]),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
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
                      onPressed: () {
                        if (_selectedPaymentMethod == null) {
                          AlertBayar(context);
                        } else if (_selectedPaymentMethod == 'QRIS') {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return PembayaranQRIS();
                          }));
                        } else if (_selectedPaymentMethod == 'TRANSFER') {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return PembayaranTransferBank();
                          }));
                        } else if (_selectedPaymentMethod == 'VIRTUAL') {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return PembayaranVirtual();
                          }));
                        } else if (_selectedPaymentMethod == 'EWALLET') {}
                      },
                      child: Text(
                        'Lanjut',
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
      stepNumber == 5
          ? (Colors.red[900] ?? Colors.red)
          : (Colors.grey[400] ?? Colors.grey);
  Color textColor =
      // isSelected
      stepNumber == 5 ? Colors.white : Colors.black;

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
