import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:niaga_apps_mobile/cubit/invoice_detail_cubit.dart';
import 'package:niaga_apps_mobile/model/invoice.dart';
import 'package:niaga_apps_mobile/model/invoice_detail.dart';
import 'package:niaga_apps_mobile/screen/dahboard.dart';
import 'package:niaga_apps_mobile/screen/home.dart';
import 'package:niaga_apps_mobile/screen/profile.dart';

class DetailMyInvoice extends StatefulWidget {
  final InvoiceAccesses invoice;
  const DetailMyInvoice({Key? key, required this.invoice}) : super(key: key);

  @override
  State<DetailMyInvoice> createState() => _DetailMyInvoiceState();
}

class _DetailMyInvoiceState extends State<DetailMyInvoice> {
  //untuk set navigasi bar dashboard, home, profile
  int _selectedIndex = 0;
  bool isSelected = false;
  int? meInvoiceId;

  List<InvoiceAccesses> invoicedetailModellist = [];

  List<InvoiceDetailAccesses> invoicedetaillineModellist = [];

//untuk BottomNavigationBarItem
  static List<Widget> _widgetOptions = <Widget>[
    DashboardPage(),
    HomePage(),
    ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    BlocProvider.of<InvoiceDetailCubit>(context)
        .fetchInvoiceDetail(meInvoiceId: widget.invoice.id); 
    // isSelected = false;
  }

  @override
  void dispose() {
    super.dispose();
  }

