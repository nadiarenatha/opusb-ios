import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../Invoice/menu_invoice_niaga.dart';
import '../cubit/niaga/contract_cubit.dart';
import '../cubit/niaga/create_order_cubit.dart';
import '../cubit/niaga/syarat_ketentuan_cubit.dart';
import '../model/niaga/poin.dart';
import '../model/niaga/syarat_ketentuan.dart';
import '../order/menu_order_niaga.dart';
import '../profile/profil_niaga.dart';
import '../screen-niaga/home_niaga.dart';
import '../tracking/menu_tracking_niaga.dart';
import 'notif_fcl.dart';
import 'package:intl/intl.dart';

class KonfirmasiFCL extends StatefulWidget {
  // final String? orderNumber;
  final String ukuranContainer;
  final String kontrak;
  final int jumlahContainer;
  final String deskripsiProduk;
  final String komoditi;
  final double totalBerat;
  final String kotaAsal;
  final String kotaTujuan;
  final String tanggalCargo;
  final String namaAlamatMuat;
  final String detailAlamatMuat;
  final String picMuat;
  final String telpPicMuat;
  final String namaAlamatBongkar;
  final String detailAlamatBongkar;
  final String picBongkar;
  final String telpPicBongkar;
  final int harga;
  final String portAsal;
  final String portTujuan;
  final String namaKontrak;
  final String email;
  final int userId;
  final String locIDPortAsal;
  final String locIDPortTujuan;
  final String locIDUOCAsal;
  final String locIDUOCTujuan;
  final bool poin;
  final int hargaContract;
  final int estimasiNilaiProduk;
  final String estimasiClosing;
  // const KonfirmasiFCL({super.key});
  // const KonfirmasiFCL({Key? key, required this.orderNumber}) : super(key: key);
  const KonfirmasiFCL({
    Key? key,
    required this.ukuranContainer,
    required this.kontrak,
    required this.jumlahContainer,
    required this.deskripsiProduk,
    required this.komoditi,
    required this.totalBerat,
    required this.kotaAsal,
    required this.kotaTujuan,
    required this.tanggalCargo,
    required this.namaAlamatMuat,
    required this.detailAlamatMuat,
    required this.picMuat,
    required this.telpPicMuat,
    required this.namaAlamatBongkar,
    required this.detailAlamatBongkar,
    required this.picBongkar,
    required this.telpPicBongkar,
    required this.harga,
    required this.portAsal,
    required this.portTujuan,
    required this.namaKontrak,
    required this.email,
    required this.userId,
    required this.locIDPortAsal,
    required this.locIDPortTujuan,
    required this.locIDUOCAsal,
    required this.locIDUOCTujuan,
    required this.poin,
    required this.hargaContract,
    required this.estimasiNilaiProduk,
    required this.estimasiClosing,
  }) : super(key: key);

  @override
  State<KonfirmasiFCL> createState() => _KonfirmasiFCLState();
}

class _KonfirmasiFCLState extends State<KonfirmasiFCL> {
  int _selectedIndex = 0;
  bool isSelected = false;
  //check list box
  bool _isChecked = false;
  //Simpan Poin
  PoinAccesses? cekPoin;
  String? poinValue;
  List<SyaratKetentuanAccesses> syaratKetentuanList = [];

  void dispose() {
    // _namaPengirimController.dispose();
    super.dispose();
  }

