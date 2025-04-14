import 'package:flutter/material.dart';
import 'package:niaga_apps_mobile/screen/dahboard.dart';
import 'package:niaga_apps_mobile/screen/home.dart';
import 'package:niaga_apps_mobile/screen/profile.dart';
import 'jadwal_kapal_history.dart';
import 'package:flutter/services.dart';

// class DetailHistoryPage extends StatefulWidget {
//   const DetailHistoryPage({Key? key, required itemId}) : super(key: key);

//   @override
//   State<DetailHistoryPage> createState() => _DetailHistoryPageState();
// }

class DetailHistoryPage extends StatefulWidget {
  // final String itemId;
  final int itemId;

  const DetailHistoryPage({Key? key, required this.itemId}) : super(key: key);

  @override
  State<DetailHistoryPage> createState() => _DetailHistoryPageState();
}

class _DetailHistoryPageState extends State<DetailHistoryPage>
    with SingleTickerProviderStateMixin {
  late Map<String, dynamic> selectedItem;
  @override
  //untuk BottomNavigationBarItem
  int _selectedIndex = 0;
  //untuk BottomNavigationBarItem
  bool isSelected = false;

  late TabController _tabController;

  TextEditingController _dateController1 = TextEditingController();
  TextEditingController _dateController2 = TextEditingController();

  TextEditingController _NoPackingController = TextEditingController();
  TextEditingController _KotaAsalController = TextEditingController();
  TextEditingController _KotaTujuanController = TextEditingController();
  TextEditingController _NamaKapalController = TextEditingController();

  bool showVolume = false; // Flag to toggle showing volumePesanan
  bool isLoading = false; // Flag to track loading state

  @override
  void initState() {
    super.initState();
    // Find the item with matching 'id' in allJadwalKapal
    selectedItem = allJadwalKapal.firstWhere(
      (item) => item['id'] == widget.itemId,
      orElse: () =>
          {'id': '', 'resi': ''}, // Provide a default value or handle null case
    );
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  final List<Map<String, dynamic>> statusPesanan = [
    {
      'checker': 'Menunggu Checker',
      'Stuffselesai': 'Stuffing Luar Selesai',
    },
  ];

  final List<Map<String, dynamic>> volumePesanan = [
    {
      'volume': 'FCL 2 x 20ft',
      'panjang': '120',
      'lebar': '80',
      'tinggi': '115,3',
    },
  ];

  // void handleRefresh() {
  //   setState(() {
  //     showVolume = !showVolume; // Toggle the flag
  //   });
  // }

  void handleRefresh() {
    setState(() {
      isLoading = true; // Start loading
    });

    // Simulate loading delay
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        showVolume = !showVolume; // Toggle the flag
        isLoading = false; // Finish loading
      });
    });
  }

