import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:niaga_apps_mobile/screen/line_title.dart';
import 'package:niaga_apps_mobile/screen/profile.dart';
// import 'package:niaga_apps_mobile/Invoice/search_my_invoice.dart';
// import 'detail_my_invoice.dart';
import 'package:niaga_apps_mobile/screen/home.dart';
import 'package:niaga_apps_mobile/screen/profile.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  //untuk BottomNavigationBarItem
  int _selectedIndex = 0;
  //untuk calendar pada pop up dialog search dengan nama _dateController
  //2 nama berbeda karena tgl di calendar berbeda
  TextEditingController _dateController1 = TextEditingController();
  TextEditingController _dateController2 = TextEditingController();

//untuk warna grafik
  final List<Color> gradientColors = [
    const Color(0XFF1565C0),
    const Color(0xFF42A5F5),
  ];

  //untuk membuat lingkaran besar merah
  double getBigDiameter(BuildContext context) =>
      MediaQuery.of(context).size.width * 4 / 8;

  //untuk BottomNavigationBarItem
  static List<Widget> _widgetOptions = <Widget>[
    DashboardPage(),
    HomePage(),
    ProfilePage(),
  ];

  //untuk BottomNavigationBarItem
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.pushReplacement(
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

  Widget build(BuildContext context) {
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
              padding: EdgeInsets.only(left: 16, bottom: 15),
              child: Text(
                'Dashboard',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.red[900],
                    fontFamily: 'Poppin',
                    fontWeight: FontWeight.w900),
              ),
            ),
            leading: Container(),
          ),
        ),
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Column(
                children: [
                  //Total jumlah Barang dll
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        //Total jumlah Barang
                        Container(
                          margin: EdgeInsets.all(16),
                          //setting tinggi & lebar container grey
                          height: mediaQuery.size.height * 0.18,
                          width: mediaQuery.size.height * 0.3,
                          decoration: BoxDecoration(
                              color: Colors.lime[600],
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
                          //untuk form
                          child: Stack(
                            children: [
                              // Main content
                              Padding(
                                padding: EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text("Total Jumlah Barang dalam Gudang",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontFamily: 'Poppin',
                                            fontWeight: FontWeight.bold)),
                                    Row(
                                      children: [
                                        Text("1381",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontFamily: 'Poppin',
                                                fontWeight: FontWeight.bold)),
                                        Expanded(
                                          child: Align(
                                            alignment: Alignment.bottomRight,
                                            child: Material(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              color:
                                                  Colors.grey.withOpacity(0.1),
                                              //membuat bayangan pada button kirim
                                              shadowColor: Colors.grey[350],
                                              elevation: 5,
                                              child: MaterialButton(
                                                onPressed: () {},
                                                child: Text(
                                                  'Selengkapnya',
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        //Dalam perjalanan
                        Container(
                          margin: EdgeInsets.all(4),
                          //setting tinggi & lebar container grey
                          height: mediaQuery.size.height * 0.18,
                          width: mediaQuery.size.height * 0.3,
                          decoration: BoxDecoration(
                              color: Colors.brown[200],
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
                          //untuk form
                          child: Stack(
                            children: [
                              // Main content
                              Padding(
                                padding: EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text("Jumlah Kontainer dalam Perjalanan",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontFamily: 'Poppin',
                                            fontWeight: FontWeight.bold)),
                                    Row(
                                      children: [
                                        Text("8",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontFamily: 'Poppin',
                                                fontWeight: FontWeight.bold)),
                                        Expanded(
                                          child: Align(
                                            alignment: Alignment.bottomRight,
                                            child: Material(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              color:
                                                  Colors.grey.withOpacity(0.1),
                                              //membuat bayangan pada button kirim
                                              shadowColor: Colors.grey[350],
                                              elevation: 5,
                                              child: MaterialButton(
                                                onPressed: () {},
                                                child: Text(
                                                  'Selengkapnya',
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        //Perkiraan Tagihan
                        Container(
                          margin: EdgeInsets.all(16),
                          //setting tinggi & lebar container grey
                          height: mediaQuery.size.height * 0.18,
                          width: mediaQuery.size.height * 0.3,
                          decoration: BoxDecoration(
                              color: Colors.indigo[100],
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
                          //untuk form
                          child: Stack(
                            children: [
                              // Main content
                              Padding(
                                padding: EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text("Perkiraan Tagihan yang Akan Datang",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontFamily: 'Poppin',
                                            fontWeight: FontWeight.bold)),
                                    Row(
                                      children: [
                                        Text("Rp 1.000.000",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontFamily: 'Poppin',
                                                fontWeight: FontWeight.bold)),
                                        Expanded(
                                          child: Align(
                                            alignment: Alignment.bottomRight,
                                            child: Material(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              color:
                                                  Colors.grey.withOpacity(0.1),
                                              //membuat bayangan pada button kirim
                                              shadowColor: Colors.grey[350],
                                              elevation: 5,
                                              child: MaterialButton(
                                                onPressed: () {},
                                                child: Text(
                                                  'Selengkapnya',
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  //untuk tulisan grafik
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 22),
                      child: Text(
                        'Total Pengiriman Minggu Ini',
                        style: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Poppin',
                            fontSize: 20),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  //untuk tulisan lastweek dll
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 26),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Last Week',
                            style: TextStyle(
                                color: Colors.grey[400],
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Poppin',
                                fontSize: 16),
                          ),
                          Text(
                            'Periode 15/04/2024 - 21/04/2024',
                            style: TextStyle(
                                color: Colors.grey[400],
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Poppin',
                                fontSize: 16),
                          ),
                          Text(
                            '7 Pengiriman',
                            style: TextStyle(
                                color: Colors.grey[400],
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Poppin',
                                fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                  //Grafik
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 30.0,
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 5, 35, 5),
                          width: 400, // Set the width of the chart
                          height: 250,
                          child: LineChart(LineChartData(
                              minX: 0,
                              maxX: 6,
                              minY: 0,
                              maxY: 8,
                              titlesData: LineTitles.getTitleData(),
                              //untuk memberi garis horizontal abu2
                              gridData: FlGridData(
                                  show: true,
                                  getDrawingHorizontalLine: (value) {
                                    return FlLine(
                                        color: Colors.grey[350],
                                        strokeWidth: 2);
                                  }),
                              //untuk set titik spot grafik
                              lineBarsData: [
                                LineChartBarData(
                                  spots: [
                                    FlSpot(0, 0),
                                    FlSpot(1, 7),
                                    FlSpot(2, 0),
                                    FlSpot(3, 0),
                                    FlSpot(4, 0),
                                    FlSpot(5, 0),
                                    FlSpot(6, 0),
                                  ],
                                  isCurved: true,
                                  // colors: gradientColors,
                                  // color: gradientColors,
                                  gradient:
                                      LinearGradient(colors: gradientColors),
                                  barWidth: 2,
                                ),
                              ])),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  //utuk text pengiriman terbaru
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 22),
                      child: Text(
                        'Pengiriman Terbaru',
                        style: TextStyle(
                            color: Colors.grey[400],
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Poppin',
                            fontSize: 20),
                      ),
                    ),
                  ),
                  //Pengiriman terbaru
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        //Pengiriman 1
                        Container(
                          margin: EdgeInsets.all(16),
                          //setting tinggi & lebar container putih
                          height: mediaQuery.size.height * 0.18,
                          width: mediaQuery.size.height * 0.3,
                          decoration: BoxDecoration(
                              color: Colors.white,
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
                          //cliprect agar lingkaran merah ada lengkungan
                          //jika tdk pakai nanti jadi kotak
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                                getBigDiameter(context) / 10),
                            child: Stack(
                              children: [
                                // Main content
                                Padding(
                                  padding: EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "DOOR TO DOOR",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 20,
                                                fontFamily: 'Poppin',
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            "STUFFING LUAR - 40FT",
                                            style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 12,
                                                fontFamily: 'Poppin',
                                                fontWeight: FontWeight.normal),
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            "Penerima",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12,
                                                fontFamily: 'Poppin',
                                                fontWeight: FontWeight.normal),
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            "TOMPOTIKA RAYA\nPARE PARE", // Use \n for line break
                                            maxLines: 2, // Set maxLines to 2
                                            overflow: TextOverflow
                                                .ellipsis, // Add ellipsis if text exceeds 2 lines
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12,
                                                fontFamily: 'Poppin',
                                                fontWeight: FontWeight.normal),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                //untuk membuat lingkaran merah DOOR to DOOR
                                Stack(
                                  children: [
                                    Positioned(
                                      // untuk membuat lingkaran besar di pojok kanan yg berwarna transparan
                                      right: -getBigDiameter(context) / 2,
                                      //untuk naik turun lingkaran (tanda - berarti mundur)
                                      bottom: -getBigDiameter(context) / 7,
                                      child: Container(
                                        width: getBigDiameter(context),
                                        height: getBigDiameter(context),
                                        decoration: BoxDecoration(
                                          shape: BoxShape
                                              .circle, //untuk memberikan shape / bntk
                                          color:
                                              Color.fromRGBO(239, 63, 80, 0.5),
                                        ),
                                        child: Stack(
                                          children: [
                                            //Rute Pengiriman
                                            Positioned(
                                              top: getBigDiameter(context) / 3,
                                              left:
                                                  getBigDiameter(context) / 15,
                                              child: Text(
                                                'Rute Pengiriman', // Add your text here
                                                style: TextStyle(
                                                    color: Colors.grey[200],
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    fontStyle:
                                                        FontStyle.italic),
                                              ),
                                            ),
                                            //SBY
                                            Positioned(
                                              top:
                                                  getBigDiameter(context) / 2.2,
                                              left: getBigDiameter(context) / 4,
                                              child: Text(
                                                'SBY', // Add your text here
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    fontStyle:
                                                        FontStyle.italic),
                                              ),
                                            ),
                                            //MKS
                                            Positioned(
                                              top:
                                                  getBigDiameter(context) / 1.7,
                                              left: getBigDiameter(context) / 4,
                                              child: Text(
                                                'MKS', // Add your text here
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    fontStyle:
                                                        FontStyle.italic),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        //Pengiriman 2
                        Container(
                          margin: EdgeInsets.all(8),
                          //setting tinggi & lebar container putih
                          height: mediaQuery.size.height * 0.18,
                          width: mediaQuery.size.height * 0.3,
                          decoration: BoxDecoration(
                              color: Colors.white,
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
                          //cliprect agar lingkaran merah ada lengkungan
                          //jika tdk pakai nanti jadi kotak
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                                getBigDiameter(context) / 10),
                            child: Stack(
                              children: [
                                // Main content
                                Padding(
                                  padding: EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "DOOR TO DOOR",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 20,
                                                fontFamily: 'Poppin',
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            "STUFFING LUAR - 40FT",
                                            style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 12,
                                                fontFamily: 'Poppin',
                                                fontWeight: FontWeight.normal),
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            "Penerima",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12,
                                                fontFamily: 'Poppin',
                                                fontWeight: FontWeight.normal),
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            "TOMPOTIKA RAYA\nPARE PARE", // Use \n for line break
                                            maxLines: 2, // Set maxLines to 2
                                            overflow: TextOverflow
                                                .ellipsis, // Add ellipsis if text exceeds 2 lines
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12,
                                                fontFamily: 'Poppin',
                                                fontWeight: FontWeight.normal),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                //untuk membuat lingkaran merah DOOR to DOOR
                                Stack(
                                  children: [
                                    Positioned(
                                      // untuk membuat lingkaran besar di pojok kanan yg berwarna transparan
                                      right: -getBigDiameter(context) / 2,
                                      //untuk naik turun lingkaran (tanda - berarti mundur)
                                      bottom: -getBigDiameter(context) / 7,
                                      child: Container(
                                        width: getBigDiameter(context),
                                        height: getBigDiameter(context),
                                        decoration: BoxDecoration(
                                          shape: BoxShape
                                              .circle, //untuk memberikan shape / bntk
                                          color:
                                              Color.fromRGBO(239, 63, 80, 0.5),
                                        ),
                                        child: Stack(
                                          children: [
                                            //Rute Pengiriman
                                            Positioned(
                                              top: getBigDiameter(context) / 3,
                                              left:
                                                  getBigDiameter(context) / 15,
                                              child: Text(
                                                'Rute Pengiriman', // Add your text here
                                                style: TextStyle(
                                                    color: Colors.grey[200],
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    fontStyle:
                                                        FontStyle.italic),
                                              ),
                                            ),
                                            //SBY
                                            Positioned(
                                              top:
                                                  getBigDiameter(context) / 2.2,
                                              left: getBigDiameter(context) / 4,
                                              child: Text(
                                                'SBY', // Add your text here
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    fontStyle:
                                                        FontStyle.italic),
                                              ),
                                            ),
                                            //MKS
                                            Positioned(
                                              top:
                                                  getBigDiameter(context) / 1.7,
                                              left: getBigDiameter(context) / 4,
                                              child: Text(
                                                'MKS', // Add your text here
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    fontStyle:
                                                        FontStyle.italic),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        //Pengiriman 3
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
