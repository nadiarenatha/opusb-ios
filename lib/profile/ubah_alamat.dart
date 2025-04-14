import 'package:flutter/material.dart';
import 'package:niaga_apps_mobile/profile/profil_niaga.dart';
import '../Invoice/menu_invoice_niaga.dart';
import '../order/menu_order_niaga.dart';
import '../screen-niaga/home_niaga.dart';
import '../tracking/menu_tracking_niaga.dart';

class UbahAlamatNiagaPage extends StatefulWidget {
  const UbahAlamatNiagaPage({Key? key}) : super(key: key);

  @override
  State<UbahAlamatNiagaPage> createState() => _UbahAlamatNiagaPageState();
}

class _UbahAlamatNiagaPageState extends State<UbahAlamatNiagaPage> {
  @override

  //untuk BottomNavigationBarItem
  int _selectedIndex = 0;
  TextEditingController _namaAlamatController = TextEditingController();
  TextEditingController _namaPICController = TextEditingController();
  TextEditingController _telpPICController = TextEditingController();
  TextEditingController _kotaController = TextEditingController();
  TextEditingController _alamatController = TextEditingController();

  //untuk BottomNavigationBarItem
  static List<Widget> _widgetOptions = <Widget>[
    MenuOrderNiagaPage(),
    MenuTrackingNiagaPage(resiNumber: 'your_resi_number_here'),
    HomeNiagaPage(),
    MenuInvoiceNiagaPage(),
    ProfileNiagaPage(),
  ];

  void _onItemTapped(int index) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => _widgetOptions[index]),
    );
  }

  String? selectedTipeAlamat;
  final List<String> tipeAlamatList = [
    'Muat',
    'Bongkar',
  ];

  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    _namaAlamatController.text = "Alamat Muat Surabaya";
    _namaPICController.text = "Budi Sulistiyono";
    _telpPICController.text = "085799852301";
    _kotaController.text = "Surabaya, Surabaya, Jatim, SBY";
    _alamatController.text =
        "Jl. Rungkut Madya 59, RT 09 RW 16, Rungkut, Surabaya, Jawa Timur";
    selectedTipeAlamat = 'Muat';

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
                    "Ubah Alamat",
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
                Row(
                  children: [
                    Text(
                      'Daftar Alamat',
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
                SizedBox(height: 10),
                Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    border: Border.all(
                      color: Colors.black, // Set border color here
                      width: 1.0, // Set border width here
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _namaAlamatController,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Masukkan nama alamat",
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 14.0),
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
                SizedBox(height: 20),
                Row(
                  children: [
                    Text(
                      'Tipe Alamat',
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
                SizedBox(height: 10),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 6), // Reduced padding
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: DropdownButtonFormField<String>(
                    value: selectedTipeAlamat,
                    hint: Text(
                      'Pilih Tipe Alamat',
                      style: TextStyle(fontSize: 14), // Reduced font size
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedTipeAlamat = newValue;
                      });
                    },
                    items: tipeAlamatList
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value,
                            style:
                                TextStyle(fontSize: 14)), // Reduced font size
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      // Reduced content padding
                      contentPadding: EdgeInsets.symmetric(horizontal: 6),
                      border: InputBorder.none, // Remove the default border
                    ),
                    iconSize: 20, // Reduce the size of the dropdown arrow
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Text(
                      'Nama PIC',
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
                SizedBox(height: 10),
                Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    border: Border.all(
                      color: Colors.black, // Set border color here
                      width: 1.0, // Set border width here
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _namaPICController,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Masukkan nama PIC",
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 14.0),
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
                SizedBox(height: 20),
                Row(
                  children: [
                    Text(
                      'Nomor Telepon PIC',
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
                SizedBox(height: 10),
                Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    border: Border.all(
                      color: Colors.black, // Set border color here
                      width: 1.0, // Set border width here
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _telpPICController,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Masukkan no telp PIC",
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 14.0),
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
                SizedBox(height: 20),
                Row(
                  children: [
                    Text(
                      'Kota',
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
                SizedBox(height: 10),
                Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    border: Border.all(
                      color: Colors.black, // Set border color here
                      width: 1.0, // Set border width here
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _kotaController,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Masukkan kota",
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 14.0),
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
                SizedBox(height: 20),
                Row(
                  children: [
                    Text(
                      'Alamat',
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
                SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    border: Border.all(
                      color: Colors.black, // Set border color here
                      width: 1.0, // Set border width here
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _alamatController,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Masukkan alamat",
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 14.0),
                            fillColor: Colors.grey[600],
                            labelStyle: TextStyle(fontFamily: 'Montserrat'),
                          ),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14.0,
                            fontFamily: 'Montserrat',
                          ),
                          maxLines:
                              null, // Allows the TextFormField to grow vertically
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: Material(
                        borderRadius: BorderRadius.circular(7.0),
                        color: Colors.white,
                        shadowColor: Colors.grey[350],
                        elevation: 5,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            minimumSize: Size(200, 50),
                            side: BorderSide(color: Colors.red[900]!, width: 2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7.0),
                            ),
                            backgroundColor: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'Batal',
                            style:
                                TextStyle(fontSize: 18, color: Colors.red[900]),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
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
                            'Simpan',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
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
        //     selectedItemColor: Colors.grey[600],
        //     // unselectedItemColor: Colors.grey[600],
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
                icon: Icon(Icons.dashboard),
                label: 'Order',
              ),
              const BottomNavigationBarItem(
                icon: SizedBox(
                  width: 20,
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
                      color: Colors.white,
                    ),
                  ],
                ),
                label: '',
              ),
              const BottomNavigationBarItem(
                icon: SizedBox(
                  width: 12,
                  child: ImageIcon(
                    AssetImage('assets/invoice icon.png'),
                  ),
                ),
                label: 'Invoice',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profil',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.grey[600],
            onTap: _onItemTapped,
          ),
        ));
  }
}
