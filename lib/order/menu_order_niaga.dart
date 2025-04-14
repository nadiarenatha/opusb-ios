import 'package:flutter/material.dart';
import '../Invoice/menu_invoice_niaga.dart';
import '../profile/profil_niaga.dart';
import '../screen-niaga/home_niaga.dart';
import '../screen-niaga/order_niaga.dart';
import '../tracking/menu_tracking_niaga.dart';
import 'package:flutter/services.dart';

import '../ulasan/detail_pesanan.dart';
import '../ulasan/ulasan.dart'; // Required for Clipboard

class MenuOrderNiagaPage extends StatefulWidget {
  const MenuOrderNiagaPage({Key? key}) : super(key: key);

  @override
  State<MenuOrderNiagaPage> createState() => _MenuOrderNiagaPageState();
}

// class _MenuOrderNiagaPageState extends State<MenuOrderNiagaPage> {
class _MenuOrderNiagaPageState extends State<MenuOrderNiagaPage>
    with SingleTickerProviderStateMixin {
  @override
  //untuk BottomNavigationBarItem
  int _selectedIndex = 0;
  //untuk BottomNavigationBarItem
  bool isSelected = false;
  late TabController _tabController;

  //list barang dlm gudang
  final List<Map<String, dynamic>> allBarangGudang = [
    {
      'id': 1,
      'noresi': 'COSL/SBY/2024.08/001330',
      'jasa': 'Full Container Load',
      'tipe': 'Door to Door',
      'rute': 'Jakarta - Surabaya',
      'harga': 'Rp.10.000.000,00',
    },
    {
      'id': 2,
      'noresi': 'COSL/SBY/2024.08/001331',
      'jasa': 'Full Container Load',
      'tipe': 'Door to Door',
      'rute': 'Jakarta - Surabaya',
      'harga': 'Rp.7.500.000,00',
    },
  ];

  //untuk calendar pada pop up dialog search dengan nama _dateController
  //2 nama berbeda karena tgl di calendar berbeda
  TextEditingController _dateController1 = TextEditingController();
  TextEditingController _dateController2 = TextEditingController();

  //untuk no SJM/nama barang pada pop up dialog search
  TextEditingController _NoOrderController = TextEditingController();

  static List<Widget> _widgetOptions = <Widget>[
    OrderHomeNiagaPage(),
    MenuTrackingNiagaPage(resiNumber: 'your_resi_number_here'),
    HomeNiagaPage(),
    MenuInvoiceNiagaPage(),
    ProfileNiagaPage(),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _tabController.dispose();
    super.dispose();
  }

  void _copyToClipboardTransfer(String text, BuildContext context) {
    Clipboard.setData(ClipboardData(text: text));
    final snackBar = SnackBar(
      content: Text('Copied to Clipboard'),
      duration: Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

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

  Future searchOrder() => showDialog(
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
                    "No Order",
                    style: TextStyle(color: Colors.black, fontFamily: 'Poppin'),
                  ),
                  SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'masukkan nomor order',
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Jasa",
                    style: TextStyle(color: Colors.black, fontFamily: 'Poppin'),
                  ),
                  SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'pilih jasa',
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Tipe Pengiriman",
                    style: TextStyle(color: Colors.black, fontFamily: 'Poppin'),
                  ),
                  SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'pilih tipe pengiriman',
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Kota Asal",
                    style: TextStyle(color: Colors.black, fontFamily: 'Poppin'),
                  ),
                  SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'pilih kota asal',
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Kota Tujuan",
                    style: TextStyle(color: Colors.black, fontFamily: 'Poppin'),
                  ),
                  SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'pilih kota tujuan',
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                        border: InputBorder.none,
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
                  SizedBox(height: 5)
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
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "Daftar Order",
                    style: TextStyle(
                      fontSize: 17,
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
                      _NoOrderController.text = '';
                      searchOrder();
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
              TabBar(
                controller: _tabController,
                indicatorColor: Colors.red[900],
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                tabs: [
                  Tab(
                    child: Text(
                      'On Progress',
                      style: TextStyle(fontWeight: FontWeight.w900),
                    ),
                  ),
                  Tab(
                    child: Text(
                      'Completed',
                      style: TextStyle(fontWeight: FontWeight.w900),
                    ),
                  ),
                ],
              ),
              // Expanded(
              // child: TabBarView(
              //   controller: _tabController,
              //   children: [
              ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: allBarangGudang.length,
                  controller: ScrollController(),
                  itemBuilder: (context, index) {
                    var item = allBarangGudang[index];

                    //jika container di klik dr false akan berubah menjadi true
                    return Container(
                      margin: EdgeInsets.all(18),
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(20),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            if (item.containsKey('noresi'))
                              Row(
                                children: [
                                  Text(item['noresi'],
                                      style: TextStyle(
                                          color: Colors.blue[800],
                                          fontSize: 20,
                                          fontFamily: 'Poppin',
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(width: 5),
                                  GestureDetector(
                                    onTap: () {
                                      _copyToClipboardTransfer(
                                          item['noresi'], context);
                                    },
                                    child: Icon(
                                      Icons.copy,
                                      size: 16.0,
                                      color: Colors.red[900],
                                    ),
                                  ),
                                ],
                              ),
                            SizedBox(height: 10),
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
                                        'Jasa',
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
                                      child: (item.containsKey('jasa'))
                                          ? Text(item['jasa'])
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
                                    child: (item.containsKey('tipe'))
                                        ? Text(item['tipe'])
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
                                    child: (item.containsKey('rute'))
                                        ? Text(item['rute'])
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
                                        'Harga Total',
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
                                    child: (item.containsKey('harga'))
                                        ? Text(item['harga'],
                                            style: TextStyle(
                                                fontWeight: FontWeight.normal))
                                        : Text(''),
                                  ))
                                ]),
                              ],
                            ),
                            SizedBox(height: 20),
                            Text(
                              'Menunggu Konfirmasi admin',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                color: Colors.yellow[900],
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SizedBox(
                                  width: 90,
                                  child: Material(
                                    borderRadius: BorderRadius.circular(7.0),
                                    color: Colors.red[900],
                                    //membuat bayangan pada button Detail
                                    shadowColor: Colors.grey[350],
                                    elevation: 5,
                                    child: MaterialButton(
                                      onPressed: () {
                                        // Navigator.push(
                                        //   context,
                                        //   MaterialPageRoute(
                                        //       builder: (context) =>
                                        //           UlasanNiagaPage()),
                                        // );
                                      },
                                      child: Text(
                                        'Ulasan',
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                SizedBox(
                                  width: 80,
                                  child: Material(
                                    borderRadius: BorderRadius.circular(7.0),
                                    color: Colors.white,
                                    //membuat bayangan pada button Detail
                                    shadowColor: Colors.grey[350],
                                    elevation: 5,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors
                                              .red[900]!, // Red border color
                                          width: 2.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(7.0),
                                      ),
                                      child: MaterialButton(
                                        onPressed: () {
                                          // Navigator.push(
                                          //   context,
                                          //   MaterialPageRoute(
                                          //       builder: (context) =>
                                          //           DetailPesananNiagaPage(detail: ordersItem)),
                                          // );
                                        },
                                        child: Text(
                                          'Detail',
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.red[900]),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  })
            ],
          ),
        ),
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
        //     items: const <BottomNavigationBarItem>[
        //       BottomNavigationBarItem(
        //           icon: Icon(Icons.dashboard), label: 'Order'),
        //       BottomNavigationBarItem(
        //         icon: SizedBox(
        //           width: 20,
        //           child: ImageIcon(
        //             AssetImage('assets/tracking icon.png'),
        //           ),
        //         ),
        //         label: 'Tracking',
        //       ),
        //       BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        //       BottomNavigationBarItem(
        //         icon: SizedBox(
        //           width: 12,
        //           child: ImageIcon(
        //             AssetImage('assets/invoice icon.png'),
        //           ),
        //         ),
        //         label: 'Invoice',
        //       ),
        //       BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        //     ],
        //     currentIndex: _selectedIndex,
        //     // selectedItemColor: Colors.grey[600],
        //     selectedItemColor: _selectedIndex == 0
        //         ? Colors.red[900] // Highlight the tracking icon in red
        //         : Colors.grey[600],
        //     onTap: _onItemTapped,
        //   ),
        // ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5), // Shadow color
                spreadRadius: 5, // How much the shadow spreads
                blurRadius: 7, // How soft the shadow looks
                offset: Offset(0, 3), // Changes position of the shadow
              ),
            ],
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            items: <BottomNavigationBarItem>[
              const BottomNavigationBarItem(
                icon: Icon(
                  Icons.dashboard,
                  size: 27,
                ),
                label: 'Order',
              ),
              const BottomNavigationBarItem(
                icon: SizedBox(
                  width: 23,
                  child: ImageIcon(
                    AssetImage('assets/tracking icon.png'),
                  ),
                ),
                label: 'Tracking',
              ),
              // BottomNavigationBarItem(
              //   icon: Stack(
              //     alignment:
              //         Alignment.center, // Centers the icon inside the circle
              //     children: <Widget>[
              //       Container(
              //         height: 40, // Adjust size of the circle
              //         width: 40,
              //         decoration: BoxDecoration(
              //           color: Colors.red[900], // Red circle color
              //           shape: BoxShape.circle,
              //         ),
              //       ),
              //       Icon(
              //         Icons.home,
              //         color:
              //             Colors.white, // Icon color (optional for visibility)
              //       ),
              //     ],
              //   ),
              //   label: 'Home',
              // ),
              BottomNavigationBarItem(
                icon: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Container(
                      height: 50, // Adjusted size of the circle
                      width: 50,
                      decoration: BoxDecoration(
                        color: Colors.red[900], // Red circle color
                        shape: BoxShape.circle,
                      ),
                    ),
                    Icon(
                      Icons.home,
                      size: 28,
                      color: Colors.white,
                    ),
                  ],
                ),
                label: '',
              ),
              const BottomNavigationBarItem(
                icon: SizedBox(
                  width: 23,
                  child: ImageIcon(
                    AssetImage('assets/invoice icon.png'),
                  ),
                ),
                label: 'Invoice',
              ),
              const BottomNavigationBarItem(
                icon: Icon(
                  Icons.person,
                  size: 27,
                ),
                label: 'Profil',
              ),
            ],
            currentIndex: _selectedIndex,
            // selectedItemColor: Colors.grey[600],
            selectedItemColor: _selectedIndex == 0
                ? Colors.red[900] // Highlight the tracking icon in red
                : Colors.grey[600],
            onTap: _onItemTapped,
          ),
        ));
  }
}
