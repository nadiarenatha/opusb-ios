import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:niaga_apps_mobile/profile/profil_niaga.dart';
import '../Invoice/menu_invoice_niaga.dart';
import '../cubit/niaga/daftar_pesanan_cubit.dart';
import '../cubit/niaga/data_login_cubit.dart';
import '../model/data_login.dart';
import '../model/niaga/daftar-pesanan/daftar_pesanan.dart';
import '../model/niaga/daftar-pesanan/ulasan.dart';
import '../order/menu_order_niaga.dart';
import '../screen-niaga/home_niaga.dart';
import '../screen-niaga/order_niaga.dart';
import '../shared/constants.dart';
import '../shared/functions/flutter_secure_storage.dart';
import '../tracking/menu_tracking_niaga.dart';
import 'feedback.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class UlasanNiagaPage extends StatefulWidget {
  final DaftarPesananAccesses pesanan;
  const UlasanNiagaPage({Key? key, required this.pesanan}) : super(key: key);

  @override
  State<UlasanNiagaPage> createState() => _UlasanNiagaPageState();
}

class _UlasanNiagaPageState extends State<UlasanNiagaPage> {
  @override

  //untuk BottomNavigationBarItem
  TextEditingController _ulasanController = TextEditingController();
  int _selectedIndex = 0;
  bool _isFeedbackVisible = false;
  int _rating = 0;
  String? _errorMessage;
  DataLoginAccesses? dataLogin;

  List<UlasanAccesses> ulasanModel = [];

  @override
  void initState() {
    initializeDateFormatting('id_ID', null).then((_) => _fetchAndLoginUser());
    _fetchAndLoginUser();
    BlocProvider.of<DaftarPesananCubit>(context)
        .getUlasan(widget.pesanan.orderNumber);
  }

  Future<void> _fetchAndLoginUser() async {
    // Assuming you retrieve the userId from secure storage
    final userId = await storage.read(
      key: AuthKey.id.toString(),
      aOptions: const AndroidOptions(
        encryptedSharedPreferences: true,
      ),
    ); // Adjust this as needed
    print('User ID retrieved from storage: $userId');
    if (userId != null) {
      // Trigger the dataLogin API call with the userId
      BlocProvider.of<DataLoginCubit>(context).dataLogin(id: int.parse(userId));
    }
  }

  // Function to update the rating
  void _setRating(int rating) {
    setState(() {
      _rating = rating;
      _errorMessage = null;
    });
  }

  // Function to handle submit
  void _submitReview() {
    if (_rating == 0) {
      setState(() {
        _errorMessage =
            "Mohon isi rating terlebih dahulu sebelum mengirim ulasan";
      });
    } else {
      String formatDate(DateTime date) {
        return DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(date.toUtc());
      }

      String formattedDate = formatDate(DateTime.now());
      print("Formatted Date: $formattedDate");

      BlocProvider.of<DaftarPesananCubit>(context).addUlasan(
          dataLogin?.userId ?? 0, //userId
          widget.pesanan.orderNumber.toString(), //orderNumber
          dataLogin?.email ?? '', //email
          _rating, //rating
          _ulasanController.text, //customerFeedback
          // '', //niagaFeedback
          formattedDate, //createdDate
          dataLogin?.email ?? '' //createdBy
          );
      // Proceed with submitting the review
      // Add your submission logic here
      setState(() {
        _errorMessage = null;
      });
      print("Review submitted with rating $_rating");
    }
  }