  static List<Widget> _widgetOptions = <Widget>[
    MenuOrderNiagaPage(),
    MenuTrackingNiagaPage(resiNumber: 'your_resi_number_here'),
    HomeNiagaPage(),
    MenuInvoiceNiagaPage(),
    ProfileNiagaPage(),
  ];

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ContractNiagaCubit>(context).cekPoin();
    print('point nya yang di dapat: ${widget.poin}');
    BlocProvider.of<SyaratKetentuanCubit>(context).syaratKetentuan(true);
  }

  void _onItemTapped(int index) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => _widgetOptions[index]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
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
          titleSpacing: 0,
          title: Text(
            "Pemesanan FCL",
            style: TextStyle(
                fontSize: 16,
                color: Colors.red[900],
                fontFamily: 'Poppins Extra Bold'),
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(50.0),
            child: Padding(
              // padding: EdgeInsets.all(20.0),
              padding:
                  EdgeInsets.only(left: 20.0, right: 20, bottom: 20, top: 10),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildStepItem('1.', 'Rute', 1),
                    _buildSeparator(),
                    _buildStepItem('2.', 'Detail', 2),
                    _buildSeparator(),
                    _buildStepItem('3.', 'Summary', 3),
                    _buildSeparator(),
                    _buildStepItem('4.', 'Konfirmasi', 4),
                  ],
                ),
              ),
            ),
          ),
          toolbarHeight: 0.08 * MediaQuery.of(context).size.height,
        ),
      ),
      body: BlocConsumer<CreateOrderCubit, CreateOrderState>(
          listener: (context, state) {
        if (state is CreateOrderFCLSuccess && _isChecked) {
          final orderNumber = state.response.orderNumber;
          final point = widget.poin == true ? 1 : 0;
          print('point push order: $point');

          context.read<CreateOrderCubit>().pushOrder(orderNumber ?? '', point);
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return NotifFCL(orderNumber: orderNumber);
          }));
        }
      }, builder: (context, state) {
        if (state is CreateOrderFCLInProgress) {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.amber[600],
            ),
          );
        }
        if (state is PushOrderSuccess) {
          // Print the success message or response
          print('PushOrderSuccess: ${state.response}');
        }
        return BlocConsumer<ContractNiagaCubit, ContractNiagaState>(
            listener: (context, state) async {
          if (state is CekPoinSuccess) {
            setState(() {
              cekPoin = state.response;
              // poinValue = widget.poin ? cekPoin?.point : '0';
              if (widget.poin == true && cekPoin?.point != null) {
                poinValue = cekPoin?.point.toString();
              } else {
                poinValue = '0';
              }
            });
            print('Ini Poin nya : ${cekPoin?.point}');
            print('Poin yang akan disimpan : $poinValue');
          }
        }, builder: (context, state) {
          return BlocConsumer<SyaratKetentuanCubit, SyaratKetentuanState>(
              listener: (context, state) {
            if (state is SyaratKetentuanSuccess) {
              syaratKetentuanList.clear();
              syaratKetentuanList = state.response;
              syaratKetentuanList.sort((a, b) => a.createdDate!.compareTo(b.createdDate!));
            }
          }, builder: (context, state) {
            if (state is SyaratKetentuanInProgress) {
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.amber[600],
                ),
              );
            }
            return Container(
              height: screenSize.height,
              width: screenSize.width,
              color: Colors.white,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Syarat & Ketentuan',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'Poppins Extra Bold'),
                              ),
                              SizedBox(height: 20),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: syaratKetentuanList.length,
                                itemBuilder: (context, index) {
                                  final item = syaratKetentuanList[index];
                                  return Table(
                                    columnWidths: {
                                      0: FlexColumnWidth(2),
                                      1: FlexColumnWidth(15),
                                    },
                                    children: [
                                      TableRow(children: [
                                        TableCell(
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 8.0, horizontal: 2.0),
                                            child: Text(
                                              '${item.value}.',
                                              style: TextStyle(
                                                  fontFamily: 'Poppins Med',
                                                  fontSize: 13),
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 8.0,
                                                  horizontal: 2.0),
                                              child: Text(
                                                item.description ?? '',
                                                style: TextStyle(
                                                    fontFamily: 'Poppins Med',
                                                    fontSize: 13),
                                                textAlign: TextAlign.justify,
                                              )),
                                        )
                                      ]),
                                    ],
                                  );
                                },
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Checkbox(
                                    value: _isChecked,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        _isChecked = value ?? false;
                                      });
                                    },
                                  ),
                                  //Flexible : This widget is used to wrap the Text widget
                                  //allowing it to wrap onto the next line if it doesn't fit in the available space, thereby preventing the overflow error.
                                  Flexible(
                                    child: Text(
                                      'Saya menyetujui syarat dan ketentuan yang berlaku.',
                                      style: TextStyle(
                                          fontFamily: 'Poppins Med',
                                          fontSize: 12),
                                      textAlign: TextAlign.justify,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          // ),
                        ],
                      ),
                    ),
                    SizedBox(height: 40),
                    Center(
                      child: SizedBox(
                        width: 300,
                        height: 40,
                        child: Material(
                          borderRadius: BorderRadius.circular(7.0),
                          color: Colors.red[900],
                          child: MaterialButton(
                            onPressed: () {
                              if (_isChecked) {
                                // Navigator.pushReplacement(context,
                                //     MaterialPageRoute(builder: (context) {
                                //   return NotifFCL();
                                //   // return NotifFCL(orderNumber: widget.orderNumber);
                                // }));
                                String formatDate(DateTime date) {
                                  return DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'")
                                      .format(date.toUtc());
                                }

                                String formatDateToISO8601(DateTime date) {
                                  return DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'")
                                      .format(date.toUtc());
                                }

                                String formatDateToISO8601WithOffset(
                                    DateTime date, int offsetHours) {
                                  return DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'")
                                      .format(date
                                          .toUtc()
                                          .add(Duration(hours: offsetHours)));
                                }

                                DateTime? cargoDate =
                                    widget.tanggalCargo != null
                                        ? DateFormat("dd/MM/yyyy")
                                            .parse(widget.tanggalCargo)
                                        : null;
                                // String? formattedCargoDate = cargoDate != null
                                //     ? formatDate(cargoDate)
                                //     : null;
                                DateTime? resetCargoDate = cargoDate != null
                                    ? DateTime(cargoDate.year, cargoDate.month,
                                        cargoDate.day, 0, 0, 0, 0, 0)
                                    : null;
                                // You can use 'Z' for UTC
                                String? formattedCargoDate = resetCargoDate !=
                                        null
                                    ? DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
                                        .format(resetCargoDate)
                                    : null;

                                // Convert estimasiClosing to ISO 8601 format
                                DateTime? estimasiClosingDate =
                                    widget.estimasiClosing != null
                                        ? DateFormat("dd/MM/yyyy")
                                            .parse(widget.estimasiClosing)
                                        : null;
                                String? formattedEstimasiClosing =
                                    estimasiClosingDate != null
                                        ? formatDateToISO8601WithOffset(
                                            estimasiClosingDate, 7)
                                        : null;

                                print("email: ${widget.email}");
                                print("createdBy: ${widget.email}");
                                print("userId: ${widget.userId}");
                                print(
                                    "createdDate: ${formatDate(DateTime.now())}");
                                print("businessUnit: ${widget.portAsal}");
                                print("portAsal: ${widget.portAsal}");
                                print("portTujuan: ${widget.portTujuan}");
                                print("originalCity: ${widget.namaAlamatMuat}");
                                print(
                                    "originalAddress: ${widget.detailAlamatMuat}");
                                print("originalPicName: ${widget.picMuat}");
                                print(
                                    "originalPicNumber: ${int.parse(widget.telpPicMuat)}");
                                print("cargoReadyDate: $formattedCargoDate");
                                print(
                                    "destinationCity: ${widget.namaAlamatBongkar}");
                                print(
                                    "destinationAddress: ${widget.detailAlamatBongkar}");
                                print(
                                    "destinationPicName: ${widget.picBongkar}");
                                print(
                                    "destinationPicNumber: ${int.parse(widget.telpPicBongkar)}");
                                print("contractNo: ${widget.kontrak}");
                                print("komoditi: ${widget.komoditi}");
                                print(
                                    "productDescription: ${widget.deskripsiProduk}");
                                print(
                                    "containerSize: ${int.parse(widget.ukuranContainer)}");
                                print("Amount: ${widget.harga}");
                                print("quantity: ${widget.jumlahContainer}");
                                print(
                                    "Loc ID UOC Asal: ${widget.locIDUOCAsal}");
                                print(
                                    "Loc ID UOC Tujuan: ${widget.locIDUOCTujuan}");
                                print(
                                    "Loc ID Port Asal: ${widget.locIDPortAsal}");
                                print(
                                    "Loc ID Port Tujuan: ${widget.locIDPortTujuan}");
                                print("Poin: ${widget.poin}");
                                print("Price: ${widget.hargaContract}");
                                print("Total Berat: ${widget.totalBerat}");
                                print("Poin yang di gunakan: $poinValue");
                                print(
                                    "Estimasi Nilai Produk ${widget.estimasiNilaiProduk}");
                                print(
                                    "Estimasi Closing: $formattedEstimasiClosing");

                                // final int amount = cekHarga?.estimasiHarga ?? 0;
                                // print("amount: $amount");

                                context.read<CreateOrderCubit>().createOrderFCL(
                                    widget.email, // email
                                    widget.email, // createdBy
                                    widget.userId,
                                    formatDate(DateTime.now()), // createdDate
                                    widget
                                        .portAsal, // businessUnit (replace with actual value)
                                    widget.portAsal, // portAsal
                                    widget.portTujuan, // portTujuan
                                    widget.namaAlamatMuat, // originalCity
                                    widget.detailAlamatMuat, // originalAddress
                                    widget.picMuat, // originalPicName
                                    widget.telpPicMuat, // originalPicNumber
                                    formattedCargoDate ?? '',
                                    widget.namaAlamatBongkar, // destinationCity
                                    widget
                                        .detailAlamatBongkar, // destinationAddress
                                    widget.picBongkar, // destinationPicName
                                    widget
                                        .telpPicBongkar, // destinationPicNumber
                                    widget.kontrak, // contractNo
                                    widget.komoditi, // komoditi
                                    widget
                                        .deskripsiProduk, // productDescription
                                    widget.ukuranContainer, // containerSize
                                    widget.jumlahContainer, // quantity
                                    // widget.harga.toDouble(), // amount
                                    widget.harga, // amount
                                    widget.locIDUOCAsal, //uoc asal
                                    widget.locIDUOCTujuan, //uoc tujuan
                                    widget.locIDPortAsal, //kota asal
                                    widget.locIDPortTujuan, //kota tujuan
                                    widget.poin, //point
                                    // poinValue, //point
                                    widget.hargaContract, //price
                                    widget.totalBerat, //userTotalWeight
                                    false, //flagPaymentWa
                                    false, //paymentStatus
                                    int.tryParse(poinValue ?? '0') ??
                                        0, //use point
                                    widget.estimasiNilaiProduk, //amountCargo
                                    formattedEstimasiClosing.toString() //etd
                                    );
                              } else {
                                // You can show a message or a dialog to inform the user to check the box
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          'Please agree to the terms and conditions.')),
                                );
                              }
                            },
                            child: Text(
                              'Buat Pesanan',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                fontFamily: 'Poppins Med',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    Center(
                      child: SizedBox(
                        width: 300,
                        height: 40,
                        child: Material(
                          borderRadius: BorderRadius.circular(7.0),
                          color: Colors.white,
                          // shadowColor: Colors.grey[350],
                          // elevation: 5,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side:
                                  BorderSide(color: Colors.red[900]!, width: 2),
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
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            );
          });
        });
      }),
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
      //     items: <BottomNavigationBarItem>[
      //       const BottomNavigationBarItem(
      //         icon: Icon(
      //           Icons.dashboard,
      //           size: 27,
      //         ),
      //         label: 'Order',
      //       ),
      //       const BottomNavigationBarItem(
      //         icon: SizedBox(
      //           // width: 20,
      //           width: 23,
      //           child: ImageIcon(
      //             AssetImage('assets/tracking icon.png'),
      //           ),
      //         ),
      //         label: 'Tracking',
      //       ),
      //       // BottomNavigationBarItem(
      //       //   icon: Stack(
      //       //     alignment:
      //       //         Alignment.center, // Centers the icon inside the circle
      //       //     children: <Widget>[
      //       //       Container(
      //       //         height: 40, // Adjust size of the circle
      //       //         width: 40,
      //       //         decoration: BoxDecoration(
      //       //           color: Colors.red[900], // Red circle color
      //       //           shape: BoxShape.circle,
      //       //         ),
      //       //       ),
      //       //       Icon(
      //       //         Icons.home,
      //       //         color:
      //       //             Colors.white, // Icon color (optional for visibility)
      //       //       ),
      //       //     ],
      //       //   ),
      //       //   label: 'Home',
      //       // ),
      //       BottomNavigationBarItem(
      //         icon: Stack(
      //           alignment: Alignment.center,
      //           children: <Widget>[
      //             Container(
      //               height: 50, // Adjusted size of the circle
      //               width: 50,
      //               decoration: BoxDecoration(
      //                 color: Colors.red[900], // Red circle color
      //                 shape: BoxShape.circle,
      //               ),
      //             ),
      //             Icon(
      //               Icons.home,
      //               size: 28,
      //               color: Colors.white,
      //             ),
      //           ],
      //         ),
      //         label: '',
      //       ),
      //       const BottomNavigationBarItem(
      //         icon: SizedBox(
      //           // width: 12,
      //           width: 23,
      //           child: ImageIcon(
      //             AssetImage('assets/invoice icon.png'),
      //           ),
      //         ),
      //         label: 'Invoice',
      //       ),
      //       const BottomNavigationBarItem(
      //         icon: Icon(
      //           Icons.person,
      //           size: 27,
      //         ),
      //         label: 'Profil',
      //       ),
      //     ],
      //     currentIndex: _selectedIndex,
      //     selectedItemColor: Colors.grey[600],
      //     onTap: _onItemTapped,
      //   ),
      // )
    );
  }
}

//============
int _currentStep = 1;
Widget _buildStepItem(String number, String title, int stepNumber) {
  // bool isSelected = _currentStep == stepNumber;
  Color itemColor =
      // isSelected
      stepNumber == 4
          ? (Colors.red[900] ?? Color.fromARGB(255, 184, 33, 22))
          : (Colors.grey[400] ?? Colors.grey);
  Color textColor =
      // isSelected
      stepNumber == 4 ? Color.fromARGB(255, 184, 33, 22) : Colors.black;

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0),
    child: Row(
      children: [
        Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                // Container(
                //   width: 25,
                //   height: 25,
                //   decoration: BoxDecoration(
                //     color: itemColor,
                //     borderRadius: BorderRadius.circular(5.0),
                //   ),
                // ),
                Text(
                  number,
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                  ),
                )
              ],
            ),
          ],
        ),
        Text(
          title,
          style: TextStyle(
            // color: Colors.black,
            color: textColor,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
  );
}

Widget _buildSeparator() {
  return Container(
    child: Icon(
      Icons.navigate_next,
      size: 15,
      color: Color.fromARGB(255, 175, 163, 163),
    ),
  );
}
