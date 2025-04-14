import 'package:flutter/material.dart';
import 'dart:async'; // Import dart:async for Timer

class PembayaranQRIS extends StatefulWidget {
  const PembayaranQRIS({super.key});

  @override
  State<PembayaranQRIS> createState() => _PembayaranQRISState();
}

class _PembayaranQRISState extends State<PembayaranQRIS> {
  // String? _selectedPaymentMethod;
  //untuk timer
  late Timer _timer;
  int _secondsRemaining = 3600; // 1 hour in seconds

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void startTimer() {
    const oneSecond = Duration(seconds: 1);
    _timer = Timer.periodic(oneSecond, (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          timer.cancel();
        }
      });
    });
  }

  String formatTime(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    return '$hours:${minutes.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    // final mediaQuery = MediaQuery.of(context);
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
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    //metode pembayaran
                    Text(
                      'Pembayaran',
                      style: TextStyle(
                          color: Colors.red[900],
                          fontSize: 18,
                          fontWeight: FontWeight.w900),
                    ),
                    SizedBox(
                      height: 45,
                    ),
                    Center(
                      child: Text(
                        'Bayar dalam',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: Container(
                        height: 40,
                        width: 130,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.lightBlue[100],
                        ),
                        //timer
                        child: Center(
                          child: StreamBuilder<int>(
                            stream: Stream.periodic(
                                Duration(seconds: 1), (i) => _secondsRemaining),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Text(
                                  formatTime(snapshot.data!),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                );
                              } else {
                                return Text('0:00',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ));
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Image.asset(
                        'assets/pembayaran qris.png',
                        height: 160.0,
                      ),
                    ),
                    Center(
                      child: Row(
                        // Ensure the row itself is centered
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Tidak dapat scan?',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.w700),
                          ),
                          Text(
                            '  Refresh QR?',
                            style: TextStyle(
                                color: Colors.blue[400],
                                fontSize: 15,
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Text(
                      'Tata cara pembayaran menggunakan QRIS',
                      style: TextStyle(
                          color: Colors.red[900],
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      '1. Buka Aplikasi Pembayaran',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      '2. Pilih QRIS sebagai metode Pembayaran',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      '3. Scan kode QRIS',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      '4. Masukkan nominal transaksi',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      '5. Verifikasi dengan memasukkan kode pin transaksi',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Center(
                child: Column(
                  children: [
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
                        minWidth: 220, // Adjust the width as needed
                        height: 60, // Adjust the height as needed
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'Kembali',
                          style:
                              TextStyle(fontSize: 16, color: Colors.red[900]),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      ),
    );
  }
}

// int _currentStep = 1;
Widget _buildStepItem(String number, String title, int stepNumber) {
  // bool isSelected = _currentStep == stepNumber;
  Color itemColor =
      // isSelected
      stepNumber == 5
          ? (Colors.red[900] ?? Colors.red)
          : (Colors.grey[400] ?? Colors.grey);
  Color textColor =
      // isSelected
      stepNumber == 5 ? Colors.white : Colors.black;

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
