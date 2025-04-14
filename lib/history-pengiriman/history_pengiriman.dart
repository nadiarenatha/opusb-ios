import 'package:flutter/material.dart';
import 'package:niaga_apps_mobile/history-pengiriman/detail_history.dart';
import 'package:niaga_apps_mobile/screen/dahboard.dart';
import 'package:niaga_apps_mobile/screen/home.dart';
import 'package:niaga_apps_mobile/screen/profile.dart';

class HistoryPengirimanPage extends StatefulWidget {
  const HistoryPengirimanPage({Key? key}) : super(key: key);

  @override
  State<HistoryPengirimanPage> createState() => _HistoryPengirimanPageState();
}

class _HistoryPengirimanPageState extends State<HistoryPengirimanPage>
    with SingleTickerProviderStateMixin {
  @override
  int _selectedIndex = 0;
  bool isSelected = false;

  late TabController _tabController;

  TextEditingController _dateController1 = TextEditingController();
  TextEditingController _dateController2 = TextEditingController();

  TextEditingController _NoPackingController = TextEditingController();
  TextEditingController _KotaAsalController = TextEditingController();
  TextEditingController _KotaTujuanController = TextEditingController();
  TextEditingController _NamaKapalController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  //list jadwal kapal
  final List<Map<String, dynamic>> allJadwalKapal = [
    {
      'id': 1,
      'resi': 'PL/DTD-COSL/20240001',
      'tipe': 'Door to Door Stuffing Luar',
      'volume': '0.4',
      'rute': 'Jakarta - Surabaya',
      'kapal': 'SPIL Oriental Gold',
      'eta': 'ETA 17 Mar 2024',
      'etd': 'ETD 18 Mar 2024',
      'value': 'progress',
    },
    {
      'id': 2,
      'resi': 'PL/DTD-COSL/20240002',
      'tipe': 'Door to Door Stuffing Luar',
      'volume': '0.4',
      'rute': 'Semarang - Surabaya',
      'kapal': 'SPIL Oriental Gold',
      'eta': 'ETA 19 Mar 2024',
      'etd': 'ETD 20 Mar 2024',
      'value': 'completed',
    },
    {
      'id': 3,
      'resi': 'PL/DTD-COSL/20240003',
      'tipe': 'Door to Door Stuffing Luar',
      'volume': '0.4',
      'rute': 'Jakarta - Surabaya',
      'kapal': 'SPIL Oriental Gold',
      'eta': 'ETA 21 Mar 2024',
      'etd': 'ETD 22 Mar 2024',
      'value': 'completed',
    },
    {
      'id': 4,
      'resi': 'PL/DTD-COSL/20240004',
      'tipe': 'Door to Door Stuffing Luar',
      'volume': '0.24',
      'rute': 'Medan - Solo',
      'kapal': 'SPIL Oriental Gold',
      'eta': 'ETA 25 Mar 2024',
      'etd': 'ETD 27 Mar 2024',
      'value': 'progress',
    },
  ];

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
    // final mediaQuery = MediaQuery.of(context);

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
                  "History Pengiriman",
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
                    _NoPackingController.text = '';
                    _dateController1.text = '';
                    _dateController2.text = '';
                    _KotaAsalController.text = '';
                    _KotaTujuanController.text = '';
                    _NamaKapalController.text = '';
                    searchMyInvoice();
                  },
                ),
              ),
            ],
          ),
          toolbarHeight: 0.07 * MediaQuery.of(context).size.height,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            DefaultTabController(
              length: 2,
              child: SizedBox(
                height: 900,
                child: Column(
                  children: [
                    TabBar(
                      controller: _tabController,
                      indicatorColor: Colors.red[900], // Color of the indicator
                      labelColor: Colors.black, // Selected tab text color
                      unselectedLabelColor: Colors.grey,
                      tabs: [
                        Tab(
                          child: Text(
                            'In Progress',
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
                    Expanded(
                        child: TabBarView(
                      controller: _tabController,
                      children: [
                        buildListView('progress'),
                        buildListView('completed'),
                      ],
                    ))
                  ],
                ),
              ),
            ),
          ],
          //========
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
        //warna merah jika icon di pilih
        selectedItemColor:
            isSelected == true ? Colors.red[900] : Colors.grey[600],
        onTap: _onItemTapped,
      ),
    );
  }

  Widget buildListView(String status) {
    final filteredJadwalKapal =
        allJadwalKapal.where((item) => item['value'] == status).toList();
    final mediaQuery = MediaQuery.of(context);
    final int itemId;

    return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: filteredJadwalKapal.length,
        itemBuilder: (context, index) {
          var item = filteredJadwalKapal[index];
          return Container(
            margin: EdgeInsets.all(18),
            height: mediaQuery.size.height * 0.46,
            width: mediaQuery.size.height * 0.5,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFFB0BEC5),
                  offset: Offset(0, 6),
                  blurRadius: 10,
                  spreadRadius: 1,
                )
              ],
            ),
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (item.containsKey('resi'))
                            Text(
                              item['resi'],
                              style: TextStyle(
                                color: Colors.blue[700],
                                fontSize: 20,
                                fontFamily: 'Poppin',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          SizedBox(height: 15.0),
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
                                    child: (item.containsKey('tipe'))
                                        ? Text(item['tipe'])
                                        : Text(''),
                                  ),
                                )
                              ]),
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
                                    child: (item.containsKey('volume'))
                                        ? Text(item['volume'])
                                        : Text(''),
                                  ),
                                )
                              ]),
                              TableRow(children: [
                                TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 2.0),
                                    child: Text(
                                      'Rute dan Tujuan',
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
                                  ),
                                )
                              ]),
                              TableRow(children: [
                                TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 2.0),
                                    child: Text(
                                      'Kapal',
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
                                    child: (item.containsKey('kapal'))
                                        ? Text(item['kapal'])
                                        : Text(''),
                                  ),
                                )
                              ])
                            ],
                          ),
                          //ETA
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.calendar_today,
                                  size: 20,
                                ),
                                onPressed: () {},
                              ),
                              if (item.containsKey('eta')) Text(item['eta']),
                            ],
                          ),
                          //ETD
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.calendar_today,
                                  size: 20,
                                ),
                                onPressed: () {},
                              ),
                              if (item.containsKey('etd')) Text(item['etd']),
                            ],
                          ),
                          SizedBox(height: 15),
                          //==button==
                          Table(
                            columnWidths: {
                              0: FlexColumnWidth(5),
                              1: FlexColumnWidth(4),
                              2: FlexColumnWidth(5),
                            },
                            children: [
                              TableRow(
                                children: [
                                  TableCell(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 8.0, horizontal: 2.0),
                                      child: item['value'] == 'progress'
                                          ? Text(
                                              'Belum dibayar',
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.normal),
                                            )
                                          : SizedBox
                                              .shrink(), // Render nothing if not completed
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 8.0, horizontal: 2.0),
                                      child: item['value'] == 'progress'
                                          ? Container(
                                              width: 120,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(7.0),
                                                border: Border.all(
                                                    color: Colors.red),
                                              ),
                                              child: Material(
                                                borderRadius:
                                                    BorderRadius.circular(7.0),
                                                color: Colors.white,
                                                shadowColor: Colors.grey[350],
                                                elevation: 5,
                                                child: MaterialButton(
                                                  onPressed: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            DetailHistoryPage(
                                                                itemId:
                                                                    item['id']),
                                                      ),
                                                    );
                                                  },
                                                  child: Text(
                                                    'Detail',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.red[900]),
                                                  ),
                                                ),
                                              ),
                                            )
                                          : SizedBox
                                              .shrink(), // Render nothing if not in progress
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 8.0, horizontal: 2.0),
                                      child: Container(
                                        width: 120,
                                        child: Material(
                                          borderRadius:
                                              BorderRadius.circular(7.0),
                                          color: (item['value'] == 'completed')
                                              ? Colors.red[900]
                                              : Color.fromARGB(
                                                  255, 161, 158, 158),
                                          shadowColor: Colors.grey[350],
                                          elevation: 5,
                                          child: MaterialButton(
                                            onPressed: () async {
                                              // Handle button press logic here
                                            },
                                            child: Text(
                                              'Download',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: (item['value'] ==
                                                        'completed')
                                                    ? Colors.white
                                                    : Colors.grey[700],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}
