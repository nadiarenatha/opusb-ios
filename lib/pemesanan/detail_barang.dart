import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:niaga_apps_mobile/Invoice/my_invoice.dart';
import 'package:niaga_apps_mobile/pemesanan/cek_harga_detail_barang.dart';
import 'package:niaga_apps_mobile/pemesanan/detail_barang_layanan.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/gestures.dart';
import 'package:niaga_apps_mobile/screen/dahboard.dart';
import 'package:niaga_apps_mobile/screen/home.dart';
import 'package:niaga_apps_mobile/screen/profile.dart';
import 'package:niaga_apps_mobile/tracking/tracking.dart';

class DetailBarang extends StatefulWidget {
  // int page;
  const DetailBarang({
    super.key,
    // this.page
  });

  @override
  State<DetailBarang> createState() => _DetailBarangState();
}

class _DetailBarangState extends State<DetailBarang> {
  // Future<Map<String, dynamic>>? futureCities;
  int _selectedIndex = 0;
  bool isSelected = false;
  final TapGestureRecognizer _tapGestureRecognizer = TapGestureRecognizer();
  Future<List<String>>? futureCities;
  Future<List<String>>? futureDestionationCities;
  String? selectedCity;
  String? selectedDestionationCity;
  TextEditingController _dateController = TextEditingController();
  TextEditingController _waktuController = TextEditingController();

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

  String? selectedCargo;
  List<String> cargo = [
    '-- Pilih Tipe Pengiriman --',
    'FCL (Full Container Load)',
    'FTL (Full Truck Load)',
    'LCL (Less Container Load)',
    'LTL (Less Truck Load)',
  ];

  @override
  void dispose() {
    _tapGestureRecognizer.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    futureCities = fetchCities();
    futureDestionationCities = fetchCities();
  }

  Future<List<String>> fetchCities() async {
    final String url =
        'https://parseapi.back4app.com/classes/Indonesiacities_Indonesia_Cities_Database?limit=450&order=asciiname';
    final response = await http.get(
      Uri.parse(url),
      headers: {
        "X-Parse-Application-Id":
            "RJXajp9uNBovjSwW8zyv36HTGuPX8g4e2YaEiHEI", // This is your app's application id
        "X-Parse-REST-API-Key":
            "UIizdXB0kxSk1KizD0snz6Ck6KIi5yU8GH19yqaP", // This is your app's REST API key
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body)['results'];
      List<String> cities =
          data.map((city) => city['name'].toString()).toList();
      return cities;
    } else {
      throw Exception('Failed to fetch cities');
    }
  }

