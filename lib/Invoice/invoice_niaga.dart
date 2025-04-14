import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:niaga_apps_mobile/cubit/invoice_cubit.dart';
import 'package:niaga_apps_mobile/model/invoice.dart';
import 'package:niaga_apps_mobile/screen/dahboard.dart';
import 'package:niaga_apps_mobile/screen/profile.dart';
import 'package:niaga_apps_mobile/tracking/tracking.dart';
import '../cubit/niaga/invoice_niaga_cubit.dart';
import '../model/niaga/open_invoice_niaga.dart';
import 'detail_my_invoice.dart';
import 'package:niaga_apps_mobile/screen/home.dart';

import 'my_invoice.dart';

class InvoicePage extends StatefulWidget {
  const InvoicePage({Key? key}) : super(key: key);
  // final String niagaToken;
  // const InvoicePage({Key? key, required this.niagaToken}) : super(key: key);

  @override
  State<InvoicePage> createState() => _InvoicePageState();
}

// class _InvoicePageState extends State<InvoicePage> {
class _InvoicePageState extends State<InvoicePage>
    with SingleTickerProviderStateMixin {
  @override
  //untuk BottomNavigationBarItem
  int _selectedIndex = 0;
  //untuk BottomNavigationBarItem
  bool isSelected = false;
  late TabController _tabController;
  //untuk pagination
  int currentPageIndex = 0;
  // int itemsPerPage = 10; // Number of items per page
  int itemsPerPage = 5; // Number of items per page
  ScrollController _scrollController = ScrollController(); //untuk pagination

  List<OpenInvoiceAccesses> invoiceModellist = [];

  //untuk calendar pada pop up dialog search dengan nama _dateController
  //2 nama berbeda karena tgl di calendar berbeda
  TextEditingController _dateController1 = TextEditingController();
  TextEditingController _dateController2 = TextEditingController();
  final _emailController = TextEditingController();
  final _sizeController = TextEditingController();
  final _pageController = TextEditingController();

  //untuk no SJM/nama barang pada pop up dialog search
  TextEditingController _NoSJM = TextEditingController();

  //untuk BottomNavigationBarItem
  static List<Widget> _widgetOptions = <Widget>[
    // InvoicePage(),
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
    BlocProvider.of<InvoiceNiagaCubit>(context).openinvoice();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  //untuk BottomNavigationBarItem
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
                  "Tagihan Saya",
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
                    _NoSJM.text = '';
                    _dateController1.text = '';
                    _dateController2.text = '';
                    // _.text = '';
                    searchMyInvoice();
                  },
                ),
              ),
            ],
          ),
          toolbarHeight: 0.07 * MediaQuery.of(context).size.height,
        ),
      ),
      //untuk setting form
      body: BlocConsumer<InvoiceNiagaCubit, InvoiceNiagaState>(
        listener: (context, state) async {
          if (state is OpenInvoiceSuccess) {
            invoiceModellist.clear();
            invoiceModellist = state.response;
          }
        },
        builder: (context, state) {
          if (state is OpenInvoiceInProgress) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.amber[600],
              ),
            );
          }
          return DefaultTabController(
              length: 2,
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      child: Column(
                        children: [
                          TabBar(
                            controller: _tabController,
                            indicatorColor: Colors.red[900],
                            labelColor: Colors.black,
                            unselectedLabelColor: Colors.grey,
                            tabs: [
                              Tab(
                                child: Text(
                                  'Unpaid',
                                  style: TextStyle(fontWeight: FontWeight.w900),
                                ),
                              ),
                              Tab(
                                child: Text(
                                  'Paid',
                                  style: TextStyle(fontWeight: FontWeight.w900),
                                ),
                              ),
                            ],
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            // itemCount: invoiceModellist.length,
                            itemCount: (invoiceModellist.length / itemsPerPage)
                                        .ceil() >
                                    0
                                ? itemsPerPage
                                : 0,
                            controller: ScrollController(),
                            itemBuilder: (context, index) {
                              final int itemIndex =
                                  currentPageIndex * itemsPerPage + index;
                              // var data = invoiceModellist[index];
                              // print(data.invoiceNo);
                              if (itemIndex < invoiceModellist.length) {
                                var openInvoiceAccesses =
                                    invoiceModellist[itemIndex];
                                // var data = invoiceModellist[itemIndex];
                                return Column(
                                  children: openInvoiceAccesses.data
                                      .map((invoiceItem) {
                                    return Container(
                                      margin: EdgeInsets.all(12),
                                      //setting tinggi & lebar container grey
                                      height: mediaQuery.size.height * 0.4,
                                      width: mediaQuery.size.height * 0.5,
                                      decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Color(
                                                  0xFFB0BEC5), // A color close to grey[350]
                                              offset: Offset(0, 6),
                                              blurRadius: 10,
                                              spreadRadius: 1,
                                            )
                                          ]),
                                      child: Padding(
                                        padding: EdgeInsets.all(12.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Text(
                                                invoiceItem.invoiceNumber
                                                    .toString(),
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 20,
                                                    fontFamily: 'Poppin',
                                                    fontWeight:
                                                        FontWeight.bold)),
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
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 8.0,
                                                              horizontal: 2.0),
                                                      child: Text(
                                                        'Type Pengiriman',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal),
                                                      ),
                                                    ),
                                                  ),
                                                  TableCell(
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 8.0,
                                                              horizontal: 2.0),
                                                      child: Text(':'),
                                                    ),
                                                  ),
                                                  TableCell(
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 8.0,
                                                              horizontal: 2.0),
                                                      child: Text(
                                                        // data.type!,
                                                        invoiceItem
                                                            .typePengiriman
                                                            .toString(),
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal),
                                                      ),
                                                    ),
                                                  )
                                                ]),
                                                //volume
                                                TableRow(children: [
                                                  TableCell(
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 8.0,
                                                              horizontal: 2.0),
                                                      child: Text(
                                                        'Volume',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal),
                                                      ),
                                                    ),
                                                  ),
                                                  TableCell(
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 8.0,
                                                              horizontal: 2.0),
                                                      child: Text(
                                                        ':',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal),
                                                      ),
                                                    ),
                                                  ),
                                                  TableCell(
                                                      child: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 8.0,
                                                            horizontal: 2.0),
                                                    child: Text(
                                                      // data.volume.toString(),
                                                      invoiceItem.volume
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                  ))
                                                ]),
                                                //Rute Pengiriman
                                                TableRow(children: [
                                                  TableCell(
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 8.0,
                                                              horizontal: 2.0),
                                                      child: Text(
                                                        'Rute Pengiriman',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal),
                                                      ),
                                                    ),
                                                  ),
                                                  TableCell(
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 8.0,
                                                              horizontal: 2.0),
                                                      child: Text(
                                                        ':',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal),
                                                      ),
                                                    ),
                                                  ),
                                                  TableCell(
                                                      child: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 8.0,
                                                            horizontal: 2.0),
                                                    child:
                                                        // Text('Surabaya - Makassar'),
                                                        Text(
                                                      // data.volume.toString(),
                                                      invoiceItem.rute
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                  ))
                                                ]),
                                                //No. Packing List
                                                TableRow(children: [
                                                  TableCell(
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 8.0,
                                                              horizontal: 2.0),
                                                      child: Text(
                                                        'No. Packing List',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal),
                                                      ),
                                                    ),
                                                  ),
                                                  TableCell(
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 8.0,
                                                              horizontal: 2.0),
                                                      child: Text(
                                                        ':',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal),
                                                      ),
                                                    ),
                                                  ),
                                                  TableCell(
                                                      child: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 8.0,
                                                            horizontal: 2.0),
                                                    child: Text(
                                                      // data.status!,
                                                      invoiceItem.noPL
                                                          .toString(),
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                  ))
                                                ]),
                                                //Total
                                                TableRow(children: [
                                                  TableCell(
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 8.0,
                                                              horizontal: 2.0),
                                                      child: Text(
                                                        'Total',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal),
                                                      ),
                                                    ),
                                                  ),
                                                  TableCell(
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 8.0,
                                                              horizontal: 2.0),
                                                      child: Text(
                                                        ':',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal),
                                                      ),
                                                    ),
                                                  ),
                                                  TableCell(
                                                      child: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 8.0,
                                                            horizontal: 2.0),
                                                    child: Text(
                                                      "Rp " +
                                                          invoiceItem
                                                              .totalInvoice
                                                              .toString(),
                                                      style: TextStyle(
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                  ))
                                                ]),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Material(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          7.0),
                                                  color: Colors.red[900],
                                                  //membuat bayangan pada button Detail
                                                  shadowColor: Colors.grey[350],
                                                  elevation: 5,
                                                  child: MaterialButton(
                                                    onPressed: () {},
                                                    child: Text(
                                                      'Bayar',
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 10),
                                                Material(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          7.0),
                                                  color: Colors.red[900],
                                                  //membuat bayangan pada button Detail
                                                  shadowColor: Colors.grey[350],
                                                  elevation: 5,
                                                  child: MaterialButton(
                                                    onPressed: () {},
                                                    child: Text(
                                                      'Download',
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    //mengatur pagination
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        height: 40,
                        child: Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.arrow_back_ios),
                              onPressed: currentPageIndex > 0
                                  ? () {
                                      setState(() {
                                        currentPageIndex--;
                                        _scrollController.animateTo(
                                          0.0,
                                          duration: Duration(milliseconds: 500),
                                          curve: Curves.easeInOut,
                                        );
                                      });
                                    }
                                  : null,
                            ),
                            Expanded(
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount:
                                    (invoiceModellist.length / itemsPerPage)
                                        .ceil(),
                                itemBuilder: (context, pageIndex) {
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        currentPageIndex = pageIndex;
                                        _scrollController.animateTo(
                                          0.0,
                                          duration: Duration(milliseconds: 500),
                                          curve: Curves.easeInOut,
                                        );
                                      });
                                    },
                                    child: Container(
                                      height: 30,
                                      width: 30,
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 5),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        color: pageIndex == currentPageIndex
                                            ? Colors
                                                .blue[300] // Active page color
                                            : Colors.grey[
                                                300], // Inactive page color
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color(0xFFB0BEC5),
                                            offset: Offset(0, 2),
                                            blurRadius: 5,
                                            spreadRadius: 1,
                                          ),
                                        ],
                                      ),
                                      child: Center(
                                        child: Text(
                                          '${pageIndex + 1}',
                                          style: TextStyle(
                                            color: pageIndex == currentPageIndex
                                                ? Colors
                                                    .white // Active page text color
                                                : Colors
                                                    .black, // Inactive page text color
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.arrow_forward_ios),
                              onPressed: currentPageIndex <
                                      (invoiceModellist.length / itemsPerPage)
                                              .ceil() -
                                          1
                                  ? () {
                                      setState(() {
                                        currentPageIndex++;
                                        _scrollController.animateTo(
                                          0.0,
                                          duration: Duration(milliseconds: 500),
                                          curve: Curves.easeInOut,
                                        );
                                      });
                                    }
                                  : null,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                  ],
                ),
              ));
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.note), label: 'My Invoice'),
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
        onTap: _onItemTapped,
      ),
    );
  }
}
