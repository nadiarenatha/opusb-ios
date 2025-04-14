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
import 'notif_lcl.dart';
import 'package:intl/intl.dart';

class KonfirmasiLCL extends StatefulWidget {
  // final String? orderNumber;
  final String kontrak;
  final String komoditi;
  final String uom;
  final int jumlahProduk;
  final double beratTotal;
  final String deskripsiProduk;
  final double panjang;
  final double lebar;
  final double tinggi;
  final double volume;
  final String portAsal;
  final String portTujuan;
  final String kotaAsal;
  final String kotaTujuan;
  final String tanggalCargo;
  final String namaAlamatMuat;
  final String detailAlamatMuat;
  final String namaAlamatBongkar;
  final String detailAlamatBongkar;
  final String picBongkar;
  final String telpPicBongkar;
  final int harga;
  final double cbm;
  final String namaKontrak;
  final String email;
  final int userId;
  final String locIDPortAsal;
  final String locIDPortTujuan;
  final String locIDUOCAsal;
  final String locIDUOCTujuan;
  final bool poin;
  final int price;
  final int estimasiNilaiProduk;
  // const KonfirmasiLCL({super.key});
  // const KonfirmasiLCL({Key? key, required this.orderNumber}) : super(key: key);
  const KonfirmasiLCL({
    Key? key,
    required this.kontrak,
    required this.komoditi,
    required this.uom,
    required this.jumlahProduk,
    required this.beratTotal,
    required this.deskripsiProduk,
    required this.panjang,
    required this.lebar,
    required this.tinggi,
    required this.volume,
    required this.portAsal,
    required this.portTujuan,
    required this.kotaAsal,
    required this.kotaTujuan,
    required this.tanggalCargo,
    required this.namaAlamatMuat,
    required this.detailAlamatMuat,
    required this.namaAlamatBongkar,
    required this.detailAlamatBongkar,
    required this.picBongkar,
    required this.telpPicBongkar,
    required this.harga,
    required this.cbm,
    required this.namaKontrak,
    required this.email,
    required this.userId,
    required this.locIDPortAsal,
    required this.locIDPortTujuan,
    required this.locIDUOCAsal,
    required this.locIDUOCTujuan,
    required this.poin,
    required this.price,
    required this.estimasiNilaiProduk,
  }) : super(key: key);

  @override
  State<KonfirmasiLCL> createState() => _KonfirmasiLCLState();
}

class _KonfirmasiLCLState extends State<KonfirmasiLCL> {
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
    BlocProvider.of<ContractNiagaCubit>(context).logCekPoin();
    print('point nya yang di dapat: ${widget.poin}');
    print('volume nya: ${widget.cbm}');
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
            "Pemesanan LCL",
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
        if (state is CreateOrderLCLSuccess && _isChecked) {
          // final orderNumber = state.responses['orderNumber'];
          final orderNumber = state.response.orderNumber;
          final point = widget.poin == true ? 1 : 0;

          context.read<CreateOrderCubit>().pushOrder(orderNumber ?? '', point);
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return NotifLCL(orderNumber: orderNumber);
          }));
        }
      }, builder: (context, state) {
        if (state is CreateOrderLCLInProgress) {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.amber[600],
            ),
          );
        }
        return BlocConsumer<ContractNiagaCubit, ContractNiagaState>(
            listener: (context, state) async {
          if (state is CekPoinSuccess) {
            setState(() {
              cekPoin = state.response;
              // poinValue = widget.poin ? cekPoin?.point as String? : '0';
              if (widget.poin == true && cekPoin?.point != null) {
                poinValue = cekPoin?.point.toString();
              } else {
                poinValue = '0';
              }
            });
            print('Ini Poin nya : ${cekPoin?.point}');
            print('Poin yang akan disimpan : $poinValue');
            print('volume Total di Konfirmasi LCL nya: ${widget.cbm}');
          }
        }, builder: (context, state) {
          return BlocConsumer<SyaratKetentuanCubit, SyaratKetentuanState>(
              listener: (context, state) {
            if (state is SyaratKetentuanSuccess) {
              syaratKetentuanList.clear();
              syaratKetentuanList = state.response;
              syaratKetentuanList
                  .sort((a, b) => a.createdDate!.compareTo(b.createdDate!));
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
                                    color: Colors.black,
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
                          // shadowColor: Colors.grey[350],
                          // elevation: 5,
                          child: MaterialButton(
                            onPressed: () {
                              if (_isChecked) {
                                // Navigator.push(context,
                                //     MaterialPageRoute(builder: (context) {
                                //   // return NotifLCL();
                                //   return NotifLCL();
                                // }));

                                String formatDate(DateTime date) {
                                  return DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'")
                                      .format(date.toUtc());
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
                                print("quantity: ${widget.jumlahProduk}");

                                // final double amount = cekHarga?.estimasiHarga ?? 0;
                                print("Harga: ${widget.harga}");

                                print("userPanjang: ${widget.panjang}");
                                print("userLebar: ${widget.lebar}");
                                print("userTinggi: ${widget.tinggi}");
                                print("userTotalVolume: ${widget.volume}");
                                print("userTotalWeight: ${widget.beratTotal}");
                                print("uom: ${widget.uom}");
                                print("Poin: ${widget.poin}");
                                print("price: ${widget.price}");
                                print("locIDUOCAsal: ${widget.locIDUOCAsal}");
                                print(
                                    "locIDUOCTujuan: ${widget.locIDUOCTujuan}");
                                print("locIDPortAsal: ${widget.locIDPortAsal}");
                                print(
                                    "locIDPortTujuan: ${widget.locIDPortTujuan}");
                                print("Poin yang di gunakan: $poinValue");
                                print(
                                    "Estimasi Nilai Produk ${widget.estimasiNilaiProduk}");

                                context.read<CreateOrderCubit>().createOrderLCL(
                                    widget.email, // email
                                    widget.email, // createdBy
                                    widget
                                        .userId, // userId (replace with actual user ID)
                                    formatDate(DateTime.now()), // createdDate
                                    widget
                                        .portAsal, // businessUnit (replace with actual value)
                                    widget.portAsal, // portAsal
                                    widget.portTujuan, // portTujuan
                                    widget.namaAlamatMuat, // originalCity
                                    widget.detailAlamatMuat, // originalAddress
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
                                    widget.jumlahProduk, // quantity
                                    widget.harga, // amount
                                    widget.panjang, //userPanjang
                                    widget.lebar, //userLebar
                                    widget.tinggi, //userTinggi
                                    // widget.volume.toInt(), //userTotalVolume
                                    widget.cbm, //userTotalVolume
                                    widget.beratTotal.toInt(), //userTotalWeight
                                    widget.uom, //uom
                                    widget.poin, //point
                                    widget.locIDUOCAsal, //loc id uoc asal
                                    widget.locIDUOCTujuan, //loc id uoc tujuan
                                    widget.locIDPortAsal, //loc id port asal
                                    widget.locIDPortTujuan, //loc id port tujuan
                                    widget.price, //price
                                    int.tryParse(poinValue ?? '0') ??
                                        0, //use point
                                    widget.estimasiNilaiProduk //amountCargo
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
                              'Buat Order',
                              style: TextStyle(
                                fontSize: 13,
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
                              minimumSize: Size(200, 50),
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
          ? (Colors.red[900] ?? Colors.red)
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
