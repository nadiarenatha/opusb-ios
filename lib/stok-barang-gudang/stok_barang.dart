import 'package:flutter/material.dart';
import 'package:niaga_apps_mobile/Invoice/my_invoice.dart';
import 'package:niaga_apps_mobile/screen/dahboard.dart';
import 'package:niaga_apps_mobile/screen/profile.dart';
import 'package:niaga_apps_mobile/screen/home.dart';
import 'package:niaga_apps_mobile/tracking/tracking.dart';

class StokBarangPage extends StatefulWidget {
  const StokBarangPage({Key? key}) : super(key: key);

  @override
  State<StokBarangPage> createState() => _StokBarangPageState();
}

class _StokBarangPageState extends State<StokBarangPage> {
  @override
  //untuk BottomNavigationBarItem
  int _selectedIndex = 0;
  //untuk BottomNavigationBarItem
  bool isSelected = false;

  //list barang dlm gudang
  final List<Map<String, dynamic>> allBarangGudang = [
    {
      'id': 1,
      'noresi': '24707002019010',
      'penerima': 'TCB BIA',
      'volume': '0,06m',
      'tglmasuk': '16-04-2024',
      'warehouse': '51AR-BA',
    },
    // ETA Change notifications
    {
      'id': 2,
      'noresi': '24707002019012',
      'penerima': 'MIA',
      'volume': '0,09m',
      'tglmasuk': '18-04-2024',
      'warehouse': '51ARZ-BA',
    },
    // Pre Arrival notifications
    {
      'id': 3,
      'noresi': '24707002019014',
      'penerima': 'TYA',
      'volume': '0,03m',
      'tglmasuk': '22-04-2024',
      'warehouse': '51ARFR-BA',
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
          //         "Barang dalam Gudang",
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
                  "Barang dalam Gudang",
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
      //untuk setting form
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
                shrinkWrap: true,
                // physics: NeverScrollableScrollPhysics() untuk scroll list view builder
                //In the context of your code, NeverScrollableScrollPhysics is used within the ListView.builder. This means that even if the content exceeds the available space, the list will not scroll.
                physics: NeverScrollableScrollPhysics(),
                // physics: AlwaysScrollableScrollPhysics(),
                itemCount: allBarangGudang.length,
                controller: ScrollController(),
                itemBuilder: (context, index) {
                  var item = allBarangGudang[index];

                  //jika container di klik dr false akan berubah menjadi true
                  return Container(
                    margin: EdgeInsets.all(18),
                    //setting tinggi & lebar container grey
                    height: mediaQuery.size.height * 0.3,
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
                              if (item.containsKey('noresi'))
                                Text(item['noresi'],
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
                                    //penerima
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
                                        child: Text(':'),
                                      ),
                                    ),
                                    TableCell(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 8.0, horizontal: 2.0),
                                        child: (item.containsKey('penerima'))
                                            ? Text(item['penerima'])
                                            : Text(''),
                                      ),
                                    )
                                  ]),
                                  //total volume
                                  TableRow(children: [
                                    TableCell(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 8.0, horizontal: 2.0),
                                        child: Text(
                                          'Total Volume',
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
                                      child: (item.containsKey('volume'))
                                          ? Text(item['volume'])
                                          : Text(''),
                                    ))
                                  ]),
                                  //Tanggal masuk
                                  TableRow(children: [
                                    TableCell(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 8.0, horizontal: 2.0),
                                        child: Text(
                                          'Tanggal Masuk',
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
                                      child: (item.containsKey('tglmasuk'))
                                          ? Text(item['tglmasuk'])
                                          : Text(''),
                                    ))
                                  ]),
                                  //Warehouse
                                  TableRow(children: [
                                    TableCell(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 8.0, horizontal: 2.0),
                                        child: Text(
                                          'Warehouse',
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
                                      child: (item.containsKey('warehouse'))
                                          ? Text(item['warehouse'],
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.normal))
                                          : Text(''),
                                    ))
                                  ]),
                                ],
                              ),
                              // Align(
                              //   alignment: Alignment.topRight,
                              //   child: Material(
                              //     borderRadius: BorderRadius.circular(7.0),
                              //     color: Colors.red[900],
                              //     //membuat bayangan pada button Detail
                              //     shadowColor: Colors.grey[350],
                              //     elevation: 5,
                              //     child: MaterialButton(
                              //       onPressed: () async {
                              //         // String message =
                              //         //     "Barang dengan nomor resi ${item['noresi']} sudah sesuai.";
                              //         // var phone = '81225199000';
                              //         // Map<String, dynamic> item = {
                              //         //   'noresi': '1234567890'
                              //         // };
                              //         // _sendWhatsAppNotif('81225199000', item,
                              //         //     inApp: true);

                              //         // _launchWhatsapp;
                              //         sendMessage();
                              //         String message =
                              //             "Barang dengan nomor resi ${item['noresi']} sudah sesuai.";
                              //         var phone = '85756092608';
                              //         launch(
                              //             'https://wa.me/62$phone/?text=$message');
                              //       },
                              //       child: Text(
                              //         'Sesuai',
                              //         style: TextStyle(
                              //             fontSize: 18, color: Colors.white),
                              //       ),
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                })
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
