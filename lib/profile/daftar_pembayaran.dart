import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:niaga_apps_mobile/profile/profil_niaga.dart';
import '../Invoice/menu_invoice_niaga.dart';
import '../cubit/niaga/riwayat_pembayaran_cubit.dart';
import '../model/niaga/riwayat_pembayaran.dart';
import '../order/menu_order_niaga.dart';
import '../screen-niaga/home_niaga.dart';
import '../tracking/menu_tracking_niaga.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'package:flutter/services.dart';

class DaftarPembayaranNiagaPage extends StatefulWidget {
  const DaftarPembayaranNiagaPage({Key? key}) : super(key: key);

  @override
  State<DaftarPembayaranNiagaPage> createState() =>
      _DaftarPembayaranNiagaPageState();
}

class _DaftarPembayaranNiagaPageState extends State<DaftarPembayaranNiagaPage> {
  @override

  //untuk BottomNavigationBarItem
  int _selectedIndex = 0;
  TextEditingController _noInvoiceController = TextEditingController();
  TextEditingController _dateController = TextEditingController();

  List<RiwayatPembayaranAccesses> pembayaranList = [];

  //Pagination
  int currentPageIndex = 0;
  int itemsPerPage = 5;
  ScrollController _scrollController = ScrollController();

  TextEditingController _pageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<RiwayatPembayaranCubit>(context).riwayatPembayaran();
    _dateController.addListener(() {
      // if (_isProgrammaticChange) return;

      String text = _dateController.text;
      // Remove any non-digit characters
      text = text.replaceAll(RegExp(r'[^0-9]'), '');

      // Automatically format the input as dd/mm/yyyy
      if (text.length >= 2 && text.length <= 4) {
        text = text.substring(0, 2) +
            (text.length >= 3 ? '/' + text.substring(2) : '');
      } else if (text.length > 4) {
        text = text.substring(0, 2) +
            '/' +
            text.substring(2, 4) +
            '/' +
            text.substring(4, min(8, text.length)); // Use min here
      }

      // Update the controller text with formatted date
      _dateController.value = _dateController.value.copyWith(
        text: text,
        selection: TextSelection.collapsed(offset: text.length),
      );
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  //untuk BottomNavigationBarItem
  static List<Widget> _widgetOptions = <Widget>[
    MenuOrderNiagaPage(),
    MenuTrackingNiagaPage(resiNumber: 'your_resi_number_here'),
    HomeNiagaPage(),
    MenuInvoiceNiagaPage(),
    ProfileNiagaPage(),
  ];

  void _onItemTapped(int index) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => _widgetOptions[index]),
    );
  }

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
        // Add leading zero to day and month if necessary
        String day = picked.day < 10 ? '0${picked.day}' : '${picked.day}';
        String month =
            picked.month < 10 ? '0${picked.month}' : '${picked.month}';
        String formattedDate = "$day/$month/${picked.year}";

        controller.text = formattedDate;

        // controller.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  Future searchPage() => showDialog(
      context: context,
      //alert diberi SingleChildScrollView agar bisa di scroll
      builder: (BuildContext context) => Center(
            child: SingleChildScrollView(
              child: AlertDialog(
                  //untuk memberi border melengkung
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  //untuk mengatur letak dari close icon
                  titlePadding: EdgeInsets.zero,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 25, vertical: 3),
                  title: Row(
                    //supaya berada di kanan
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [],
                  ),
                  content: searchPagination()),
            ),
          ));

  searchPagination() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Align content to start
        children: [
          SizedBox(height: 5),
          Table(
            columnWidths: {
              0: FlexColumnWidth(4),
              1: FlexColumnWidth(1),
              2: FlexColumnWidth(4),
            },
            children: [
              TableRow(children: [
                TableCell(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 2.0),
                    child: Text(
                      "Menuju Halaman",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontFamily: 'Poppinss'),
                    ),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 12.0, horizontal: 2.0),
                    child: Text(':',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontFamily: 'Poppinss')),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                    child: Container(
                      width: 50,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5.0),
                        border: Border.all(
                          color: Colors.black,
                          width: 1.0,
                        ),
                      ),
                      padding:
                          EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),
                      child: TextField(
                        controller: _pageController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 13),
                          border: InputBorder.none,
                        ),
                        style: TextStyle(
                            color: Colors.black,
                            fontSize:
                                _pageController.text.length > 5 ? 10.0 : 12.0,
                            fontFamily: 'Montserrat'),
                        onChanged: (value) {
                          // Handle the input value if needed
                        },
                      ),
                    ),
                  ),
                ),
              ]),
            ],
          ),
          SizedBox(height: 10),
          Table(
            columnWidths: {
              0: FlexColumnWidth(4),
              1: FlexColumnWidth(1),
              2: FlexColumnWidth(4),
            },
            children: [
              TableRow(children: [
                TableCell(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 2.0),
                    child: Text(
                      "Halaman Terakhir",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontFamily: 'Poppinss'),
                    ),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 12.0, horizontal: 2.0),
                    child: Text(':',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontFamily: 'Poppinss')),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                    child: Text(
                        ((pembayaranList.length / itemsPerPage).ceil())
                            .toString(),
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontFamily: 'Poppinss')),
                  ),
                ),
              ]),
            ],
          ),
          SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Flexible(
                child: SizedBox(
                  width: 80,
                  height: 40,
                  child: Material(
                    borderRadius: BorderRadius.circular(7.0),
                    color: Colors.white,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        minimumSize: Size(100, 50),
                        side: BorderSide(color: Colors.red[900]!, width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7.0),
                        ),
                        backgroundColor: Colors.white,
                      ),
                      onPressed: () {
                        int pageNumber =
                            int.tryParse(_pageController.text) ?? 1;
                        int maxPage =
                            (pembayaranList.length / itemsPerPage).ceil();
                        if (pageNumber > 0 && pageNumber <= maxPage) {
                          setState(() {
                            currentPageIndex = pageNumber - 1;
                            _scrollController.animateTo(
                              0.0,
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                            );
                          });
                          Navigator.of(context).pop();
                        }
                      },
                      child: Text(
                        'Find',
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.red[900],
                            fontFamily: 'Poppins Med'), // Smaller font
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Flexible(
                child: SizedBox(
                  width: 90,
                  height: 40,
                  child: Material(
                    borderRadius: BorderRadius.circular(7.0),
                    color: Colors.red[900],
                    child: MaterialButton(
                      padding: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "Cancel",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          letterSpacing: 1.5,
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future searchTipePembayaran() => showDialog(
      context: context,
      //alert diberi SingleChildScrollView agar bisa di scroll
      builder: (BuildContext context) => SingleChildScrollView(
            child: AlertDialog(
                //untuk memberi border melengkung
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                //untuk mengatur letak dari close icon
                titlePadding: EdgeInsets.zero,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 25, vertical: 3),
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
                content: search()),
          ));

  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

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
                  "Riwayat Pembayaran",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.red[900],
                      fontFamily: 'Poppins Extra Bold'),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                // width: 30,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Color.fromARGB(255, 184, 33, 22),
                    width: 2.0, // Border width
                  ),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                  iconSize: 24,
                  onPressed: () {
                    _noInvoiceController.text = '';
                    _dateController.text = '';
                    searchTipePembayaran();
                  },
                ),
              ),
            ],
          ),
          toolbarHeight: 0.07 * MediaQuery.of(context).size.height,
        ),
      ),
      body: BlocConsumer<RiwayatPembayaranCubit, RiwayatPembayaranState>(
          listener: (context, state) {
        if (state is RiwayatPembayaranSuccess) {
          pembayaranList.clear();
          pembayaranList = state.response;
        }
      }, builder: (context, state) {
        if (state is RiwayatPembayaranInProgress) {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.amber[600],
            ),
          );
        }
        return SingleChildScrollView(
          //unutk go up pagination
          controller: _scrollController,
          child: Column(
            children: [
              // Container(
              //   margin: EdgeInsets.only(left: 18, top: 18, right: 18),
              //   // margin: EdgeInsets.all(12),
              //   decoration: BoxDecoration(
              //     color: Colors.white,
              //     borderRadius: BorderRadius.circular(20),
              //     border: Border.all(
              //       color: Colors.grey,
              //       width: 2.0,
              //     ),
              //   ),
              //   child: Padding(
              //     // padding:
              //     //     EdgeInsets.only(left: 12, top: 10, right: 12, bottom: 14),
              //     padding: EdgeInsets.all(12.0),
              //     child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       mainAxisAlignment: MainAxisAlignment.spaceAround,
              //       children: [
              //         Text(
              //           'INV/01.NL-SBY.2023.JUL/010987',
              //           style: TextStyle(
              //               color: Colors.black,
              //               fontSize: 14,
              //               fontFamily: 'Poppinss'),
              //         ),
              //         SizedBox(height: 15),
              //         Table(
              //           columnWidths: {
              //             0: FlexColumnWidth(3),
              //             1: FlexColumnWidth(1),
              //             2: FlexColumnWidth(5),
              //           },
              //           children: [
              //             TableRow(children: [
              //               //jenis pembayaran
              //               TableCell(
              //                 child: Padding(
              //                   padding: EdgeInsets.symmetric(
              //                       vertical: 4.0, horizontal: 2.0),
              //                   child: Text(
              //                     'Jenis Pembayaran',
              //                     style: TextStyle(
              //                         fontFamily: 'Poppins Med', fontSize: 12),
              //                   ),
              //                 ),
              //               ),
              //               TableCell(
              //                 child: Padding(
              //                   padding: EdgeInsets.symmetric(
              //                       vertical: 4.0, horizontal: 2.0),
              //                   child: Text(
              //                     ':',
              //                     style: TextStyle(
              //                         fontFamily: 'Poppins Med', fontSize: 12),
              //                   ),
              //                 ),
              //               ),
              //               TableCell(
              //                 child: Padding(
              //                   padding: EdgeInsets.symmetric(
              //                       vertical: 4.0, horizontal: 2.0),
              //                   child: Text(
              //                     'Mandiri Virtual Account',
              //                     style: TextStyle(
              //                         fontFamily: 'Poppins Med', fontSize: 12),
              //                   ),
              //                 ),
              //               )
              //             ]),
              //             TableRow(children: [
              //               TableCell(
              //                 child: Padding(
              //                   padding: EdgeInsets.symmetric(
              //                       vertical: 4.0, horizontal: 2.0),
              //                   child: Text(
              //                     'Tanggal Pembayaran',
              //                     style: TextStyle(
              //                         fontFamily: 'Poppins Med', fontSize: 12),
              //                   ),
              //                 ),
              //               ),
              //               TableCell(
              //                 child: Padding(
              //                   padding: EdgeInsets.symmetric(
              //                       vertical: 4.0, horizontal: 2.0),
              //                   child: Text(
              //                     ':',
              //                     style: TextStyle(
              //                         fontFamily: 'Poppins Med', fontSize: 12),
              //                   ),
              //                 ),
              //               ),
              //               TableCell(
              //                   child: Padding(
              //                 padding: EdgeInsets.symmetric(
              //                     vertical: 4.0, horizontal: 2.0),
              //                 child: Text(
              //                   '21 Juli 2024',
              //                   style: TextStyle(
              //                       fontFamily: 'Poppins Med', fontSize: 12),
              //                 ),
              //               ))
              //             ]),
              //             TableRow(children: [
              //               TableCell(
              //                 child: Padding(
              //                   padding: EdgeInsets.symmetric(
              //                       vertical: 4.0, horizontal: 2.0),
              //                   child: Text(
              //                     'No Referensi',
              //                     style: TextStyle(
              //                         fontFamily: 'Poppins Med', fontSize: 12),
              //                   ),
              //                 ),
              //               ),
              //               TableCell(
              //                 child: Padding(
              //                   padding: EdgeInsets.symmetric(
              //                       vertical: 4.0, horizontal: 2.0),
              //                   child: Text(
              //                     ':',
              //                     style: TextStyle(
              //                         fontFamily: 'Poppins Med', fontSize: 12),
              //                   ),
              //                 ),
              //               ),
              //               TableCell(
              //                   child: Padding(
              //                 padding: EdgeInsets.symmetric(
              //                     vertical: 4.0, horizontal: 2.0),
              //                 child: Text(
              //                   '77029302789411',
              //                   style: TextStyle(
              //                       fontFamily: 'Poppins Med', fontSize: 12),
              //                 ),
              //               ))
              //             ]),
              //             TableRow(children: [
              //               TableCell(
              //                 child: Padding(
              //                   padding: EdgeInsets.symmetric(
              //                       vertical: 4.0, horizontal: 2.0),
              //                   child: Text(
              //                     'Total',
              //                     style: TextStyle(
              //                         fontFamily: 'Poppins Med', fontSize: 12),
              //                   ),
              //                 ),
              //               ),
              //               TableCell(
              //                 child: Padding(
              //                   padding: EdgeInsets.symmetric(
              //                       vertical: 4.0, horizontal: 2.0),
              //                   child: Text(
              //                     ':',
              //                     style: TextStyle(
              //                         fontFamily: 'Poppins Med', fontSize: 12),
              //                   ),
              //                 ),
              //               ),
              //               TableCell(
              //                   child: Padding(
              //                 padding: EdgeInsets.symmetric(
              //                     vertical: 4.0, horizontal: 2.0),
              //                 child: Text(
              //                   'Rp 5.000.000',
              //                   style: TextStyle(
              //                       fontFamily: 'Poppins Med', fontSize: 12),
              //                 ),
              //               ))
              //             ]),
              //           ],
              //         )
              //       ],
              //     ),
              //   ),
              // )
              pembayaranList.isEmpty
                  ? Center(
                      child: Text(
                        'No payment history available.',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Poppins Regular',
                          color: Colors.grey,
                        ),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      // itemCount: pembayaranList.length,
                      itemCount:
                          (pembayaranList.length / itemsPerPage).ceil() > 0
                              ? itemsPerPage
                              : 0,
                      itemBuilder: (context, index) {
                        // final item = pembayaranList[index];
                        final int itemIndex =
                            currentPageIndex * itemsPerPage + index;
                        if (itemIndex < pembayaranList.length) {
                          var item = pembayaranList[itemIndex];
                          return Container(
                            // margin: EdgeInsets.only(bottom: 16.0),
                            margin:
                                EdgeInsets.only(left: 18, top: 18, right: 18),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.grey,
                                width: 2.0,
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    item.invoiceNumber ?? '-',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontFamily: 'Poppinss',
                                    ),
                                  ),
                                  SizedBox(height: 15),
                                  Table(
                                    columnWidths: {
                                      0: FlexColumnWidth(3),
                                      1: FlexColumnWidth(1),
                                      2: FlexColumnWidth(5),
                                    },
                                    children: [
                                      TableRow(children: [
                                        TableCell(
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 4.0),
                                            child: Text(
                                              'Jenis Pembayaran',
                                              style: TextStyle(
                                                fontFamily: 'Poppins Med',
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 4.0),
                                            child: Text(
                                              ':',
                                              style: TextStyle(
                                                fontFamily: 'Poppins Med',
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 4.0),
                                            child: Text(
                                              item.payMethod ??
                                                  'Unknown Method',
                                              style: TextStyle(
                                                fontFamily: 'Poppins Med',
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        )
                                      ]),
                                      TableRow(children: [
                                        TableCell(
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 4.0),
                                            child: Text(
                                              'Tanggal Pembayaran',
                                              style: TextStyle(
                                                fontFamily: 'Poppins Med',
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 4.0),
                                            child: Text(
                                              ':',
                                              style: TextStyle(
                                                fontFamily: 'Poppins Med',
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 4.0),
                                            child: Text(
                                              item.paidDate ?? 'Unknown Date',
                                              style: TextStyle(
                                                fontFamily: 'Poppins Med',
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ]),
                                      TableRow(children: [
                                        TableCell(
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 4.0),
                                            child: Text(
                                              'Total',
                                              style: TextStyle(
                                                fontFamily: 'Poppins Med',
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 4.0),
                                            child: Text(
                                              ':',
                                              style: TextStyle(
                                                fontFamily: 'Poppins Med',
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 4.0),
                                            child: Text(
                                              // 'Rp ${item.paymentAmount?.toStringAsFixed(0) ?? '0'}',
                                              '${item.formattedTotalAmount}',
                                              style: TextStyle(
                                                fontFamily: 'Poppins Med',
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ]),
                                      TableRow(children: [
                                        TableCell(
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 4.0),
                                            child: Text(
                                              'Status Pembayaran',
                                              style: TextStyle(
                                                fontFamily: 'Poppins Med',
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 4.0),
                                            child: Text(
                                              ':',
                                              style: TextStyle(
                                                fontFamily: 'Poppins Med',
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 4.0),
                                            child: Text(
                                              item.transactionStatus == 'S'
                                                  ? 'Berhasil'
                                                  : 'Gagal',
                                              style: TextStyle(
                                                fontFamily: 'Poppins Med',
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ]),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                      },
                    ),
              SizedBox(height: 15),
              if (pembayaranList.isNotEmpty &&
                  ((pembayaranList.length / itemsPerPage).ceil() > 1))
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    height: 40,
                    child: Row(
                      children: [
                        //search icon
                        IconButton(
                          icon: Icon(Icons.search, color: Colors.black),
                          iconSize: 20,
                          onPressed: () {
                            _pageController.text = '';
                            searchPage();
                          },
                        ),
                        // Double Arrow Back
                        SizedBox(
                          height: 60,
                          child: IconButton(
                            icon: Icon(Icons.first_page, color: Colors.black),
                            onPressed: () {
                              setState(() {
                                if (currentPageIndex != 0) {
                                  currentPageIndex = 0;
                                  _scrollController.animateTo(
                                    0.0,
                                    duration: Duration(milliseconds: 500),
                                    curve: Curves.easeInOut,
                                  );
                                }
                              });
                            },
                          ),
                        ),
                        //single arrow back
                        SizedBox(
                          height: 60,
                          child: IconButton(
                            icon: Icon(Icons.arrow_back_ios),
                            iconSize: 20,
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
                        ),
                        Expanded(
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount:
                                (pembayaranList.length / itemsPerPage).ceil(),
                            itemBuilder: (context, pageIndex) {
                              // Only show 5 pages at a time
                              int startPage = (currentPageIndex ~/ 5) * 5;
                              int endPage = startPage + 5;
                              if (pageIndex < startPage ||
                                  pageIndex >= endPage) {
                                return SizedBox.shrink();
                              }
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
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 3),
                                  child: Container(
                                    width: 30,
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 4.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.0),
                                      color: pageIndex == currentPageIndex
                                          ? Colors
                                              .blue[300] // Active page color
                                          : Colors
                                              .grey[300], // Inactive page color
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
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        //single arrow forward
                        SizedBox(
                          height: 50,
                          child: IconButton(
                            icon: Icon(Icons.arrow_forward_ios),
                            iconSize: 20,
                            onPressed: currentPageIndex <
                                    (pembayaranList.length / itemsPerPage)
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
                        ),
                        // Double Arrow Forward
                        SizedBox(
                          height: 50,
                          child: IconButton(
                            icon: Icon(Icons.last_page, color: Colors.black),
                            onPressed: () {
                              setState(() {
                                int lastPageIndex =
                                    (pembayaranList.length / itemsPerPage)
                                            .ceil() -
                                        1;
                                if (currentPageIndex != lastPageIndex) {
                                  currentPageIndex = lastPageIndex;
                                  _scrollController.animateTo(
                                    0.0,
                                    duration: Duration(milliseconds: 500),
                                    curve: Curves.easeInOut,
                                  );
                                }
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        );
      }),
      // bottomNavigationBar: Container(
      //   decoration: BoxDecoration(
      //     boxShadow: [
      //       BoxShadow(
      //         color: Colors.grey.withOpacity(0.5), // Shadow color
      //         spreadRadius: 5, // How much the shadow spreads
      //         blurRadius: 7, // How soft the shadow looks
      //         offset: Offset(0, 3), // Changes position of the shadow
      //       ),
      //     ],
      //   ),
      //   child: BottomNavigationBar(
      //     type: BottomNavigationBarType.fixed,
      //     items: <BottomNavigationBarItem>[
      //       const BottomNavigationBarItem(
      //         icon: Icon(
      //           Icons.dashboard,
      //           size: 27,
      //         ),
      //         label: 'Order',
      //       ),
      //       const BottomNavigationBarItem(
      //         icon: SizedBox(
      //           width: 23,
      //           child: ImageIcon(
      //             AssetImage('assets/tracking icon.png'),
      //           ),
      //         ),
      //         label: 'Tracking',
      //       ),
      //       // BottomNavigationBarItem(
      //       //   icon: Stack(
      //       //     alignment:
      //       //         Alignment.center, // Centers the icon inside the circle
      //       //     children: <Widget>[
      //       //       Container(
      //       //         height: 40, // Adjust size of the circle
      //       //         width: 40,
      //       //         decoration: BoxDecoration(
      //       //           color: Colors.red[900], // Red circle color
      //       //           shape: BoxShape.circle,
      //       //         ),
      //       //       ),
      //       //       Icon(
      //       //         Icons.home,
      //       //         color:
      //       //             Colors.white, // Icon color (optional for visibility)
      //       //       ),
      //       //     ],
      //       //   ),
      //       //   label: 'Home',
      //       // ),
      //       BottomNavigationBarItem(
      //         icon: Stack(
      //           alignment: Alignment.center,
      //           children: <Widget>[
      //             Container(
      //               height: 50, // Adjusted size of the circle
      //               width: 50,
      //               decoration: BoxDecoration(
      //                 color: Colors.red[900], // Red circle color
      //                 shape: BoxShape.circle,
      //               ),
      //             ),
      //             Icon(
      //               Icons.home,
      //               size: 28,
      //               color: Colors.white,
      //             ),
      //           ],
      //         ),
      //         label: '',
      //       ),
      //       const BottomNavigationBarItem(
      //         icon: SizedBox(
      //           width: 23,
      //           child: ImageIcon(
      //             AssetImage('assets/invoice icon.png'),
      //           ),
      //         ),
      //         label: 'Invoice',
      //       ),
      //       const BottomNavigationBarItem(
      //         icon: Icon(
      //           Icons.person,
      //           size: 27,
      //         ),
      //         label: 'Profil',
      //       ),
      //     ],
      //     currentIndex: _selectedIndex,
      //     selectedItemColor: Colors.grey[600],
      //     onTap: _onItemTapped,
      //   ),
      // )
    );
  }

  Widget search() {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 990, maxWidth: 300),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Nomor Invoice",
            style: TextStyle(color: Colors.black, fontFamily: 'Poppin'),
          ),
          SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(
                color: Colors.black, // Set border color
                width: 1.0, // Set border width
              ),
            ),
            child: TextFormField(
              controller: _noInvoiceController,
              decoration: InputDecoration(
                hintText: 'masukkan nomor invoice',
                hintStyle: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                border: InputBorder.none,
              ),
            ),
          ),
          SizedBox(height: 20),
          Text(
            "Tanggal Pembayaran",
            style: TextStyle(color: Colors.black, fontFamily: 'Poppin'),
          ),
          SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(
                color: Colors.black, // Set border color
                width: 1.0, // Set border width
              ),
            ),
            child: TextFormField(
              controller: _dateController,
              inputFormatters: [DateInputFormatter()],
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Pilih tanggal pembayaran',
                hintStyle: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
                border: InputBorder.none,
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context, _dateController),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Center(
            child: Material(
              borderRadius: BorderRadius.circular(7.0),
              color: Colors.red[900],
              child: MaterialButton(
                onPressed: () {
                  // Navigator.of(context).pop();
                  // performSearch();
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
          SizedBox(height: 10)
        ],
      ),
    );
  }
}

class DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var text = newValue.text;

    // Remove any characters that are not digits
    text = text.replaceAll(RegExp(r'[^0-9]'), '');

    // Insert slashes at appropriate positions for dd/mm/yyyy
    if (text.length >= 3 && text.length <= 4) {
      // Format for dd/mm
      text = text.substring(0, 2) + '/' + text.substring(2);
    } else if (text.length > 4) {
      // Format for dd/mm/yyyy
      text = text.substring(0, 2) +
          '/' +
          text.substring(2, 4) +
          '/' +
          text.substring(4);
    }

    // Restrict the length to 10 characters (dd/mm/yyyy)
    if (text.length > 10) {
      text = text.substring(0, 10);
    }

    // Set the selection position
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
