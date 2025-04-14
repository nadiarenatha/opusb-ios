import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:niaga_apps_mobile/Invoice/my_invoice.dart';
import 'package:niaga_apps_mobile/pemesanan/detail_barang.dart';
import 'package:niaga_apps_mobile/screen/dahboard.dart';
import 'package:niaga_apps_mobile/screen/home.dart';
import 'package:niaga_apps_mobile/screen/profile.dart';
import 'package:niaga_apps_mobile/tracking/tracking.dart';
// import 'package:google_maps_webservice/places.dart';
// import 'package:location/location.dart';

class Pemesanan extends StatefulWidget {
  const Pemesanan({super.key});

  @override
  State<Pemesanan> createState() => _PemesananState();
}

class _PemesananState extends State<Pemesanan> {
  int _selectedIndex = 0;
  bool isSelected = false;
  GoogleMapController? _mapController; // Make _mapController nullable
  Position? _currentPosition;
  TextEditingController _namaPengirimController = TextEditingController();
  TextEditingController _alamatPengirimController = TextEditingController();
  TextEditingController _telpPengirimController = TextEditingController();
  TextEditingController _namaPenerimaController = TextEditingController();
  TextEditingController _alamatPenerimaController = TextEditingController();
  TextEditingController _telpPenerimaController = TextEditingController();

  void dispose() {
    _namaPengirimController.dispose();
    super.dispose();
  }

