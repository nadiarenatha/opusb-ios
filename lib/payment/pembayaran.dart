import 'package:flutter/material.dart';
import 'package:niaga_apps_mobile/screen/profile.dart';
import '../screen-niaga/home_screen_niaga.dart';
import '../screen-niaga/invoice_home_niaga.dart';
import '../screen-niaga/order_niaga.dart';
import '../screen-niaga/tracking_home_niaga.dart';

class PembayaraNiagaPage extends StatefulWidget {
  const PembayaraNiagaPage({Key? key}) : super(key: key);

  @override
  State<PembayaraNiagaPage> createState() => _PembayaraNiagaPageState();
}

class _PembayaraNiagaPageState extends State<PembayaraNiagaPage> {
  @override

  //untuk BottomNavigationBarItem
  int _selectedIndex = 0;

  //untuk BottomNavigationBarItem
  // static List<Widget> _widgetOptions = <Widget>[
  //   OrderHomeNiagaPage(),
  //   TrackingHomeNiagaPage(resiNumber: 'your_resi_number_here'),
  //   HomePageScreenNiaga(qrResult: null, resiNumber: 'masukkan nomor resi'),
  //   MyInvoiceHomeNiagaPage(),
  //   ProfilePage(),
  // ];

  //untuk BottomNavigationBarItem
  // void _onItemTapped(int index) {
  //   setState(() {
  //     _selectedIndex = index;
  //   });
  //   switch (index) {
  //     case 0:
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(builder: (context) => OrderHomeNiagaPage()),
  //       );
  //       break;
  //     case 1:
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //             builder: (context) =>
  //                 TrackingHomeNiagaPage(resiNumber: 'your_resi_number_here')),
  //       );
  //       break;
  //     case 2:
  //       Navigator.pop(
  //         context,
  //         MaterialPageRoute(
  //             builder: (context) => HomePageScreenNiaga(
  //                 qrResult: null, resiNumber: 'masukkan nomor resi')),
  //       );
  //       break;
  //     case 3:
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(builder: (context) => MyInvoiceHomeNiagaPage()),
  //       );
  //       break;
  //     case 4:
  //       Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(builder: (context) => ProfilePage()),
  //       );
  //       break;
  //   }
  // }

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
                  "Pembayaran",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.red[900],
                    fontFamily: 'Poppin',
                    fontWeight: FontWeight.w900,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          toolbarHeight: 0.07 * MediaQuery.of(context).size.height,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Policy 1',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
              ),
              SizedBox(height: 10),
              Text(
                'Niaga Logistics telah bergerak dalam bidang jasa pengurusan transportasi sejak tahun 1978 dengan nama CV. Saranabhakti Timur. Pada tahun 2011, kami berubah menjadi PT. JPT Saranabhakti Timur yang memiliki brand name Niaga Logistics. Niaga Logistics memiliki Head Office di Kalianak, Surabaya. Kami memberikan layanan pengiriman FCL dan LCL menuju ke lokasi di Indonesia Timur. Cabangcabang kami terletak di pada wilayah distribusi kami, yaitu di Makassar, Menado, Kendari, Palu, Sorong, Timika, Jayapura, dan Manokwari . Kami juga memiliki kantor representatif di Jakarta untuk membantu klien kami yang berada di Ibukota',
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 40),
              Text(
                'Policy 2',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
              ),
              SizedBox(height: 10),
              Text(
                'Sebagai pilihan utama dalam memberikan solusi logistik terintegrasi di Indonesia',
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 40),
              Text(
                'Policy 3',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
              ),
              SizedBox(height: 10),
              Text(
                'Menyediakan jasa ekspedisi yang terpercaya dan sesuai dengan kebutuhan pelanggan melalui jaringan kerja yang representatif, teknologi informasi yang handal dan SDM yang kompeten',
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 60),
              Center(
                child: Material(
                  borderRadius: BorderRadius.circular(7.0),
                  color: Colors.red[900],
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
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
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
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.dashboard), label: 'Order'),
            BottomNavigationBarItem(
              icon: SizedBox(
                width: 20,
                child: ImageIcon(
                  AssetImage('assets/tracking icon.png'),
                ),
              ),
              label: 'Tracking',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
              icon: SizedBox(
                width: 12,
                child: ImageIcon(
                  AssetImage('assets/invoice icon.png'),
                ),
              ),
              label: 'Invoice',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.grey[600],
          // unselectedItemColor: Colors.grey[600],
          // onTap: _onItemTapped,
        ),
      ),
    );
  }
}