  Future tambahUlasan() => showDialog(
      context: context,
      builder: (BuildContext context) => Center(
            child: SingleChildScrollView(
              child: AlertDialog(
                  //untuk memberi border melengkung
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  //untuk mengatur letak dari close icon
                  titlePadding: EdgeInsets.zero,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 25, vertical: 3),
                  title: Row(
                    //supaya berada di kanan
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [],
                  ),
                  content: addUlasan()),
            ),
          ));

  addUlasan() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Align content to start
        children: [
          SizedBox(height: 5),
          Center(
            child: SizedBox(
              height: 40.0, // Adjust the height as needed
              child: Image.asset('assets/notif register.png'),
            ),
          ),
          SizedBox(height: 20),
          Center(
            child: Text(
              "Berhasil Kirim Ulasan",
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Poppin',
                  fontWeight: FontWeight.w900),
            ),
          ),
          SizedBox(height: 25),
          Center(
            child: SizedBox(
              width: 150,
              height: 35,
              child: Material(
                borderRadius: BorderRadius.circular(7.0),
                color: Colors.red[900],
                child: MaterialButton(
                  padding: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => OrderHomeNiagaPage()),
                    );
                  },
                  child: Text(
                    "Ok",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      letterSpacing: 1.5,
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //untuk BottomNavigationBarItem
  static List<Widget> _widgetOptions = <Widget>[
    MenuOrderNiagaPage(),
    MenuTrackingNiagaPage(resiNumber: 'your_resi_number_here'),
    HomeNiagaPage(),
    MenuInvoiceNiagaPage(),
    ProfileNiagaPage(),
  ];

  //untuk BottomNavigationBarItem
  void _onItemTapped(int index) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => _widgetOptions[index]),
    );
  }

  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    var pesanan = widget.pesanan;

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
                  "Ulasan",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.red[900],
                      fontFamily: 'Poppins Extra Bold'),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          toolbarHeight: 0.07 * MediaQuery.of(context).size.height,
        ),
      ),
      body: BlocConsumer<DataLoginCubit, DataLoginState>(
          listener: (context, state) async {
        if (state is DataLoginSuccess) {
          setState(() {
            dataLogin = state.response;
          });
          print('Ini Data nya yang akan di ambil : $dataLogin');
        }
      }, builder: (context, state) {
        return BlocConsumer<DaftarPesananCubit, DaftarPesananState>(
            listener: (context, state) async {
          if (state is AddUlasanSuccess || state is GetUlasanSuccess) {
            // Update ulasanModel and UI directly
            setState(() {
              if (state is GetUlasanSuccess) {
                ulasanModel = state.response;
              } else if (state is AddUlasanSuccess) {
                ulasanModel = [state.response];
              }

              if (ulasanModel.isNotEmpty) {
                _ulasanController.text = ulasanModel[0].customerFeedback ?? '';
                _rating = ulasanModel[0].rating ?? 0;
              } else {
                _ulasanController.text = '';
                _rating = 0;
              }
            });
          }
        }, builder: (context, state) {
          if (state is GetUlasanInProgress || state is AddUlasanInProgress) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.amber[600],
              ),
            );
          }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      decoration: BoxDecoration(
                        color: Colors
                            .white, // Background color of the outer container
                        border: Border.all(
                          color: Colors.grey, // Grey border color
                          width: 2.0, // Border width
                        ),
                        borderRadius: BorderRadius.circular(
                            8), // Optional: Add border radius
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Nomor Order',
                              style: TextStyle(
                                  fontFamily: 'Poppinss', fontSize: 14),
                            ),
                            SizedBox(height: 5),
                            Text(
                              // 'COSL/SBY/2024.08/001332/OL',
                              widget.pesanan.orderNumber.toString(),
                              style: TextStyle(
                                  fontFamily: 'Poppins Med',
                                  fontSize: 13,
                                  color: Colors.grey),
                            ),
                            SizedBox(height: 5),
                            Table(
                              columnWidths: {
                                0: FlexColumnWidth(6),
                                1: FlexColumnWidth(6),
                              },
                              children: [
                                TableRow(children: [
                                  TableCell(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 4.0, horizontal: 2.0),
                                      child: Text(
                                        'Jasa/Service',
                                        style: TextStyle(
                                            fontFamily: 'Poppinss',
                                            fontSize: 14),
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 4.0, horizontal: 2.0),
                                      child: Text(
                                        'Tipe Pengiriman',
                                        style: TextStyle(
                                            fontFamily: 'Poppinss',
                                            fontSize: 14),
                                      ),
                                    ),
                                  ),
                                ]),
                                TableRow(children: [
                                  TableCell(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 4.0, horizontal: 2.0),
                                      child: Text(
                                        // 'FCL (Full Container Load)',
                                        widget.pesanan.orderService.toString(),
                                        style: TextStyle(
                                            fontFamily: 'Poppins Med',
                                            fontSize: 13,
                                            color: Colors.grey),
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 4.0, horizontal: 2.0),
                                      child: Text(
                                        // 'DTD (Door to Door)',
                                        widget.pesanan.shipmentType.toString(),
                                        style: TextStyle(
                                            fontFamily: 'Poppins Med',
                                            fontSize: 13,
                                            color: Colors.grey),
                                      ),
                                    ),
                                  ),
                                ]),
                              ],
                            ),
                            // SizedBox(height: 5),
                            Table(
                              columnWidths: {
                                0: FlexColumnWidth(6),
                                1: FlexColumnWidth(6),
                              },
                              children: [
                                TableRow(children: [
                                  TableCell(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 4.0, horizontal: 2.0),
                                      child: Text(
                                        'Pelabuhan Asal',
                                        style: TextStyle(
                                            fontFamily: 'Poppinss',
                                            fontSize: 14),
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 4.0, horizontal: 2.0),
                                      child: Text(
                                        'Pelabuhan Tujuan',
                                        style: TextStyle(
                                            fontFamily: 'Poppinss',
                                            fontSize: 14),
                                      ),
                                    ),
                                  ),
                                ]),
                                TableRow(children: [
                                  TableCell(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 4.0, horizontal: 2.0),
                                      child: Text(
                                        // 'Jakarta',
                                        widget.pesanan.originalCity.toString(),
                                        style: TextStyle(
                                            fontFamily: 'Poppins Med',
                                            fontSize: 13,
                                            color: Colors.grey),
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 4.0, horizontal: 2.0),
                                      child: Text(
                                        // 'Surabaya',
                                        widget.pesanan.destinationCity
                                            .toString(),
                                        style: TextStyle(
                                            fontFamily: 'Poppins Med',
                                            fontSize: 13,
                                            color: Colors.grey),
                                      ),
                                    ),
                                  ),
                                ]),
                              ],
                            )
                          ],
                        ),
                      )),
                  SizedBox(height: 30),
                  // if (!_isFeedbackVisible) ...[
                  //   Text(
                  //     'Ulasan Anda',
                  //     style: TextStyle(
                  //       color: Colors.red[900],
                  //       fontSize: 16,
                  //       fontWeight: FontWeight.w900,
                  //     ),
                  //   ),
                  //   SizedBox(height: 20),
                  //   GestureDetector(
                  //     onTap: () {
                  //       setState(() {
                  //         _isFeedbackVisible = true;
                  //       });
                  //     },
                  //     child: Container(
                  //       padding: EdgeInsets.all(16.0),
                  //       decoration: BoxDecoration(
                  //         border: Border.all(
                  //           color: Color.fromARGB(255, 177, 4, 4),
                  //           width: 2.0,
                  //         ),
                  //         borderRadius: BorderRadius.circular(8.0),
                  //       ),
                  //       child: Center(
                  //         child: Column(
                  //           children: [
                  //             Text(
                  //               'Anda belum memiliki ulasan.',
                  //               style: TextStyle(color: Colors.grey[600]),
                  //             ),
                  //             SizedBox(height: 10),
                  //             Text(
                  //               'Tap disini untuk memberi ulasan',
                  //               style: TextStyle(color: Colors.grey[600]),
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ] else ...[
                  //   feedback(context),
                  // ],
                  //===
                  Text(
                    'Ulasan Anda',
                    style: TextStyle(
                      color: Colors.red[900],
                      fontFamily: 'Poppins Extra Bold',
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return GestureDetector(
                        onTap: ulasanModel.isEmpty
                            ? () {
                                // Update rating only if Full Response = []
                                _setRating(index + 1);
                              }
                            : null,
                        child: Icon(
                          Icons.star,
                          color: index < _rating
                              ? Color.fromARGB(255, 199, 27, 14)
                              : Colors.grey, // Change color based on the rating
                          size: 40,
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.all(6.0),
                    decoration: BoxDecoration(
                      color: Colors
                          .white, // Background color of the outer container
                      border: Border.all(
                        color: Color.fromARGB(
                            255, 173, 27, 16), // Grey border color
                        width: 2.0, // Border width
                      ),
                      borderRadius: BorderRadius.circular(
                          8), // Optional: Add border radius
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // if (ulasanModel.isNotEmpty)
                              //   Padding(
                              //     padding: const EdgeInsets.only(left: 10.0),
                              //     child: Text(
                              //       '${DateFormat('dd/MM/yyyy').format(DateTime.parse(ulasanModel[0].createdDate ?? ''))}',
                              //       style: TextStyle(
                              //           color: Colors.black,
                              //           fontSize: 11,
                              //           fontFamily: 'Poppinss'),
                              //     ),
                              //   ),
                              if (ulasanModel.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: Text(
                                    '${DateFormat('EEEE, dd MMMM yyyy HH.mm', 'id_ID').format(DateTime.parse(ulasanModel[0].createdDate ?? '').toUtc().add(Duration(hours: 7)))} WIB',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 11,
                                        fontFamily: 'Poppinss'),
                                  ),
                                ),
                              TextFormField(
                                controller: _ulasanController,
                                textInputAction: TextInputAction.next,
                                enabled: ulasanModel.isEmpty,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText:
                                        "Klik disini untuk menuliskan ulasan Anda",
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 14.0),
                                    fillColor: Colors.grey[600],
                                    labelStyle: TextStyle(
                                        fontFamily: 'Poppins Med',
                                        fontSize: 15)),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 11,
                                    fontFamily: 'Poppins Med'),
                                maxLines: null,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  if (ulasanModel.isNotEmpty &&
                      ulasanModel[0].niagaFeedback != '')
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Flexible(
                          child: Container(
                            width: screenSize.width * 0.7,
                            padding: EdgeInsets.all(6.0),
                            decoration: BoxDecoration(
                              color: Colors
                                  .white, // Background color of the outer container
                              border: Border.all(
                                color: Color.fromARGB(
                                    255, 173, 27, 16), // Grey border color
                                width: 2.0, // Border width
                              ),
                              borderRadius: BorderRadius.circular(
                                  8), // Optional: Add border radius
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    // DateFormat('dd-MM-yyyy').format(DateTime.parse(ulasanModel[0].updateDate ?? '')),
                                    '${DateFormat('EEEE, dd MMMM yyyy HH.mm', 'id_ID').format(DateTime.parse(ulasanModel[0].updateDate ?? '').toUtc().add(Duration(hours: 7)))} WIB',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 11,
                                        fontFamily: 'Poppinss')),
                                SizedBox(height: 3),
                                Text(
                                  'Oleh ${ulasanModel[0].updateBy ?? ''}',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 11,
                                      fontFamily: 'Poppins Med'),
                                  maxLines: null,
                                ),
                                SizedBox(height: 12),
                                Text(
                                  ulasanModel[0].niagaFeedback ?? '',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 11,
                                      fontFamily: 'Poppins Med'),
                                  // maxLines: null,
                                  // softWrap: true,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  if (ulasanModel.isNotEmpty &&
                      ulasanModel[0].niagaFeedback == '')
                    SizedBox(height: 5),
                  if (ulasanModel.isNotEmpty &&
                      ulasanModel[0].niagaFeedback == '')
                    Text('Anda belum memilki balasan',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 11,
                            fontFamily: 'Poppinss')),
                  if (_errorMessage != null) // Show error message if it exists
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        _errorMessage!,
                        style: TextStyle(
                            color: Colors.red[900],
                            fontFamily: 'Poppinss',
                            fontSize: 11),
                      ),
                    ),
                  SizedBox(height: 150),
                  // Center(
                  //   child: Column(
                  //     children: [
                  //       if (!_isFeedbackVisible) ...[
                  //         // Kembali button when _isFeedbackVisible is false
                  //         Material(
                  //           borderRadius: BorderRadius.circular(7.0),
                  //           color: Colors.white,
                  //           shadowColor: Colors.grey[350],
                  //           elevation: 5,
                  //           child: OutlinedButton(
                  //             style: OutlinedButton.styleFrom(
                  //               minimumSize: Size(200, 50),
                  //               side:
                  //                   BorderSide(color: Colors.red[900]!, width: 2),
                  //               shape: RoundedRectangleBorder(
                  //                 borderRadius: BorderRadius.circular(7.0),
                  //               ),
                  //               backgroundColor: Colors.white,
                  //             ),
                  //             onPressed: () {
                  //               Navigator.of(context).pop();
                  //             },
                  //             child: Text(
                  //               'Kembali',
                  //               style: TextStyle(
                  //                   fontSize: 18, color: Colors.red[900]),
                  //             ),
                  //           ),
                  //         ),
                  //       ] else ...[
                  //         // Batal and Kirim buttons when _isFeedbackVisible is true
                  //         Material(
                  //           borderRadius: BorderRadius.circular(7.0),
                  //           color: Colors.white,
                  //           shadowColor: Colors.grey[350],
                  //           elevation: 5,
                  //           child: OutlinedButton(
                  //             style: OutlinedButton.styleFrom(
                  //               minimumSize: Size(200, 50),
                  //               side:
                  //                   BorderSide(color: Colors.red[900]!, width: 2),
                  //               shape: RoundedRectangleBorder(
                  //                 borderRadius: BorderRadius.circular(7.0),
                  //               ),
                  //               backgroundColor: Colors.white,
                  //             ),
                  //             onPressed: () {
                  //               setState(() {
                  //                 _isFeedbackVisible = false;
                  //               });
                  //             },
                  //             child: Text(
                  //               'Batal',
                  //               style: TextStyle(
                  //                   fontSize: 18, color: Colors.red[900]),
                  //             ),
                  //           ),
                  //         ),
                  //         SizedBox(height: 10),
                  //         Material(
                  //           borderRadius: BorderRadius.circular(7.0),
                  //           color: Colors.red[900],
                  //           shadowColor: Colors.grey[350],
                  //           elevation: 5,
                  //           child: MaterialButton(
                  //             minWidth: 200,
                  //             height: 50,
                  //             onPressed: () {
                  //               // Handle the Kirim action here
                  //             },
                  //             child: Text(
                  //               'Kirim',
                  //               style:
                  //                   TextStyle(fontSize: 18, color: Colors.white),
                  //             ),
                  //           ),
                  //         ),
                  //       ],
                  //     ],
                  //   ),
                  // ),
                  //===
                  Center(
                    child: Column(
                      children: [
                        SizedBox(
                          width: 300,
                          height: 40,
                          child: Material(
                            borderRadius: BorderRadius.circular(7.0),
                            // color: Colors.red[900],
                            color: ulasanModel.isEmpty
                                ? Colors.red[900]
                                : Colors.grey,
                            child: MaterialButton(
                              minWidth: 200,
                              height: 50,
                              // onPressed: _submitReview,
                              onPressed:
                                  ulasanModel.isEmpty ? _submitReview : null,
                              child: Text(
                                'Kirim',
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.white,
                                    fontFamily: 'Poppins Med'),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        SizedBox(
                          width: 300,
                          height: 40,
                          child: Material(
                            borderRadius: BorderRadius.circular(7.0),
                            color: Colors.white,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                minimumSize: Size(200, 50),
                                side: BorderSide(
                                    color: Colors.red[900]!, width: 2),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(7.0),
                                ),
                                backgroundColor: Colors.white,
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                'Kembali',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.red[900],
                                  fontFamily: 'Poppins Med',
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          );
        });
      }),
    );
  }
}