  static List<Widget> _widgetOptions = <Widget>[
    MyInvoicePage(),
    DashboardPage(),
    HomePage(),
    TrackingPage(),
    ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  void _onItemTapped(int index) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => _widgetOptions[index]),
    );
  }

  // Future<void> _getCurrentLocation() async {
  //   bool serviceEnabled;
  //   LocationPermission permission;

  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     return Future.error('Location services are disabled.');
  //   }

  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       return Future.error('Location permissions are denied');
  //     }
  //   }

  //   if (permission == LocationPermission.deniedForever) {
  //     return Future.error(
  //         'Location permissions are permanently denied, we cannot request permissions.');
  //   }

  //   Position position = await Geolocator.getCurrentPosition();
  //   setState(() {
  //     _currentPosition = position;
  //   });

  //   if (_mapController != null) {
  //     _mapController!.animateCamera(
  //       CameraUpdate.newLatLng(
  //         LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
  //       ),
  //     );
  //   }
  // }

  //===2
  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // Request location permission
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // Proceed with fetching current location
    // Position position = await Geolocator.getCurrentPosition();
    // setState(() {
    //   _currentPosition = position;
    // });

    void _getCurrentLocation() async {
      try {
        Position position = await Geolocator.getCurrentPosition();
        if (mounted) {
          setState(() {
            _currentPosition = position;
          });
        }
      } catch (e) {
        print('Error getting location: $e');
        // Handle any exceptions from Geolocator.getCurrentPosition()
      }
    }

    // Check if _mapController is not null before using it
    if (_mapController != null) {
      _mapController!.animateCamera(
          // CameraUpdate.newLatLng(
          //   LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          // ),
          CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
        ),
        zoom: 14,
      )));
    }
  }
  //==3
  // Future<void> _getCurrentLocation() async {
  //   bool serviceEnabled;
  //   LocationPermission permission;

  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     throw Exception('Location services are disabled.');
  //   }

  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       throw Exception('Location permissions are denied');
  //     }
  //   }

  //   if (permission == LocationPermission.deniedForever) {
  //     throw Exception('Location permissions are permanently denied.');
  //   }

  //   Position position = await Geolocator.getCurrentPosition();
  //   setState(() {
  //     _currentPosition = position;
  //   });

  //   // Initialize map controller and make API calls here
  //   if (_mapController != null) {
  //     _mapController!.animateCamera(
  //       CameraUpdate.newCameraPosition(
  //         CameraPosition(
  //           target: LatLng(
  //             _currentPosition!.latitude,
  //             _currentPosition!.longitude,
  //           ),
  //           zoom: 14,
  //         ),
  //       ),
  //     );

  //     // Example of using Places API to search for nearby places
  //     // final places = GoogleMapsPlaces(apiKey: "YOUR_GOOGLE_MAPS_API_KEY_HERE");
  //     final places =
  //         GoogleMapsPlaces(apiKey: "AIzaSyC3NC-8PdHiQXXPB3kvdA5MAxF9JGrb7CI");
  //     PlacesSearchResponse response = await places.searchNearbyWithRadius(
  //       Location(_currentPosition!.latitude, _currentPosition!.longitude),
  //       1000, // Radius in meters
  //     );

  //     if (response.status == "OK") {
  //       // Process the places data from response.results
  //       for (var place in response.results) {
  //         print(place.name);
  //         print(place.geometry.location.lat);
  //         print(place.geometry.location.lng);
  //       }
  //     } else {
  //       print('Places API request failed with status: ${response.status}');
  //     }
  //   }
  // }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  //====
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

    String namaPengirim = _namaPengirimController.text.trim();
    String telpPengirim = _telpPengirimController.text.trim();
    String alamatPengirim = _alamatPengirimController.text.trim();
    String namaPenerima = _namaPenerimaController.text.trim();
    String telpPenerima = _telpPenerimaController.text.trim();
    String alamatPenerima = _alamatPenerimaController.text.trim();

    if (namaPengirim.isEmpty) {
      errorMessages.add("Nama Pengirim tidak boleh kosong !");
    }
    if (telpPengirim.isEmpty) {
      errorMessages.add("No Telp Pengirim tidak boleh kosong !");
    }
    if (alamatPengirim.isEmpty) {
      errorMessages.add("Alamat Pengirim tidak boleh kosong !");
    }
    if (namaPenerima.isEmpty) {
      errorMessages.add("Nama Penerima tidak boleh kosong !");
    }
    if (telpPenerima.isEmpty) {
      errorMessages.add("No Telp Penerima tidak boleh kosong !");
    }
    if (alamatPenerima.isEmpty) {
      errorMessages.add("Alamat Penerima tidak boleh kosong !");
    }

    if (errorMessages.isNotEmpty) {
      alertKontrak(context, errorMessages);
    } else {
      // Proceed with your logic here if all fields are not empty
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return DetailBarang();
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
                          //===========
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
              Text(
                'Informasi Pengirim',
                style: TextStyle(
                    color: Colors.red[900],
                    fontSize: 20,
                    fontWeight: FontWeight.w700),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Text(
                    'Nama Pengirim',
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
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  border: Border.all(
                    color: Colors.black, // Set border color here
                    width: 1.0, // Set border width here
                  ),
                ),
                //untuk tulisan nama pengirim
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _namaPengirimController,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Masukkan nama pengirim",
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
                    'No Telepon Pengirim',
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 50, // Adjust width as needed
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.red[900],
                      borderRadius: BorderRadius.only(
                        topLeft:
                            Radius.circular(5.0), // Adjust radius as needed
                        bottomLeft:
                            Radius.circular(5.0), // Adjust radius as needed
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '+62',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  // SizedBox(
                  //     width:
                  //         5), // Add some space between the red and white containers
                  Expanded(
                    child: Container(
                      // width: 285,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topRight:
                              Radius.circular(5.0), // Adjust radius as needed
                          bottomRight:
                              Radius.circular(5.0), // Adjust radius as needed
                        ),
                        border: Border.all(
                          color: Colors.black, // Set border color here
                          width: 1.0, // Set border width here
                        ),
                      ),
                      child: TextFormField(
                        controller: _telpPengirimController,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "(8) 000 - 000",
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 15.0),
                          fillColor: Colors.grey[600],
                          labelStyle: TextStyle(fontFamily: 'Montserrat'),
                        ),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14.0,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Text(
                    'Alamat Pengirim',
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
                padding: EdgeInsets.zero,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  border: Border.all(
                    color: Colors.black, // Set border color here
                    width: 1.0, // Set border width here
                  ),
                ),
                //untuk tulisan alamat pengirim
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _alamatPengirimController,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Masukkan alamat pengirim",
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
              Center(
                child: Text(
                  'Atau pilih melalui peta',
                  style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 15,
                      fontWeight: FontWeight.w500),
                ),
              ),
              //Maps
              // _openMap(lat, Long);
              // _getCurrentLocation().then((position) {
              //   _openMap(position.latitude, position.longitude);
              // }).catchError((error) {
              //   setState(() {
              //     locationMessage = 'Error: $error';
              //   });
              // }),
              //--------------------
              // FutureBuilder<Position>(
              //     future: _getCurrentLocation(),
              //     builder: (context, snapshot) {
              //       if (snapshot.connectionState == ConnectionState.waiting) {
              //         return CircularProgressIndicator();
              //       } else if (snapshot.hasError) {
              //         return Text('Error: ${snapshot.error}');
              //       } else if (snapshot.hasData) {
              //         // Successfully obtained position

              //         _openMap(
              //             snapshot.data!.latitude, snapshot.data!.longitude);
              //         return Text('Opening map...');
              //         // }
              //       } else {
              //         return Text('Press the button to get current location');
              //       }
              //     }),
              //------
              // _currentPosition == null
              //     ? Center(child: CircularProgressIndicator())
              //     : Container(
              //         width: 320,
              //         height: 200,
              //         // width: MediaQuery.of(context).size.width,
              //         // height: MediaQuery.of(context).size.height,
              //         child: GoogleMap(
              //           onMapCreated: _onMapCreated,
              //           initialCameraPosition: CameraPosition(
              //             // target: LatLng(_currentPosition!.latitude,
              //             //     _currentPosition!.longitude),
              //             target: LatLng(
              //               _currentPosition!.latitude,
              //               _currentPosition!.longitude,
              //             ),
              //             zoom: 14,
              //           ),
              //           myLocationEnabled: true,
              //           myLocationButtonEnabled: true,
              //         ),
              //       ),
              //================
              // SizedBox(height: 20),
              // Expanded(
              //     child: GoogleMap(
              //         initialCameraPosition: CameraPosition(
              //           target: LatLng(37.42796133580664, -122.085749655962),
              //           zoom: 14,
              //         ),
              //         markers: Set.from([
              //           Marker(
              //             markerId: MarkerId('marker_1'),
              //             position:
              //                 LatLng(37.42796133580664, -122.085749655962),
              //             infoWindow: InfoWindow(title: 'Google Maps Marker'),
              //           )
              //         ]))),
              SizedBox(
                height: 15,
              ),
              Text(
                'Informasi Penerima',
                style: TextStyle(
                    color: Colors.red[900],
                    fontSize: 20,
                    fontWeight: FontWeight.w700),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Text(
                    'Nama Penerima',
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
                //untuk tulisan nama penerima
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _namaPenerimaController,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Masukkan nama penerima",
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
                    'No Telepon Penerima',
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 50, // Adjust width as needed
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.red[900],
                      borderRadius: BorderRadius.only(
                        topLeft:
                            Radius.circular(5.0), // Adjust radius as needed
                        bottomLeft: Radius.circular(5.0),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '+62',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ), // Add some space between the red and white containers
                  Expanded(
                    child: Container(
                      // width: 285,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topRight:
                              Radius.circular(5.0), // Adjust radius as needed
                          bottomRight: Radius.circular(5.0),
                        ),
                        border: Border.all(
                          color: Colors.black, // Set border color here
                          width: 1.0, // Set border width here
                        ),
                      ),
                      child: TextFormField(
                        controller: _telpPenerimaController,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "(8) 000 - 000",
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 15.0),
                          fillColor: Colors.grey[600],
                          labelStyle: TextStyle(fontFamily: 'Montserrat'),
                        ),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14.0,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Text(
                    'Alamat Penerima',
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
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  border: Border.all(
                    color: Colors.black, // Set border color here
                    width: 1.0, // Set border width here
                  ),
                ),
                //untuk tulisan alamat penerima
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _alamatPenerimaController,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Masukkan alamat penerima",
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
              Center(
                child: Text(
                  'Atau pilih melalui peta',
                  style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 15,
                      fontWeight: FontWeight.w500),
                ),
              ),
              SizedBox(
                height: 50,
              ),
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
                      // Navigator.push(context,
                      //     MaterialPageRoute(builder: (context) {
                      //   return detailBarang();
                      // }));
                      //==============
                      validateAndShowAlert(context);
                      setState(() {});
                    },
                    child: Text(
                      'Lanjut',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
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

//============
int _currentStep = 1;
Widget _buildStepItem(String number, String title, int stepNumber) {
  bool isSelected = _currentStep == stepNumber;
  Color itemColor = isSelected
      ? (Colors.red[900] ?? Colors.red)
      : (Colors.grey[400] ?? Colors.grey);
  Color textColor = isSelected ? Colors.white : Colors.black;

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