  Future<void> alertKontrak(BuildContext context, List<String> messages) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        titlePadding: EdgeInsets.zero,
        contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
        content: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 350, maxWidth: 300),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Periksa kembali isian Anda:',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w800),
              ),
              SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: messages.asMap().entries.map((entry) {
                  int index = entry.key + 1;
                  String message = entry.value;
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$index. ',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            message,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              'OK',
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  void validateAndShowAlert(BuildContext context) {
    List<String> errorMessages = [];
    String tanggalKirim = _dateController.text.trim();

    if (selectedCity == null || selectedCity!.isEmpty) {
      errorMessages.add("Kota Asal tidak boleh kosong !");
    }
    if (selectedDestionationCity == null || selectedDestionationCity!.isEmpty) {
      errorMessages.add("Kota Tujuan tidak boleh kosong !");
    }
    if (tanggalKirim.isEmpty) {
      errorMessages.add("Tanggal keberangkatan tidak boleh kosong !");
    }
    if (selectedCargo == null || selectedCargo!.isEmpty) {
      errorMessages.add("Tipe Pengiriman tidak boleh kosong !");
    }

    if (errorMessages.isNotEmpty) {
      alertKontrak(context, errorMessages);
    } else {
      // Proceed with your logic here if all fields are not empty
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return DetailBarangLayanan();
      }));
    }
  }

  @override
  Widget build(BuildContext context) {
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
                          // _buildStepItem('1', 'Kontrak Perjanjian'),
                          // _buildSeparator(),
                          // _buildStepItem(
                          //     '2', 'Detail Barang & Layanan Pengiriman'),
                          // _buildSeparator(),
                          // _buildStepItem('3', 'Jadwal Stuffing'),
                          // _buildSeparator(),
                          // _buildStepItem('4', 'Konfirmasi Detail Barang'),
                          // _buildSeparator(),
                          // _buildStepItem('5', 'Pembayaran'),
                          // _buildSeparator(),
                          // _buildStepItem('6', 'Stuffing Barang'),
                          //==========
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
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //kota asal
              Row(
                children: [
                  Text(
                    'Kota Asal',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    '*',
                    style: TextStyle(
                        color: Colors.red[900],
                        fontSize: 15,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              SizedBox(height: 15),
              //================
              FutureBuilder<List<String>>(
                  future: futureCities,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (snapshot.hasData) {
                      //container untuk membuat border pd drop down
                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black, // Set border color here
                            width: 1.0, // Set border width here
                          ),
                          borderRadius: BorderRadius.circular(
                              10.0), // Optional: Add rounded corners
                        ),
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10.0),
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            hintText: 'Pilih Kota Asal',
                          ),
                          value: selectedCity,
                          items: snapshot.data!.map((city) {
                            return DropdownMenuItem<String>(
                              value: city,
                              child: Text(city),
                            );
                          }).toList(),
                          onChanged: (String? value) {
                            setState(() {
                              selectedCity = value;
                            });
                          },
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14.0,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                      );
                    } else {
                      return Text('Press the button to get current location');
                    }
                  }),
              SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    'Kota Tujuan',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    '*',
                    style: TextStyle(
                        color: Colors.red[900],
                        fontSize: 15,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              SizedBox(height: 15),
              FutureBuilder<List<String>>(
                  future: futureDestionationCities,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (snapshot.hasData) {
                      //container untuk membuat border pd drop down
                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black, // Set border color here
                            width: 1.0, // Set border width here
                          ),
                          borderRadius: BorderRadius.circular(
                              10.0), // Optional: Add rounded corners
                        ),
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10.0),
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            hintText: 'Pilih Kota Tujuan',
                          ),
                          value: selectedDestionationCity,
                          items: snapshot.data!.map((city) {
                            return DropdownMenuItem<String>(
                              value: city,
                              child: Text(city),
                            );
                          }).toList(),
                          onChanged: (String? value) {
                            setState(() {
                              selectedDestionationCity = value;
                            });
                          },
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14.0,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                      );
                    } else {
                      return Text('Press the button to get current location');
                    }
                  }),
              SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    'Estimasi Tanggal Keberangkatan',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    '*',
                    style: TextStyle(
                        color: Colors.red[900],
                        fontSize: 15,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Container(
                // width: 320,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  border: Border.all(
                    color: Colors.black, // Set border color here
                    width: 1.0, // Set border width here
                  ),
                ),
                //untuk tulisan nama barang
                child: TextFormField(
                  //controller 1 digunakan untuk input tgl di calendar
                  controller: _dateController,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Masukkan estimasi keberangkatan",
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 15.0),
                      fillColor: Colors.grey[600],
                      labelStyle: TextStyle(fontFamily: 'Montserrat'),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.calendar_today),
                        color: Colors.red[900],
                        onPressed: () => _selectDate(context, _dateController),
                      )),
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14.0,
                      fontFamily: 'Montserrat'),
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    'Tipe Pengiriman',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    '*',
                    style: TextStyle(
                        color: Colors.red[900],
                        fontSize: 15,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              SizedBox(height: 15),
              //container untuk membuat border pd drop down
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black, // Set border color here
                    width: 1.0, // Set border width here
                  ),
                  borderRadius: BorderRadius.circular(
                      10.0), // Optional: Add rounded corners
                ),
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    hintText: 'Pilih tipe pengiriman',
                  ),
                  value: selectedCargo,
                  items: cargo.map((cargo) {
                    return DropdownMenuItem<String>(
                      value: cargo,
                      child: Text(cargo),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      selectedCargo = value;
                    });
                  },
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.0,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ),
              SizedBox(height: 25),
              // cekHarga(context),
              // Text(
              //   'Harga dapat berubah sewaktu-waktu silahkan hubungi sales kami secepatnya untuk melakukan konfirmasi harga.',
              //   style: TextStyle(color: Colors.grey[600]),
              //   textAlign: TextAlign.justify,
              // ),
              // SizedBox(height: 10),
              // Text(
              //   'Skema pengiriman adalah service DOOR TO DOOR, dengan asumsi lokasi pengiriman dan penerima dalam kota.',
              //   style: TextStyle(color: Colors.grey[600]),
              //   textAlign: TextAlign.justify,
              // ),
              // SizedBox(height: 10),
              // Row(
              //   children: [
              //     Expanded(
              //       child: RichText(
              //         text: TextSpan(
              //           style: TextStyle(color: Colors.grey[600]),
              //           children: [
              //             TextSpan(text: 'Saya telah setuju dengan '),
              //             TextSpan(
              //                 text: 'Term and Condition ',
              //                 style: TextStyle(
              //                   color: Colors.red[900],
              //                   fontWeight: FontWeight.w900,
              //                   decoration: TextDecoration.underline,
              //                 ),
              //                 recognizer: _tapGestureRecognizer
              //                   ..onTap = () async {
              //                     const url =
              //                         'https://niaga-logistics.com/news/term-condition-pengiriman/';
              //                     if (await canLaunch(url)) {
              //                       await launch(url);
              //                     } else {
              //                       throw 'Could not launch $url';
              //                     }
              //                   }),
              //             TextSpan(text: 'dari Niaga Logistics'),
              //           ],
              //         ),
              //         textAlign: TextAlign.justify,
              //       ),
              //     ),
              //   ],
              // ),
              SizedBox(height: 50),
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
                        minWidth: 200, // Adjust the width as needed
                        height: 50, // Adjust the height as needed
                        onPressed: () {
                          validateAndShowAlert(context);
                        },
                        child: Text(
                          'Lanjut',
                          style: TextStyle(fontSize: 18, color: Colors.white),
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
                        minWidth: 200, // Adjust the width as needed
                        height: 50, // Adjust the height as needed
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'Kembali',
                          style:
                              TextStyle(fontSize: 18, color: Colors.red[900]),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
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

// int _currentStep = 1;
Widget _buildStepItem(String number, String title, int stepNumber) {
  // bool isSelected = _currentStep == stepNumber;
  Color itemColor =
      // isSelected
      stepNumber == 2
          ? (Colors.red[900] ?? Colors.red)
          : (Colors.grey[400] ?? Colors.grey);
  Color textColor =
      // isSelected
      stepNumber == 2 ? Colors.white : Colors.black;

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
