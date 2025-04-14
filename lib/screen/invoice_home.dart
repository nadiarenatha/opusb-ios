import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:niaga_apps_mobile/Invoice/detail_my_invoice.dart';
import 'package:niaga_apps_mobile/Invoice/my_invoice.dart';
import 'package:niaga_apps_mobile/cubit/invoice_cubit.dart';
import 'package:niaga_apps_mobile/model/invoice.dart';
import 'package:niaga_apps_mobile/screen/dahboard.dart';
import 'package:niaga_apps_mobile/screen/profile.dart';
import 'package:niaga_apps_mobile/tracking/tracking.dart';
import 'package:niaga_apps_mobile/screen/home.dart';

class MyInvoiceHomePage extends StatefulWidget {
  const MyInvoiceHomePage({Key? key}) : super(key: key);

  @override
  State<MyInvoiceHomePage> createState() => _MyInvoiceHomePageState();
}

class _MyInvoiceHomePageState extends State<MyInvoiceHomePage> {
  @override
  //untuk BottomNavigationBarItem
  int _selectedIndex = 0;
  //untuk BottomNavigationBarItem
  bool isSelected = false;

  List<InvoiceAccesses> invoiceModellist = [];

  //untuk calendar pada pop up dialog search dengan nama _dateController
  //2 nama berbeda karena tgl di calendar berbeda
  TextEditingController _dateController1 = TextEditingController();
  TextEditingController _dateController2 = TextEditingController();

  //untuk no SJM/nama barang pada pop up dialog search
  TextEditingController _NoSJM = TextEditingController();

  //untuk BottomNavigationBarItem
  static List<Widget> _widgetOptions = <Widget>[
    MyInvoicePage(),
    DashboardPage(),
    HomePage(),
    TrackingPage(),
    ProfilePage(),
  ];

  @override
  void initState() {
    // TODO: implement dispose
    super.initState();
    BlocProvider.of<InvoiceCubit>(context).invoice();
    // isSelected = false;
  }

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
  // //fungsi submit untuk tutup dialog search
  // void submit() {
  //   Navigator.of(context).pop();
  // }
  @override
  Widget build(BuildContext context) {
    // print('isSelected nya: ' + isSelected.toString());
    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          0.07 * MediaQuery.of(context).size.height,
        ),
        child: AppBar(
          backgroundColor: Colors.white,
          //untuk setting letak dan warna tulisan My Invoice
          flexibleSpace: Container(
            alignment: Alignment.bottomLeft,
            padding: EdgeInsets.only(left: 16, bottom: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Tagihan",
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.red[900],
                      fontFamily: 'Poppin',
                      fontWeight: FontWeight.w900),
                ),
                //untuk lingkaran & icons search
                Positioned(
                  bottom: 16,
                  left: 16,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        // borderRadius: BorderRadius.circular(50),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color:
                                Color(0xFFB0BEC5), // A color close to grey[350]
                            offset: Offset(0, 2),
                            blurRadius: 5,
                            spreadRadius: 1,
                          )
                        ]),
                    child: IconButton(
                        icon: Icon(
                          Icons.search,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          _NoSJM.text = '';
                          _dateController1.text = '';
                          _dateController2.text = '';
                          // _.text = '';
                          searchMyInvoice();
                        }),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      //untuk setting form
      body: BlocConsumer<InvoiceCubit, InvoiceState>(
        listener: (context, state) {
          if (state is InvoiceSuccess) {
            invoiceModellist.clear();
            invoiceModellist = state.response;
            // invoiceModellist
            //     .sort((a, b) => a.invoiceNo!.compareTo(b.invoiceNo!));
            // invoiceModellist
            //     .sort((a, b) => a.invoiceNo!.compareTo(b.invoiceNo!));
          }
        },
        builder: (context, state) {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: invoiceModellist.length,
            controller: ScrollController(),
            itemBuilder: (context, index) {
              var data = invoiceModellist[index];
              print(data.invoiceNo);
              return Container(
                margin: EdgeInsets.all(16),
                //setting tinggi & lebar container grey
                height: mediaQuery.size.height * 0.4,
                width: mediaQuery.size.height * 0.5,
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
                    ]),
                child: Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          // Text("INV2024SBYMKS00001",
                          //     style: TextStyle(
                          //         color: Colors.blue[700],
                          //         fontSize: 20,
                          //         fontFamily: 'Poppin',
                          //         fontWeight: FontWeight.bold)),
                          Text(data.invoiceNo!,
                              style: TextStyle(
                                  color: Colors.blue[700],
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
                                //tipe pengiriman
                                TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 2.0),
                                    child: Text(
                                      'Type Pengiriman',
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
                                      data.type!,
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                )
                              ]),
                              //volume
                              TableRow(children: [
                                TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 2.0),
                                    child: Text(
                                      'Volume',
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
                                    data.volume.toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal),
                                  ),
                                ))
                              ]),
                              //Rute Pengiriman
                              TableRow(children: [
                                TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 2.0),
                                    child: Text(
                                      'Rute Pengiriman',
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
                                  child: Text('Surabaya - Makassar'),
                                ))
                              ]),
                              //Jatuh Tempo Bayar
                              TableRow(children: [
                                TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 2.0),
                                    child: Text(
                                      'Jatuh Tempo Bayar',
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
                                      // Text('Lewat 3 hari',
                                      //     style: TextStyle(
                                      //         color: Colors.red[900],
                                      //         fontSize: 16,
                                      //         fontFamily: 'Poppin',
                                      //         fontWeight: FontWeight.w500)),
                                      Text(
                                    data.status!,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        color:
                                            Color.fromARGB(255, 49, 175, 59)),
                                  ),
                                ))
                              ]),
                            ],
                          ),
                          //Total Tagihan
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Total Tagihan",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontFamily: 'Poppin',
                                    fontWeight: FontWeight.w400),
                              ),
                              Text(
                                "Rp 13.800.000,00",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 24,
                                    fontFamily: 'Poppin',
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Button
                    Positioned(
                      right: 16,
                      bottom: 16,
                      child: Material(
                        borderRadius: BorderRadius.circular(7.0),
                        color: Colors.red[900],
                        //membuat bayangan pada button Detail
                        shadowColor: Colors.grey[350],
                        elevation: 5,
                        child: MaterialButton(
                          onPressed: () {
                            // Add your button action here
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              // return DetailMyInvoice();
                              return DetailMyInvoice(invoice: data);
                            }));
                          },
                          child: Text(
                            'Detail',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   type: BottomNavigationBarType.fixed,
      //   items: const <BottomNavigationBarItem>[
      //     BottomNavigationBarItem(icon: Icon(Icons.note), label: 'My Invoice'),
      //     BottomNavigationBarItem(
      //         icon: Icon(Icons.dashboard), label: 'Dashboard'),
      //     BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
      //     BottomNavigationBarItem(
      //         icon: Icon(Icons.track_changes_rounded), label: 'Tracking'),
      //     BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      //   ],
      //   currentIndex: _selectedIndex,
      //   //warna merah jika icon di pilih
      //   selectedItemColor:
      //       isSelected == true ? Colors.red[900] : Colors.grey[600],
      //   onTap: _onItemTapped,
      // ),
    );
  }
}