//fungsi copy resi
  void copyResiToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: selectedItem['resi']));
    final snackBar = SnackBar(content: Text('Resi copied to clipboard'));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  //untuk BottomNavigationBarItem
  static List<Widget> _widgetOptions = <Widget>[
    DashboardPage(),
    HomePage(),
    ProfilePage(),
  ];

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
      //alert diberi SingleChildScrollView agar bisa di scroll
      builder: (BuildContext context) => SingleChildScrollView(
            child: AlertDialog(
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
                constraints: BoxConstraints(maxHeight: 990, maxWidth: 300),
                child: Form(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //no packing list
                      Text(
                        "No Packing List",
                        style: TextStyle(
                            color: Colors.black, fontFamily: 'Poppin'),
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
                            hintText: 'masukkan nomor packing list',
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10.0),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      //estimasi waktu
                      Text(
                        "Estimasi Waktu",
                        style: TextStyle(
                            color: Colors.black, fontFamily: 'Poppin'),
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
                              hintText: 'ETA',
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
                              hintText: 'ETD',
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
                      //kota asal
                      Text(
                        "Kota Asal",
                        style: TextStyle(
                            color: Colors.black, fontFamily: 'Poppin'),
                      ),
                      SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: 'masukkan kota asal',
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10.0),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      //kota tujuan
                      Text(
                        "Kota Tujuan",
                        style: TextStyle(
                            color: Colors.black, fontFamily: 'Poppin'),
                      ),
                      SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: 'masukkan kota tujuan',
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10.0),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      //nama kapal
                      Text(
                        "Nama Kapal",
                        style: TextStyle(
                            color: Colors.black, fontFamily: 'Poppin'),
                      ),
                      SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: 'masukkan nama kapal',
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10.0),
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
                    ],
                  ),
                ),
              ),
            ),
          ));

  Widget build(BuildContext context) {
    var selectedItem;
    try {
      selectedItem =
          allJadwalKapal.firstWhere((item) => item['id'] == widget.itemId);
    } catch (e) {
      // Handle the case where no element is found
      // You can show an error message or navigate back
      print('Error: $e');
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('Item not found'),
        ),
      );
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(0.07 * MediaQuery.of(context).size.height),
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
          flexibleSpace: Container(
            alignment: Alignment.bottomLeft,
            padding: EdgeInsets.only(left: 45, bottom: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Detail Pesanan",
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
                          _NoPackingController.text = '';
                          _dateController1.text = '';
                          _dateController2.text = '';
                          _KotaAsalController.text = '';
                          _KotaTujuanController.text = '';
                          _NamaKapalController.text = '';
                          searchMyInvoice();
                        }),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Container(
              //   color: Colors.pink,
              //   width: 130,
              //   height: 130,
              // ),
              if (selectedItem != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text(
                    //   'Resi: ${selectedItem['resi']}',
                    //   style: TextStyle(
                    //     color: Colors.blue[700],
                    //     fontSize: 20,
                    //     fontFamily: 'Poppin',
                    //     fontWeight: FontWeight.bold,
                    //   ),
                    // ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          selectedItem['resi'],
                          style: TextStyle(
                            color: Colors.red[900],
                            fontSize: 20,
                            fontFamily: 'Poppin',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            copyResiToClipboard(context);
                          },
                          child: Icon(
                            Icons.copy,
                            size: 24.0,
                            color: Colors.red[900],
                          ),
                        ),
                      ],
                    ),
                    // SizedBox(height: 10),
                    // Text('Tipe: ${selectedItem['tipe']}'),
                    // SizedBox(height: 10),
                    // Text('Rute Pengiriman: ${selectedItem['rute']}'),
                    // SizedBox(height: 10),
                    // Text('Kapal: ${selectedItem['kapal']}'),
                    // SizedBox(height: 10),
                    // Text('ETA: ${selectedItem['eta']}'),
                    // SizedBox(height: 10),
                    // Text('ETD: ${selectedItem['etd']}'),
                    // SizedBox(height: 25),
                    SizedBox(height: 20),
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
                                  vertical: 8.0, horizontal: 2.0),
                              child: Text(
                                'Tipe Pengiriman',
                                style: TextStyle(fontWeight: FontWeight.normal),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 2.0),
                              child: Text(
                                ':',
                                style: TextStyle(fontWeight: FontWeight.normal),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 2.0),
                              child: Text(
                                selectedItem['tipe'],
                              ),
                            ),
                          )
                        ]),
                        TableRow(children: [
                          TableCell(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 2.0),
                              child: Text(
                                'Rute Pengiriman',
                                style: TextStyle(fontWeight: FontWeight.normal),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 2.0),
                              child: Text(
                                ':',
                                style: TextStyle(fontWeight: FontWeight.normal),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 2.0),
                              child: Text(
                                selectedItem['rute'],
                              ),
                            ),
                          )
                        ]),
                        TableRow(children: [
                          TableCell(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 2.0),
                              child: Text(
                                'Nama Kapal',
                                style: TextStyle(fontWeight: FontWeight.normal),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 2.0),
                              child: Text(
                                ':',
                                style: TextStyle(fontWeight: FontWeight.normal),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 2.0),
                              child: Text(
                                selectedItem['kapal'],
                              ),
                            ),
                          )
                        ]),
                        TableRow(children: [
                          TableCell(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 2.0),
                              child: Text(
                                'Pengirim',
                                style: TextStyle(fontWeight: FontWeight.normal),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 2.0),
                              child: Text(
                                ':',
                                style: TextStyle(fontWeight: FontWeight.normal),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 2.0),
                                child:
                                    // Text(
                                    //   selectedItem['pengirim'],
                                    // ),
                                    Text('')),
                          )
                        ]),
                        TableRow(children: [
                          TableCell(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 2.0),
                              child: Text(
                                'Penerima',
                                style: TextStyle(fontWeight: FontWeight.normal),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 2.0),
                              child: Text(
                                ':',
                                style: TextStyle(fontWeight: FontWeight.normal),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 2.0),
                                child:
                                    // Text(
                                    //   selectedItem['pengirim'],
                                    // ),
                                    Text('')),
                          )
                        ]),
                        TableRow(children: [
                          TableCell(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 2.0),
                              child: Text(
                                'ETD',
                                style: TextStyle(fontWeight: FontWeight.normal),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 2.0),
                              child: Text(
                                ':',
                                style: TextStyle(fontWeight: FontWeight.normal),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 2.0),
                                child:
                                    // Text(
                                    //   selectedItem['pengirim'],
                                    // ),
                                    Text('-')),
                          )
                        ]),
                        TableRow(children: [
                          TableCell(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 2.0),
                              child: Text(
                                'ETA',
                                style: TextStyle(fontWeight: FontWeight.normal),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 2.0),
                              child: Text(
                                ':',
                                style: TextStyle(fontWeight: FontWeight.normal),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 2.0),
                                child:
                                    // Text(
                                    //   selectedItem['pengirim'],
                                    // ),
                                    Text('-')),
                          )
                        ])
                      ],
                    ),
                  ],
                ),
              SizedBox(height: 10),
              //detail produk
              Container(
                width: 340,
                height: 234,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  boxShadow: [
                    BoxShadow(
                      color:
                          Colors.grey.withOpacity(0.5), // Color of the shadow
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
                                  style:
                                      TextStyle(fontWeight: FontWeight.normal),
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
                                  style:
                                      TextStyle(fontWeight: FontWeight.normal),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 2.0),
                                child: Text(
                                  ':',
                                  style:
                                      TextStyle(fontWeight: FontWeight.normal),
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
                                  style:
                                      TextStyle(fontWeight: FontWeight.normal),
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
              SizedBox(height: 20),
              Container(
                height: 2,
                width: MediaQuery.of(context).size.width,
                color: Colors.grey[400],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Text(
                  //   'Menunggu Checker',
                  //   style: TextStyle(
                  //       color: Colors.amber[700],
                  //       fontSize: 18,
                  //       fontWeight: FontWeight.w800),
                  // ),
                  Text(
                    showVolume
                        ? statusPesanan[0]['Stuffselesai']
                        : statusPesanan[0]['checker'],
                    style: TextStyle(
                      color: showVolume ? Colors.green[600] : Colors.amber[700],
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  TextButton(
                    // onPressed: handleRefresh,
                    onPressed: showVolume ? null : handleRefresh,
                    child: Text(
                      'Refresh',
                      style: TextStyle(
                          color: Colors.blue[300],
                          fontSize: 16,
                          fontWeight: FontWeight.w800),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                'Pastikan nomor telepon yang terdaftar adalah aktif',
                style: TextStyle(
                    color: Colors.grey[400], fontWeight: FontWeight.w800),
              ),
              SizedBox(height: 10),
              isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  //data volume
                  : Table(
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
                                'Volume',
                                style: TextStyle(fontWeight: FontWeight.normal),
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
                                  // Text('- m')
                                  Text(showVolume
                                      ? volumePesanan[0]['volume']
                                      : '-'),
                            ),
                          )
                        ]),
                        TableRow(children: [
                          TableCell(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 2.0),
                              child: Text(
                                'Panjang',
                                style: TextStyle(fontWeight: FontWeight.normal),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 2.0),
                              child: Text(
                                ':',
                                style: TextStyle(fontWeight: FontWeight.normal),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 2.0),
                              child:
                                  // Text('- cm')
                                  Text(showVolume
                                      ? volumePesanan[0]['panjang'] + ' cm'
                                      : '- cm'),
                            ),
                          )
                        ]),
                        TableRow(children: [
                          TableCell(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 2.0),
                              child: Text(
                                'Lebar',
                                style: TextStyle(fontWeight: FontWeight.normal),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 2.0),
                              child: Text(
                                ':',
                                style: TextStyle(fontWeight: FontWeight.normal),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 2.0),
                              child:
                                  // Text('- cm')
                                  Text(showVolume
                                      ? volumePesanan[0]['lebar'] + ' cm'
                                      : '- cm'),
                            ),
                          )
                        ]),
                        TableRow(children: [
                          TableCell(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 2.0),
                              child: Text(
                                'Tinggi',
                                style: TextStyle(fontWeight: FontWeight.normal),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 2.0),
                              child: Text(
                                ':',
                                style: TextStyle(fontWeight: FontWeight.normal),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 2.0),
                              child:
                                  // Text('- cm')
                                  Text(showVolume
                                      ? volumePesanan[0]['tinggi'] + ' cm'
                                      : '- cm'),
                            ),
                          )
                        ])
                      ],
                    ),
              SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Material(
                    borderRadius: BorderRadius.circular(15.0),
                    color: Colors.white,
                    //membuat bayangan pada button Detail
                    shadowColor: Colors.grey[350],
                    elevation: 5,
                    child: MaterialButton(
                      onPressed: () {
                        // Add your button action here
                        // Navigator.push(context,
                        //     MaterialPageRoute(builder: (context) {
                        //   return DetailTracking();
                        // }));
                      },
                      child: Text(
                        'Hubungi Kami',
                        style: TextStyle(fontSize: 18, color: Colors.red[900]),
                      ),
                    ),
                  ),
                  Material(
                    borderRadius: BorderRadius.circular(15.0),
                    color: Colors.red[900],
                    //membuat bayangan pada button Detail
                    shadowColor: Colors.grey[350],
                    elevation: 5,
                    child: MaterialButton(
                      onPressed: () {
                        // Add your button action here
                        // Navigator.push(context,
                        //     MaterialPageRoute(builder: (context) {
                        //   return DetailTracking();
                        // }));
                      },
                      child: Text(
                        'Download',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ],
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
        selectedItemColor: isSelected ? Colors.red[900] : Colors.grey[600],
        onTap: _onItemTapped,
      ),
    );
  }
}
