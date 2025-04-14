import 'package:flutter/material.dart';
import 'package:niaga_apps_mobile/Invoice/my_invoice.dart';
import 'package:niaga_apps_mobile/pemesanan/jadwal_stuffing.dart';
import 'package:niaga_apps_mobile/screen/dahboard.dart';
import 'package:niaga_apps_mobile/screen/home.dart';
import 'package:niaga_apps_mobile/screen/profile.dart';
import 'package:niaga_apps_mobile/tracking/tracking.dart';

class DetailBarangLayanan extends StatefulWidget {
  const DetailBarangLayanan({super.key});

  @override
  State<DetailBarangLayanan> createState() => _DetailBarangLayananState();
}

class _DetailBarangLayananState extends State<DetailBarangLayanan> {
  int _selectedIndex = 0;
  bool isSelected = false;
  TextEditingController _namaBarangController = TextEditingController();
  TextEditingController _deskripsiBarangController = TextEditingController();
  TextEditingController _tipePengirimanController = TextEditingController();
  TextEditingController _tipeLayananController = TextEditingController();

  String? selectedCargo;
  List<String> cargo = [
    '-- Pilih Tipe Pengiriman --',
    'FCL (Full Container Load)',
    'FTL (Full Truck Load)',
    'LCL (Less Container Load)',
    'LTL (Less Truck Load)',
    // Add more cities as needed
  ];

  String? selectedService;
  List<String> service = [
    '-- Pilih Tipe Layanan --',
    'DTD (Door To Door)',
    'TDI (Trucking Domestic Inbound)',
    'DDI (Dooring Domestic Inbound)',
    // Add more cities as needed
  ];

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
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 2.0),
                            child: Text(
                              message,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600),
                            ),
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

    String namaBarang = _namaBarangController.text.trim();
    String deskripsiBarang = _deskripsiBarangController.text.trim();
    // String tipePengiriman = _tipePengirimanController.text.trim();
    // String tipeLayanan = _tipeLayananController.text.trim();

    if (namaBarang.isEmpty) {
      errorMessages.add("Nama Barang tidak boleh kosong !");
    }
    if (deskripsiBarang.isEmpty) {
      errorMessages.add("Deskripsi Barang tidak boleh kosong !");
    }
    if (selectedCargo == null || selectedCargo!.isEmpty) {
      errorMessages.add("Tipe Pengiriman tidak boleh kosong !");
    }
    if (selectedService == null || selectedService!.isEmpty) {
      errorMessages.add("Tipe Layanan tidak boleh kosong !");
    }

    if (errorMessages.isNotEmpty) {
      alertKontrak(context, errorMessages);
    } else {
      // Proceed with your logic here if all fields are not empty
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return JadwalStuffing();
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
              //nama barang
              Row(
                children: [
                  Text(
                    'Nama Barang',
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
              SizedBox(
                height: 15,
              ),
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
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _namaBarangController,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Masukkan nama barang",
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 15.0),
                            fillColor: Colors.grey[600],
                            labelStyle: TextStyle(fontFamily: 'Montserrat')),
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14.0,
                            fontFamily: 'Montserrat'),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              //deskripsi barang
              Row(
                children: [
                  Text(
                    'Deskripsi Barang',
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
              SizedBox(
                height: 15,
              ),
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
                //untuk tulisan deskripsi barang
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _deskripsiBarangController,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Masukkan deskripsi barang",
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 15.0),
                            fillColor: Colors.grey[600],
                            labelStyle: TextStyle(fontFamily: 'Montserrat')),
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14.0,
                            fontFamily: 'Montserrat'),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
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
                  IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                                backgroundColor: Colors.red[900],
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0)),
                                //untuk mengatur letak dari close icon
                                titlePadding: EdgeInsets.zero,
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 25, vertical: 3),
                                title: Row(
                                  //supaya berada di kanan
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                        icon: Icon(Icons.close),
                                        color: Colors.white,
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        })
                                  ],
                                ),
                                content: ConstrainedBox(
                                    constraints: BoxConstraints(
                                        maxHeight: 800, maxWidth: 300),
                                    child: Form(
                                        child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            //tipe pengiriman
                                            Text(
                                              "Tipe Pengiriman",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: 'Poppin',
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w800),
                                            ),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            Text(
                                              "Tipe pengiriman yang digunakan pada Niaga Logistic adalah FCL (Full Container Load), LCL (Less Container Load), FTL ( Full Truck Load), dan LTL (Less Truck Load).",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: 'Poppin',
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            Text(
                                              "Pengiriman menggunakan LCL/LTL akan dilakukan Stuffing Luar di  lokasi pengirim.",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: 'Poppin',
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ]),
                                    ))));
                          });
                    },
                    icon: Icon(Icons.help_outline),
                    color: Colors.red[900],
                  )
                ],
              ),
              SizedBox(
                height: 15,
              ),
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
              SizedBox(
                height: 20,
              ),
              //tipe layanan
              Row(
                children: [
                  Text(
                    'Tipe Layanan',
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
                  IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                                backgroundColor: Colors.red[900],
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0)),
                                //untuk mengatur letak dari close icon
                                titlePadding: EdgeInsets.zero,
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 25, vertical: 3),
                                title: Row(
                                  //supaya berada di kanan
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                        icon: Icon(Icons.close),
                                        color: Colors.white,
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        })
                                  ],
                                ),
                                content: ConstrainedBox(
                                    constraints: BoxConstraints(
                                        maxHeight: 800, maxWidth: 300),
                                    child: Form(
                                        child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            //tipe layanan
                                            Text(
                                              "Tipe Layanan",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: 'Poppin',
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w800),
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            Text(
                                              "Tipe pengiriman yang digunakan pada Niaga Logistic DTD (Door To Door), TDI (Trucking Domestic Inbound), dan DDI (Dooring Domestic Inbound)",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: 'Poppin',
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ]),
                                    ))));
                          });
                    },
                    icon: Icon(Icons.help_outline),
                    color: Colors.red[900],
                  )
                ],
              ),
              SizedBox(
                height: 15,
              ),
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
                    hintText: 'Pilih tipe layanan',
                  ),
                  value: selectedService,
                  items: service.map((service) {
                    return DropdownMenuItem<String>(
                      value: service,
                      child: Text(service),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      selectedService = value;
                    });
                  },
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.0,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              //tombol lanjut & kembali
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
                          // Navigator.push(context,
                          //     MaterialPageRoute(builder: (context) {
                          //   return jadwalStuffing();
                          // }));

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

int _currentStep = 1;
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