  //untuk BottomNavigationBarItem
  void _onItemTapped(int index) {
    switch (_selectedIndex) {
      case 0:
        Navigator.push(
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
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfilePage()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          0.07 * MediaQuery.of(context).size.height,
        ),
        child: AppBar(
          backgroundColor: Colors.white,
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
            padding: EdgeInsets.only(left: 45, bottom: 6),
            child: Row(
              children: [
                Text(
                  "Detail Tagihan",
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.red[900],
                      fontFamily: 'Poppin',
                      fontWeight: FontWeight.w900),
                ),
                // Spacer(),
                SizedBox(
                  width: 180.0,
                ),
                Container(
                  width: 40,
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
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.search,
                      color: Colors.black,
                    ),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: BlocConsumer<InvoiceDetailCubit, InvoiceDetailState>(
        listener: (context, state) {
          if (state is InvoiceDetailSuccess) {
            print('Tes');
            invoicedetaillineModellist.clear();
            invoicedetaillineModellist = state.response;
          }
        },
        builder: (context, state) {
          if (state is InvoiceDetailInProgress) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.amber[600],
              ),
            );
          }
          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.all(16),
                  height: mediaQuery.size.height * 0.58,
                  // height: mediaQuery.size.height * 0.9,
                  width: mediaQuery.size.width * 0.9,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFFB0BEC5), // A color close to grey[350]
                        offset: Offset(0, 6),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Image.asset(
                          'assets/Detail-Invoice.png',
                          height: 60,
                        ),
                      ),
                      Positioned(
                        top: 25,
                        right: 95,
                        child: Image.asset(
                          'assets/Logo-Detail-Invoice.png',
                          height: 60,
                        ),
                      ),
                      //tabel Invoice no (TABEL ATAS)
                      Positioned(
                        top: 100, // Adjust the top position as needed
                        left: 16, // Adjust the left position as needed
                        right: 16, // Adjust the right position as needed
                        child: Table(
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
                                      vertical: 8.0, horizontal: 2.0),
                                  child: Text(
                                    'Invoice No',
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
                                  child:
                                      // Text('TCB BIA'),
                                      Text(widget.invoice.invoiceNo!),
                                ),
                              )
                            ]),
                            //baris ke 2 penerima
                            TableRow(children: [
                              TableCell(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 2.0),
                                  child: Text(
                                    'Penerima',
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
                                child: Text('TCB BIA'),
                              ))
                            ]),
                            //baris ke 3 Due Date
                            TableRow(children: [
                              TableCell(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 2.0),
                                  child: Text(
                                    'Due Date',
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
                              //membuat pangkat 3
                              TableCell(
                                  child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 2.0),
                                child: Text(widget.invoice.dueDate!),
                              ))
                            ]),
                          ],
                        ),
                      ),
                      //tabel freight (TABEL BAWAH)
                      Positioned(
                        top: 230, // Adjust the top position as needed
                        left: 16, // Adjust the left position as needed
                        right: 16, // Adjust the right position as needed
                        child: Table(
                          columnWidths: {
                            0: FlexColumnWidth(10),
                            1: FlexColumnWidth(1),
                            2: FlexColumnWidth(5),
                          },
                          children: [
                            for (var a in invoicedetaillineModellist)
                              TableRow(
                                children: [
                                  TableCell(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 8.0,
                                        horizontal: 2.0,
                                      ),
                                      child: Text(
                                        a.item!,
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 8.0,
                                        horizontal: 2.0,
                                      ),
                                      child: Text(''),
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 8.0,
                                        horizontal: 2.0,
                                      ),
                                      child: Text(
                                        a.amount.toString(),
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            //Tax
                            // for (var a in invoicedetaillineModellist)
                            TableRow(children: [
                              TableCell(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 2.0),
                                  child: Text(
                                    'Tax',
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
                                    '',
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
                                  // invoicedetaillineModellist[1].pph.toString(),
                                  // invoicedetaillineModellist.first.pph
                                  //     .toString(),
                                  // a.pph.toString(),
                                  invoicedetaillineModellist.isNotEmpty
                                      ? invoicedetaillineModellist[0]
                                          .pph
                                          .toString()
                                      : '',
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                              ))
                            ]),
                            //Grand Total
                            // for (var a in invoicedetaillineModellist)
                            TableRow(children: [
                              TableCell(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 2.0),
                                  child: Text(
                                    'Grand Total',
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
                                    '',
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
                                  // a.amount.toString(),
                                  // invoicedetaillineModellist.isNotEmpty
                                  //     ? invoicedetaillineModellist[0]
                                  //         .amount
                                  //         .toString()
                                  //     : '',
                                  //====
                                  // ((invoicedetaillineModellist.isNotEmpty
                                  //             ? invoicedetaillineModellist[0]
                                  //                     .pph ??
                                  //                 0
                                  //             : 0) +
                                  //         (invoicedetaillineModellist.isNotEmpty
                                  //             ? invoicedetaillineModellist[0]
                                  //                     .amount ??
                                  //                 0
                                  //             : 0) +
                                  //         (invoicedetaillineModellist.isNotEmpty
                                  //             ? invoicedetaillineModellist[1]
                                  //                     .amount ??
                                  //                 0
                                  //             : 0))
                                  //     .toString(),
                                  //===
                                  (() {
                                    double total = 0.0;
                                    if (invoicedetaillineModellist.isNotEmpty) {
                                      // Sum pph
                                      total +=
                                          invoicedetaillineModellist[0].pph ??
                                              0;

                                      // Sum all amounts
                                      for (var model
                                          in invoicedetaillineModellist) {
                                        total += model.amount ?? 0;
                                      }
                                    }
                                    return total.toString();
                                  })(),
                                  textAlign: TextAlign.right,
                                ),
                              ))
                            ]),
                          ],
                        ),
                      ),
                      //membuat tombol Bayar
                      Positioned(
                        right: 126,
                        bottom: 30,
                        child: Material(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.green[600],
                          //membuat bayangan pada button Detail
                          shadowColor: Colors.grey[350],
                          elevation: 5,
                          child: MaterialButton(
                            onPressed: () {
                              // Add your button action here
                            },
                            child: Text(
                              'Bayar',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
              ],
            ),
          );
        },
      ),
      //   },
      // ),
      bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.dashboard), label: 'Dashboard'),
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor:
              isSelected == true ? Colors.red[900] : Colors.grey[600],
          // onTap: _onItemTapped,
          onTap: _onItemTapped),
    );
  }
}
