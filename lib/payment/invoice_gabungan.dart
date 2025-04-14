import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:niaga_apps_mobile/payment/webview_espay_page.dart';
import 'package:niaga_apps_mobile/profile/profil_niaga.dart';
import '../Invoice/menu_invoice_niaga.dart';
import '../cubit/niaga/espay_cubit.dart';
import '../cubit/niaga/invoice_group_cubit.dart';
import '../model/niaga/bank_code.dart';
import '../model/niaga/detail_espay_invoice_group.dart';
import '../model/niaga/fee_espay.dart';
import '../model/niaga/open_invoice_detail_niaga.dart';
import '../order/menu_order_niaga.dart';
import '../screen-niaga/home_niaga.dart';
import '../shared/constants.dart';
import '../shared/functions/flutter_secure_storage.dart';
import '../tracking/menu_tracking_niaga.dart';
import 'package:intl/intl.dart';

class InvoiceGabunganPage extends StatefulWidget {
  final String? noInvGroup;
  final int? total;
  final String? merchantId;
  final String? subMerchantId;
  final String? cabang;
  // const InvoiceGabunganPage({Key? key}) : super(key: key);
  const InvoiceGabunganPage(
      {Key? key,
      required this.noInvGroup,
      required this.total,
      required this.merchantId,
      required this.subMerchantId,
      required this.cabang})
      : super(key: key);

  String get formattedHarga {
    final NumberFormat currencyFormat = NumberFormat.currency(
      locale: 'ID',
      symbol: 'Rp ',
      decimalDigits: 2,
    );
    return currencyFormat.format(total);
  }

  @override
  State<InvoiceGabunganPage> createState() => _InvoiceGabunganPageState();
}

class _InvoiceGabunganPageState extends State<InvoiceGabunganPage> {
  @override

  //untuk BottomNavigationBarItem
  int _selectedIndex = 0;
  late EspayCubit _espayCubit;
  String selectedPaymentMethod = 'Klik untuk Pilih Metode Pembayaran';
  bool _isCombinedPayment = false;
  int total = 0;
  List<BankCodeAccesses> bankCodeList = [];
  List<FeeEspayAccesses> feeEspayList = [];
  BankCodeAccesses? method;
  String? selectedMethodName;
  String? selectedMethodValue;

  // String? cabang;
  // String? merchantId;
  // String? subMerchantId;

  List<DetailEspayInvoiceGroupAccesses> detailMultipleInvoice = [];

  //untuk BottomNavigationBarItem
  static List<Widget> _widgetOptions = <Widget>[
    MenuOrderNiagaPage(),
    MenuTrackingNiagaPage(resiNumber: ''),
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

  @override
  void initState() {
    super.initState();
    // BlocProvider.of<EspayCubit>(context).espayValidation();
    _espayCubit = BlocProvider.of<EspayCubit>(context);
    BlocProvider.of<InvoiceGroupCubit>(context)
        .detailMultipleInvoice(widget.noInvGroup.toString());
    BlocProvider.of<EspayCubit>(context).feeEspay();
  }

  // void _validatePayment(String methodName, String methodValue) {
  Future<void> _validatePayment(String methodName, String methodValue) async {
    print('No Inv Group nya di Multiple Invoice: ${widget.noInvGroup}');
    print('total nya di Multiple Invoice: ${widget.total}');

    final userIdString = await storage.read(
      key: AuthKey.id.toString(),
      aOptions: const AndroidOptions(
        encryptedSharedPreferences: true,
      ),
    );

    final userId = int.tryParse(userIdString ?? '');
    if (userId == null) {
      print('Error: userId is null or invalid');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User ID is invalid. Please try again.')),
      );
      return;
    }

    if (widget.noInvGroup != null && widget.total! > 0) {
      final fee = feeEspayList
          .firstWhere(
            (fee) => fee.name!.toLowerCase() == "feeva",
            orElse: () => FeeEspayAccesses(value: "0"),
          )
          .value;
      final totalWithFee = (selectedMethodName == "BRIATM" ||
              selectedMethodName == "CIMBATM" ||
              selectedMethodName == "BNIATM" ||
              selectedMethodName == "BCAATM" ||
              selectedMethodName == "MANDIRIATM")
          ? widget.total! + int.parse(fee.toString())
          : widget.total!;
      print('totalWithFee nya: $totalWithFee');

      _espayCubit.espayValidation(
          widget.noInvGroup!,
          // widget.total.toString(),
          totalWithFee.toString(),
          methodName,
          methodValue,
          userId,
          'GABUNGAN',
          widget.noInvGroup!,
          'GABUNGAN',
          'GABUNGAN',
          'GABUNGAN',
          'GABUNGAN',
          widget.merchantId.toString(),
          widget.subMerchantId.toString(),
          // merchantId.toString(),
          // subMerchantId.toString(),
          widget.cabang.toString());
    } else {
      // Handle the case where noInvGroup or total is invalid
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid invoice details.')),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> loadingEspay() {
    return showDialog(
      context: context,
      barrierDismissible:
          false, // Prevent dismissing the dialog by tapping outside
      builder: (BuildContext context) {
        return BlocBuilder<EspayCubit, EspayState>(
          builder: (context, state) {
            return Center(
              child: SingleChildScrollView(
                child: AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [],
                  ),
                  content: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Display CircularProgressIndicator when EspayInProgress state is active
                        if (state is EspayInProgress)
                          CircularProgressIndicator(
                            color: Colors.amber[600],
                          ),
                        SizedBox(height: 20),
                        Text(
                          "Processing Payment",
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Poppin',
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(height: 10),
                        // If EspaySuccess state is active, show success message
                        // if (state is EspaySuccess)
                        //   Text(
                        //     "Payment Success",
                        //     style: TextStyle(color: Colors.green, fontSize: 16),
                        //   ),
                        // // If EspayFailure state is active, show error message
                        // if (state is EspayFailure)
                        //   Text(
                        //     "Payment Failed",
                        //     style: TextStyle(color: Colors.red, fontSize: 16),
                        //   ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future pilihPembayaran() => showDialog(
      context: context,
      //alert diberi SingleChildScrollView agar bisa di scroll
      builder: (BuildContext context) => SingleChildScrollView(
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
                  children: [
                    IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          Navigator.of(context).pop();
                        })
                  ],
                ),
                content: metodePembayaran()),
          ));

  // Future virtualAccount() => showDialog(
  Future virtualAccount(List<BankCodeAccesses> bankCodeList) => showDialog(
      context: context,
      //alert diberi SingleChildScrollView agar bisa di scroll
      builder: (BuildContext context) => SingleChildScrollView(
            child: AlertDialog(
                //untuk memberi border melengkung
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                //untuk mengatur letak dari close icon
                titlePadding: EdgeInsets.zero,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 25, vertical: 3),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      //supaya berada di kanan
                      // mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back),
                          onPressed: () {
                            // Handle back navigation here
                            Navigator.of(context).pop();
                          },
                        ),
                        Text(
                          "Virtual Account",
                          style: TextStyle(
                              fontSize: 15, fontFamily: 'Poppins Bold'),
                        ),
                      ],
                    ),
                    IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          Navigator.of(context).pop();
                        })
                  ],
                ),
                // content: metodeVA()),
                content: metodeVA(context, bankCodeList)),
          ));

  // Future modernMarket() => showDialog(
  Future modernMarket(List<BankCodeAccesses> bankCodeList) => showDialog(
      context: context,
      //alert diberi SingleChildScrollView agar bisa di scroll
      builder: (BuildContext context) => SingleChildScrollView(
            child: AlertDialog(
                //untuk memberi border melengkung
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                //untuk mengatur letak dari close icon
                titlePadding: EdgeInsets.zero,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 25, vertical: 3),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      //supaya berada di kanan
                      // mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back),
                          onPressed: () {
                            // Handle back navigation here
                            Navigator.of(context).pop();
                          },
                        ),
                        Text(
                          "Modern Market",
                          style: TextStyle(
                              fontSize: 15, fontFamily: 'Poppins Bold'),
                        ),
                      ],
                    ),
                    IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          Navigator.of(context).pop();
                        })
                  ],
                ),
                // content: metodeModernMarket()),
                content: metodeModernMarket(context, bankCodeList)),
          ));

  // Future lainnya() => showDialog(
  Future lainnya(List<BankCodeAccesses> bankCodeList) => showDialog(
      context: context,
      //alert diberi SingleChildScrollView agar bisa di scroll
      builder: (BuildContext context) => SingleChildScrollView(
            child: AlertDialog(
                //untuk memberi border melengkung
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                //untuk mengatur letak dari close icon
                titlePadding: EdgeInsets.zero,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 25, vertical: 3),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      //supaya berada di kanan
                      // mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back),
                          onPressed: () {
                            // Handle back navigation here
                            Navigator.of(context).pop();
                          },
                        ),
                        Text(
                          "Lainnya",
                          style: TextStyle(
                              fontSize: 15, fontFamily: 'Poppins Bold'),
                        ),
                      ],
                    ),
                    IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          Navigator.of(context).pop();
                        })
                  ],
                ),
                // content: metodeLainnya()),
                content: metodeLainnya(context, bankCodeList)),
          ));

  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          0.07 * MediaQuery.of(context).size.height,
        ),
        child: AppBar(
          backgroundColor: Colors.white,
          // title: Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Expanded(
          //       child: Text(
          //         "Pembayaran",
          //         style: TextStyle(
          //             fontSize: 16,
          //             color: Colors.red[900],
          //             fontFamily: 'Poppins Extra Bold'),
          //         overflow: TextOverflow.ellipsis,
          //       ),
          //     ),
          //   ],
          // ),
          flexibleSpace: Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 40),
            child: Text("Pembayaran",
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.red[900],
                    fontFamily: 'Poppins Extra Bold')),
          ),
          toolbarHeight: 0.07 * MediaQuery.of(context).size.height,
          leading: Container(),
        ),
      ),
      body: BlocConsumer<EspayCubit, EspayState>(
          listener: (context, state) async {
        if (state is EspaySuccess) {
          final webRedirectUrl = state.espayResponse.webRedirectUrl;
          if (webRedirectUrl != null && webRedirectUrl.isNotEmpty) {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WebViewEspayPage(
                    url: webRedirectUrl,
                    selectedMethodName: selectedMethodName!,
                    selectedMethodValue: selectedMethodValue!,
                    invoiceNumber: widget.noInvGroup.toString(),
                    noPL: 'GABUNGAN',
                    rute: 'GABUNGAN',
                    typePengiriman: 'GABUNGAN',
                    volume: 'GABUNGAN'),
              ),
            );
            print('merchantId nya: ${widget.merchantId.toString()}');
            print('subMerchantId nya: ${widget.subMerchantId.toString()}');
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Redirect URL is missing.')),
            );
          }
        }
        if (state is FeeEspaySuccess) {
          feeEspayList.clear();
          feeEspayList = state.response;
        }
      }, builder: (context, state) {
        return BlocConsumer<InvoiceGroupCubit, InvoiceGroupState>(
            listener: (context, state) async {
          if (state is DeleteInvoiceSuccess) {
            //   setState(() {
            //   _isCombinedPayment = false;
            // });
            Navigator.of(context).pop();
          } else if (state is DetailMultipleInvoiceSuccess) {
            detailMultipleInvoice.clear();
            detailMultipleInvoice = state.response;
            print('respon nya: $detailMultipleInvoice');
          }
        }, builder: (context, state) {
          if (state is DeleteInvoiceInProgress ||
              state is DetailMultipleInvoiceInProgress) {
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
                      // boxShadow: [
                      //   BoxShadow(
                      //     // Grey shadow color with opacity
                      //     color: Colors.grey.withOpacity(0.5),
                      //     spreadRadius: 2, // How far the shadow spreads
                      //     blurRadius: 5, // How much the shadow is blurred
                      //     offset: Offset(0, 3), // Position of the shadow
                      //   ),
                      // ],
                      borderRadius: BorderRadius.circular(
                          8), // Optional: Add border radius
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text(
                            // 'INV/01.NL-SBY.2023.JUN/010983',
                            widget.noInvGroup.toString(),
                            style:
                                TextStyle(fontSize: 15, fontFamily: 'Poppinss'),
                          ),
                          SizedBox(height: 20),
                          ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: detailMultipleInvoice.length > 7
                                  ? 7
                                  : detailMultipleInvoice.length,
                              itemBuilder: (context, index) {
                                var invoice = detailMultipleInvoice[index];
                                String noInvoiceAsli =
                                    invoice.noInvoiceAsli.toString();
                                String totalInvoiceAsli =
                                    invoice.formattedTotalInvoiceAsli;

                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        noInvoiceAsli,
                                        style: TextStyle(
                                            fontSize: 11,
                                            fontFamily: 'Poppinss'),
                                      ),
                                      Text(
                                        totalInvoiceAsli,
                                        style: TextStyle(
                                            fontSize: 11,
                                            fontFamily: 'Poppinss'),
                                      )
                                    ],
                                  ),
                                );
                              }),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                'Total Tagihan',
                                style: TextStyle(
                                    fontFamily: 'Poppins Bold',
                                    fontSize: 13,
                                    color: Colors.red[900]),
                              ),
                              Text(
                                // 'Rp 5.055.000',
                                widget.formattedHarga.toString(),
                                style: TextStyle(
                                    fontFamily: 'Poppins Bold',
                                    fontSize: 13,
                                    color: Colors.red[900]),
                              ),
                            ],
                          ),
                          SizedBox(height: 10)
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors
                          .white, // Background color of the outer container
                      border: Border.all(
                        color: Colors.grey, // Grey border color
                        width: 2.0, // Border width
                      ),
                      // boxShadow: [
                      //   BoxShadow(
                      //     // Grey shadow color with opacity
                      //     color: Colors.grey.withOpacity(0.5),
                      //     spreadRadius: 2, // How far the shadow spreads
                      //     blurRadius: 5, // How much the shadow is blurred
                      //     offset: Offset(0, 3), // Position of the shadow
                      //   ),
                      // ],
                      borderRadius: BorderRadius.circular(
                          8), // Optional: Add border radius
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Metode Pembayaran',
                            style: TextStyle(
                              fontSize: 17,
                              fontFamily: 'Poppinss',
                            ),
                          ),
                          SizedBox(height: 25),
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    pilihPembayaran();
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.red[900],
                                      borderRadius: BorderRadius.circular(
                                          8), // Rounded corners
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 12.0, horizontal: 16.0),
                                    child: Center(
                                      child: Text(
                                        // 'Klik untuk Pilih Metode Pembayaran',
                                        selectedPaymentMethod,
                                        style: TextStyle(
                                          // color: Colors.grey, // White text
                                          color: selectedPaymentMethod ==
                                                      "Virtual Account BRI" ||
                                                  selectedPaymentMethod ==
                                                      "Virtual Account CIMB NIAGA" ||
                                                  selectedPaymentMethod ==
                                                      "Virtual Account BNI" ||
                                                  selectedPaymentMethod ==
                                                      "Virtual Account BCA" ||
                                                  selectedPaymentMethod ==
                                                      "Virtual Account Mandiri" ||
                                                  selectedPaymentMethod ==
                                                      "Modern Channel - Indomaret" ||
                                                  selectedPaymentMethod ==
                                                      "Modern Channel - Alfamart" ||
                                                  selectedPaymentMethod ==
                                                      "QRIS" ||
                                                  selectedPaymentMethod ==
                                                      "BCA KlikPay" ||
                                                  selectedPaymentMethod ==
                                                      "Credit Card"
                                              ? Colors
                                                  .white // Change text color when selected
                                              : Colors
                                                  .white, // Default text color
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 25),
                          Table(
                            columnWidths: {
                              0: FlexColumnWidth(1),
                              1: FlexColumnWidth(18),
                            },
                            children: [
                              TableRow(children: [
                                //tipe pengiriman
                                TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 2.0),
                                    child: Text(
                                      '1.',
                                      style: TextStyle(
                                          fontFamily: 'Poppins Med',
                                          fontSize: 12),
                                    ),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 2.0),
                                    child: Text(
                                      'Jasa biaya layanan dari pihak bank atau payment gateway dibebankan kepada pelanggan',
                                      style: TextStyle(
                                          fontFamily: 'Poppins Med',
                                          fontSize: 12),
                                      textAlign: TextAlign.justify,
                                    ),
                                  ),
                                ),
                              ]),
                              TableRow(children: [
                                TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 2.0),
                                    child: Text(
                                      '2. ',
                                      style: TextStyle(
                                          fontFamily: 'Poppins Med',
                                          fontSize: 12),
                                    ),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 2.0),
                                    child: Text(
                                      'Tagihan dikenakan pajak sesuai aturan Pemerintah Indonesia',
                                      style: TextStyle(
                                          fontFamily: 'Poppins Med',
                                          fontSize: 12),
                                      textAlign: TextAlign.justify,
                                    ),
                                  ),
                                ),
                              ]),
                              TableRow(children: [
                                TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 2.0),
                                    child: Text(
                                      '3. ',
                                      style: TextStyle(
                                          fontFamily: 'Poppins Med',
                                          fontSize: 12),
                                    ),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 2.0),
                                    child: Text(
                                      'Nominal dana yang sudah dibayarkan oleh konsumen dengan channel di payment gateway, tidak bisa dikembalikan. Mohon dipastikan kesesuaian invoice dengan tagihan yang ada.',
                                      style: TextStyle(
                                          fontFamily: 'Poppins Med',
                                          fontSize: 12),
                                      textAlign: TextAlign.justify,
                                    ),
                                  ),
                                ),
                              ]),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 60),
                  Center(
                    child: SizedBox(
                      width: 200,
                      height: 40,
                      child: Material(
                        borderRadius: BorderRadius.circular(7.0),
                        // color: Colors.red[900],
                        color: selectedPaymentMethod ==
                                'Klik untuk Pilih Metode Pembayaran'
                            ? Colors.grey
                            : Colors.red[900],
                        child: MaterialButton(
                          onPressed: () {
                            // loadingEspay();
                            // _validatePayment();
                            if (selectedPaymentMethod !=
                                'Klik untuk Pilih Metode Pembayaran') {
                              loadingEspay();
                              // _validatePayment();
                              if (selectedMethodName != null &&
                                  selectedMethodValue != null) {
                                context.read<InvoiceGroupCubit>().bayarSekarang(
                                    widget.noInvGroup.toString());
                                // Call _validatePayment with stored method details
                                _validatePayment(
                                    selectedMethodName!, selectedMethodValue!);
                              } else {
                                // Handle case where method details are not selected
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          'Please select a payment method first.')),
                                );
                              }
                            }
                          },
                          child: Text(
                            'Bayar Sekarang',
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.white,
                                fontFamily: 'Poppinss'),
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (selectedPaymentMethod ==
                      'Klik untuk Pilih Metode Pembayaran')
                    SizedBox(height: 15),
                  if (selectedPaymentMethod ==
                      'Klik untuk Pilih Metode Pembayaran')
                    Center(
                      child: SizedBox(
                        width: 200,
                        height: 40,
                        child: Material(
                          borderRadius: BorderRadius.circular(7.0),
                          color: Colors.white,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side:
                                  BorderSide(color: Colors.red[900]!, width: 1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(7.0),
                              ),
                              backgroundColor: Colors.white,
                            ),
                            onPressed: () {
                              context
                                  .read<InvoiceGroupCubit>()
                                  .deleteInvoice(widget.noInvGroup.toString());
                            },
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.black,
                                  fontFamily: 'Poppins Med'),
                            ),
                          ),
                        ),
                      ),
                    ),
                  // if (selectedPaymentMethod !=
                  //     'Klik untuk Pilih Metode Pembayaran')
                  //   SizedBox(height: 15),
                  // if (selectedPaymentMethod !=
                  //     'Klik untuk Pilih Metode Pembayaran')
                  //   Center(
                  //     child: SizedBox(
                  //       width: 145,
                  //       height: 40,
                  //       child: Material(
                  //         borderRadius: BorderRadius.circular(7.0),
                  //         color: Colors.white,
                  //         child: OutlinedButton(
                  //           style: OutlinedButton.styleFrom(
                  //             side:
                  //                 BorderSide(color: Colors.red[900]!, width: 1),
                  //             shape: RoundedRectangleBorder(
                  //               borderRadius: BorderRadius.circular(7.0),
                  //             ),
                  //             backgroundColor: Colors.white,
                  //           ),
                  //           onPressed: () {
                  //             Navigator.of(context).pop();
                  //           },
                  //           child: Text(
                  //             'Kembali',
                  //             style: TextStyle(
                  //                 fontSize: 13,
                  //                 color: Colors.black,
                  //                 fontFamily: 'Poppins Med'),
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                ],
              ),
            ),
          );
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

  metodePembayaran() {
    return ConstrainedBox(
      // constraints: BoxConstraints(maxHeight: 990, maxWidth: 300),
      constraints: BoxConstraints(maxHeight: 990),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Pilih Metode Pembayaran",
            style: TextStyle(fontSize: 15, fontFamily: 'Poppins Bold'),
          ),
          SizedBox(height: 15),
          Text(
            "Virtual Account",
            style: TextStyle(fontSize: 15, fontFamily: 'Poppinss'),
          ),
          // SizedBox(height: 20),
          InkWell(
            onTap: () {
              // virtualAccount();
              final bankCodeList = [
                BankCodeAccesses(
                    name: "BRIATM", value: "002", description: "VA BRI"),
                BankCodeAccesses(
                    name: "CIMBATM",
                    value: "022",
                    description: "VA CIMB Niaga"),
                BankCodeAccesses(
                    name: "BNIATM", value: "009", description: "VA BNI"),
                BankCodeAccesses(
                    name: "BCAATM", value: "014", description: "VA BCA"),
                BankCodeAccesses(
                    name: "MANDIRIATM",
                    value: "008",
                    description: "VA MANDIRI"),
              ];
              // modernMarket();
              virtualAccount(bankCodeList);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //logo
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        //BRI
                        Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: SizedBox(
                              width: 100,
                              height: 100,
                              child: Image.asset(
                                'assets/bri.png',
                              )),
                        ),
                        //CIMB NIAGA
                        Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: SizedBox(
                              width: 100,
                              height: 100,
                              child: Image.asset(
                                'assets/cimb.png',
                              )),
                        ),
                        //BNI
                        Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: SizedBox(
                              width: 100,
                              height: 100,
                              child: Image.asset(
                                'assets/bni.png',
                              )),
                        ),
                        //BCA
                        Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: SizedBox(
                              width: 100,
                              height: 100,
                              child: Image.asset(
                                'assets/bca.png',
                              )),
                        ),
                        //Mandiri
                        Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: SizedBox(
                              width: 100,
                              height: 100,
                              child: Image.asset(
                                'assets/mandiri.png',
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
                //next icon
                Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
              ],
            ),
          ),
          Container(
            height: 3,
            color: Colors.grey[300],
          ),
          SizedBox(height: 15),
          Text(
            "Modern Market",
            style: TextStyle(fontSize: 15, fontFamily: 'Poppinss'),
          ),
          // SizedBox(height: 20),
          InkWell(
            onTap: () {
              // modernMarket();
              final bankCodeList = [
                BankCodeAccesses(
                    name: "INDOMARETESPAY",
                    value: "800",
                    description: "Indomaret Espay"),
                BankCodeAccesses(
                    name: "ALFAMARTESPAY",
                    value: "801",
                    description: "Alfamart Espay"),
              ];
              modernMarket(bankCodeList);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    //Indomaret
                    Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: SizedBox(
                          width: 100,
                          height: 100,
                          child: Image.asset(
                            'assets/indomaret.png',
                          )),
                    ),
                    //Alfamart
                    Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: SizedBox(
                          width: 100,
                          height: 100,
                          child: Image.asset(
                            'assets/alfamart.png',
                          )),
                    ),
                  ],
                ),
                //next icon
                Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
              ],
            ),
          ),
          // SizedBox(height: 10),
          Container(
            height: 3,
            color: Colors.grey[300],
          ),
          SizedBox(height: 15),
          Text(
            "Credit Card",
            style: TextStyle(fontSize: 15, fontFamily: 'Poppinss'),
          ),
          // InkWell(
          //   onTap: () {
          //     setState(() {
          //       // Close the virtualAccount dialog first
          //       Navigator.of(context).pop();

          //       selectedPaymentMethod = "Credit Card"; // Update the text
          //     });
          //   },
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       Expanded(
          //         child: SingleChildScrollView(
          //           scrollDirection: Axis.horizontal,
          //           child: Row(
          //             mainAxisAlignment: MainAxisAlignment.spaceAround,
          //             children: [
          //               //VISA
          //               Padding(
          //                 padding: const EdgeInsets.only(right: 5),
          //                 child: SizedBox(
          //                     width: 100,
          //                     height: 100,
          //                     child: Image.asset(
          //                       'assets/visa.png',
          //                     )),
          //               ),
          //               //Master Card
          //               Padding(
          //                 padding: const EdgeInsets.only(right: 5),
          //                 child: SizedBox(
          //                     width: 100,
          //                     height: 100,
          //                     child: Image.asset(
          //                       'assets/master.png',
          //                     )),
          //               ),
          //               // Padding(
          //               //   padding: const EdgeInsets.all(8.0),
          //               //   child: Container(
          //               //     decoration: BoxDecoration(
          //               //       color: Colors
          //               //           .white, // Background color of the outer container
          //               //       border: Border.all(
          //               //         color: Colors.grey, // Grey border color
          //               //         width: 2.0, // Border width
          //               //       ),
          //               //       boxShadow: [
          //               //         BoxShadow(
          //               //           // Grey shadow color with opacity
          //               //           color: Colors.grey.withOpacity(0.5),
          //               //           spreadRadius: 2, // How far the shadow spreads
          //               //           blurRadius: 5, // How much the shadow is blurred
          //               //           offset: Offset(0, 3), // Position of the shadow
          //               //         ),
          //               //       ],
          //               //       borderRadius: BorderRadius.circular(
          //               //           8), // Optional: Add border radius
          //               //     ),
          //               //     child: Padding(
          //               //       padding: const EdgeInsets.all(8.0),
          //               //       child: Image.asset('assets/mastercard logo.png'),
          //               //     ),
          //               //   ),
          //               // ),
          //               //JCB
          //               Padding(
          //                 padding: const EdgeInsets.only(right: 5),
          //                 child: SizedBox(
          //                     width: 100,
          //                     height: 100,
          //                     child: Image.asset(
          //                       'assets/jcb.png',
          //                     )),
          //               ),
          //               // Padding(
          //               //   padding: const EdgeInsets.all(8.0),
          //               //   child: Container(
          //               //     decoration: BoxDecoration(
          //               //       color: Colors
          //               //           .white, // Background color of the outer container
          //               //       border: Border.all(
          //               //         color: Colors.grey, // Grey border color
          //               //         width: 2.0, // Border width
          //               //       ),
          //               //       boxShadow: [
          //               //         BoxShadow(
          //               //           // Grey shadow color with opacity
          //               //           color: Colors.grey.withOpacity(0.5),
          //               //           spreadRadius: 2, // How far the shadow spreads
          //               //           blurRadius: 5, // How much the shadow is blurred
          //               //           offset: Offset(0, 3), // Position of the shadow
          //               //         ),
          //               //       ],
          //               //       borderRadius: BorderRadius.circular(
          //               //           8), // Optional: Add border radius
          //               //     ),
          //               //     child: Padding(
          //               //       padding: const EdgeInsets.all(8.0),
          //               //       child: Image.asset('assets/jcb logo.png'),
          //               //     ),
          //               //   ),
          //               // ),
          //             ],
          //           ),
          //         ),
          //       ),
          //       //next icon
          //       Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          //     ],
          //   ),
          // ),
          //NEW
          BlocConsumer<InvoiceGroupCubit, InvoiceGroupState>(
            listener: (context, state) async {
              if (state is BankCodeSuccess) {
                bankCodeList.clear();
                bankCodeList = state.response;
              }
            },
            builder: (context, state) {
              final List<BankCodeAccesses> paymentMethods = [
                BankCodeAccesses(
                  name: "CREDITCARD",
                  value: "008",
                  description: "Credit Card Visa / Master / JCB",
                ),
              ];

              // Map `name` to image assets
              final Map<String, String> nameToAssetMap = {
                "VISA": "assets/visa.png",
                "MasterCard": "assets/master.png",
                "JCB": "assets/jcb.png",
              };

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: paymentMethods.expand((method) {
                          // Create three tiles for different assets with the same data
                          return [
                            "VISA",
                            "MasterCard",
                            "JCB",
                          ].map((cardType) {
                            return InkWell(
                              onTap: () {
                                selectedMethodName = method.name;
                                selectedMethodValue = method.value;
                                context.read<InvoiceGroupCubit>().bankCode(
                                    // method.name!,
                                    // method.value!,
                                    selectedMethodName ?? '',
                                    selectedMethodValue ?? '');
                                print('Name nya: ${method.name}');
                                print('Value nya: ${method.value}');
                                setState(() {
                                  Navigator.of(context).pop();
                                  // selectedPaymentMethod = method.description!;
                                  selectedPaymentMethod = "Credit Card";
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(right: 5),
                                child: SizedBox(
                                  width: 100,
                                  height: 100,
                                  child: Image.asset(
                                    nameToAssetMap[cardType]!,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            );
                          }).toList();
                        }).toList(),
                      ),
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                ],
              );
            },
          ),
          Container(
            height: 3,
            color: Colors.grey[300],
          ),
          SizedBox(height: 15),
          Text(
            "Lainnya",
            style: TextStyle(fontSize: 15, fontFamily: 'Poppinss'),
          ),
          // SizedBox(height: 20),
          InkWell(
            onTap: () {
              // lainnya();
              final bankCodeList = [
                BankCodeAccesses(
                    name: "SALDOMUQR",
                    value: "008",
                    description: "SALDOMU QRIS"),
                BankCodeAccesses(
                    name: "BCAONEKLIK", value: "014", description: "OneKlik"),
              ];
              lainnya(bankCodeList);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    //QRIS
                    Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: SizedBox(
                          width: 100,
                          height: 100,
                          child: Image.asset(
                            'assets/qriss.png',
                          )),
                    ),
                    //BCA KLIK PAY
                    Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: SizedBox(
                          width: 100,
                          height: 100,
                          child: Image.asset(
                            'assets/klikpay.png',
                          )),
                    ),
                  ],
                ),
                //next icon
                Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
              ],
            ),
          ),
          // SizedBox(height: 10),
        ],
      ),
    );
  }

  // metodeVA() {
  //   return ConstrainedBox(
  //     // constraints: BoxConstraints(maxHeight: 990, maxWidth: 300),
  //     constraints: BoxConstraints(maxHeight: 990),
  //     child: Column(
  //       mainAxisSize: MainAxisSize.min,
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         SizedBox(height: 20),
  //         //BRI
  //         InkWell(
  //           onTap: () {
  //             setState(() {
  //               // Close the virtualAccount dialog first
  //               Navigator.of(context).pop();

  //               // Close the pilihPembayaran dialog
  //               Navigator.of(context).pop();
  //               selectedPaymentMethod =
  //                   "Virtual Account BRI"; // Update the text
  //             });
  //             // Navigator.of(context).pop(); // Close the dialog
  //           },
  //           child: Row(
  //             children: [
  //               Padding(
  //                 padding: const EdgeInsets.only(right: 5),
  //                 child: SizedBox(
  //                     width: 100,
  //                     height: 100,
  //                     child: Image.asset(
  //                       'assets/bri.png',
  //                     )),
  //               ),
  //               Text(
  //                 'BRI VA',
  //                 style: TextStyle(fontSize: 13, fontFamily: 'Poppins Bold'),
  //               )
  //             ],
  //           ),
  //         ),
  //         Container(
  //           height: 5,
  //           color: Colors.grey[300],
  //         ),
  //         //CIMB NIAGA
  //         InkWell(
  //           onTap: () {
  //             setState(() {
  //               // Close the virtualAccount dialog first
  //               Navigator.of(context).pop();

  //               // Close the pilihPembayaran dialog
  //               Navigator.of(context).pop();
  //               selectedPaymentMethod =
  //                   "Virtual Account CIMB NIAGA"; // Update the text
  //             });
  //             // Navigator.of(context).pop(); // Close the dialog
  //           },
  //           child: Row(
  //             children: [
  //               Padding(
  //                 padding: const EdgeInsets.only(right: 5),
  //                 child: SizedBox(
  //                     width: 100,
  //                     height: 100,
  //                     child: Image.asset(
  //                       'assets/cimb.png',
  //                     )),
  //               ),
  //               Text(
  //                 'CIMB Niaga VA',
  //                 style: TextStyle(fontSize: 13, fontFamily: 'Poppins Bold'),
  //               )
  //             ],
  //           ),
  //         ),
  //         Container(
  //           height: 5,
  //           color: Colors.grey[300],
  //         ),
  //         //BNI
  //         InkWell(
  //           onTap: () {
  //             setState(() {
  //               // Close the virtualAccount dialog first
  //               Navigator.of(context).pop();

  //               // Close the pilihPembayaran dialog
  //               Navigator.of(context).pop();
  //               selectedPaymentMethod =
  //                   "Virtual Account BNI"; // Update the text
  //             });
  //             // Navigator.of(context).pop(); // Close the dialog
  //           },
  //           child: Row(
  //             children: [
  //               // Padding(
  //               //   padding: const EdgeInsets.all(8.0),
  //               //   child: Container(
  //               //     decoration: BoxDecoration(
  //               //       color: Colors
  //               //           .white, // Background color of the outer container
  //               //       border: Border.all(
  //               //         color: Colors.grey, // Grey border color
  //               //         width: 2.0, // Border width
  //               //       ),
  //               //       boxShadow: [
  //               //         BoxShadow(
  //               //           // Grey shadow color with opacity
  //               //           color: Colors.grey.withOpacity(0.5),
  //               //           spreadRadius: 2, // How far the shadow spreads
  //               //           blurRadius: 5, // How much the shadow is blurred
  //               //           offset: Offset(0, 3), // Position of the shadow
  //               //         ),
  //               //       ],
  //               //       borderRadius: BorderRadius.circular(
  //               //           8), // Optional: Add border radius
  //               //     ),
  //               //     child: Padding(
  //               //         padding: const EdgeInsets.all(8.0),
  //               //         child: Image.asset(
  //               //           'assets/bni logo.png',
  //               //           width: 50,
  //               //           height: 30,
  //               //           fit: BoxFit.contain,
  //               //         )),
  //               //   ),
  //               // ),
  //               Padding(
  //                 padding: const EdgeInsets.only(right: 5),
  //                 child: SizedBox(
  //                     width: 100,
  //                     height: 100,
  //                     child: Image.asset(
  //                       'assets/bni.png',
  //                     )),
  //               ),
  //               Text(
  //                 'BNI VA',
  //                 style: TextStyle(fontSize: 13, fontFamily: 'Poppins Bold'),
  //               )
  //             ],
  //           ),
  //         ),
  //         Container(
  //           height: 5,
  //           color: Colors.grey[300],
  //         ),
  //         //BCA
  //         InkWell(
  //           onTap: () {
  //             setState(() {
  //               // Close the virtualAccount dialog first
  //               Navigator.of(context).pop();

  //               // Close the pilihPembayaran dialog
  //               Navigator.of(context).pop();
  //               selectedPaymentMethod =
  //                   "Virtual Account BCA"; // Update the text
  //             });
  //             // Navigator.of(context).pop(); // Close the dialog
  //           },
  //           child: Row(
  //             children: [
  //               Padding(
  //                 padding: const EdgeInsets.only(right: 5),
  //                 child: SizedBox(
  //                     width: 100,
  //                     height: 100,
  //                     child: Image.asset(
  //                       'assets/bca.png',
  //                     )),
  //               ),
  //               Text(
  //                 'BCA VA',
  //                 style: TextStyle(fontSize: 13, fontFamily: 'Poppins Bold'),
  //               )
  //             ],
  //           ),
  //         ),
  //         Container(
  //           height: 5,
  //           color: Colors.grey[300],
  //         ),
  //         //MANDIRI
  //         InkWell(
  //           onTap: () {
  //             setState(() {
  //               // Close the virtualAccount dialog first
  //               Navigator.of(context).pop();

  //               // Close the pilihPembayaran dialog
  //               Navigator.of(context).pop();
  //               selectedPaymentMethod =
  //                   "Virtual Account Mandiri"; // Update the text
  //             });
  //             // Navigator.of(context).pop(); // Close the dialog
  //           },
  //           child: Row(
  //             children: [
  //               Padding(
  //                 padding: const EdgeInsets.only(right: 5),
  //                 child: SizedBox(
  //                     width: 100,
  //                     height: 100,
  //                     child: Image.asset(
  //                       'assets/mandiri.png',
  //                     )),
  //               ),
  //               Text(
  //                 'Mandiri VA',
  //                 style: TextStyle(fontSize: 13, fontFamily: 'Poppins Bold'),
  //               )
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  metodeVA(BuildContext context, List<BankCodeAccesses> bankCodeList) {
    // Map bank names to asset paths
    final Map<String, String> nameToAssetMap = {
      "BRIATM": "assets/bri.png",
      "CIMBATM": "assets/cimb.png",
      "BNIATM": "assets/bni.png",
      "BCAATM": "assets/bca.png",
      "MANDIRIATM": "assets/mandiri.png",
    };

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 990),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: bankCodeList.map((method) {
          // Ensure an asset exists for the bank code name
          final assetPath = nameToAssetMap[method.name] ?? "assets/default.png";

          return Column(
            children: [
              InkWell(
                onTap: () {
                  selectedMethodName = method.name;
                  selectedMethodValue = method.value;
                  // Trigger bankCode method in InvoiceGroupCubit
                  context.read<InvoiceGroupCubit>().bankCode(
                      // method.name ?? "",
                      // method.value ?? "",
                      selectedMethodName ?? '',
                      selectedMethodValue ?? '');

                  setState(() {
                    // Close the dialogs
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();

                    // Update the selected payment method
                    // selectedPaymentMethod =
                    //     "Modern Channel - ${method.description}";
                    if (method.name == "BRIATM") {
                      selectedPaymentMethod = "Virtual Account BRI";
                    } else if (method.name == "CIMBATM") {
                      selectedPaymentMethod = "Virtual Account CIMB NIAGA";
                    } else if (method.name == "BNIATM") {
                      selectedPaymentMethod = "Virtual Account BNI";
                    } else if (method.name == "BCAATM") {
                      selectedPaymentMethod = "Virtual Account BCA";
                    } else if (method.name == "MANDIRIATM") {
                      selectedPaymentMethod = "Virtual Account Mandiri";
                    }
                  });

                  final fee = feeEspayList
                      .firstWhere(
                        (fee) => fee.name!.toLowerCase() == "feeva",
                        orElse: () => FeeEspayAccesses(value: "0"),
                      )
                      .value;

                  // Log the name and value of the selected payment method
                  print("Selected Name: ${method.name}");
                  print("Selected Value: ${method.value}");
                  print('Fee Value: $fee');
                },
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: SizedBox(
                        width: 100,
                        height: 100,
                        child: Image.asset(assetPath),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        method.description ?? "",
                        style:
                            TextStyle(fontSize: 13, fontFamily: 'Poppins Bold'),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 5,
                color: Colors.grey[300],
              ),
              SizedBox(height: 15),
            ],
          );
        }).toList(),
      ),
    );
  }

  // metodeModernMarket() {
  //   return ConstrainedBox(
  //     constraints: BoxConstraints(maxHeight: 990),
  //     child: Column(
  //       mainAxisSize: MainAxisSize.min,
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         //Indomaret
  //         InkWell(
  //           onTap: () {
  //             setState(() {
  //               // Close the virtualAccount dialog first
  //               Navigator.of(context).pop();

  //               // Close the pilihPembayaran dialog
  //               Navigator.of(context).pop();
  //               selectedPaymentMethod =
  //                   "Modern Channel - Indomaret"; // Update the text
  //             });
  //           },
  //           child: Row(
  //             children: [
  //               // Padding(
  //               //   padding: const EdgeInsets.all(8.0),
  //               //   child: Container(
  //               //     decoration: BoxDecoration(
  //               //       color: Colors
  //               //           .white, // Background color of the outer container
  //               //       border: Border.all(
  //               //         color: Colors.grey, // Grey border color
  //               //         width: 2.0, // Border width
  //               //       ),
  //               //       boxShadow: [
  //               //         BoxShadow(
  //               //           // Grey shadow color with opacity
  //               //           color: Colors.grey.withOpacity(0.5),
  //               //           spreadRadius: 2, // How far the shadow spreads
  //               //           blurRadius: 5, // How much the shadow is blurred
  //               //           offset: Offset(0, 3), // Position of the shadow
  //               //         ),
  //               //       ],
  //               //       borderRadius: BorderRadius.circular(
  //               //           8), // Optional: Add border radius
  //               //     ),
  //               //     child: Padding(
  //               //         padding: const EdgeInsets.all(8.0),
  //               //         child: Image.asset(
  //               //           'assets/indomaret logo.png',
  //               //           width: 50,
  //               //           height: 30,
  //               //           fit: BoxFit.contain,
  //               //         )),
  //               //   ),
  //               // ),
  //               Padding(
  //                 padding: const EdgeInsets.only(right: 5),
  //                 child: SizedBox(
  //                     width: 100,
  //                     height: 100,
  //                     child: Image.asset(
  //                       'assets/indomaret.png',
  //                     )),
  //               ),
  //               Text(
  //                 'Indomaret',
  //                 style: TextStyle(fontSize: 13, fontFamily: 'Poppins Bold'),
  //               )
  //             ],
  //           ),
  //         ),
  //         Container(
  //           height: 5,
  //           color: Colors.grey[300],
  //         ),
  //         SizedBox(height: 15),
  //         //Alfamart
  //         InkWell(
  //           onTap: () {
  //             setState(() {
  //               // Close the virtualAccount dialog first
  //               Navigator.of(context).pop();

  //               // Close the pilihPembayaran dialog
  //               Navigator.of(context).pop();
  //               selectedPaymentMethod =
  //                   "Modern Channel - Alfamart"; // Update the text
  //             });
  //           },
  //           child: Row(
  //             children: [
  //               Padding(
  //                 padding: const EdgeInsets.only(right: 5),
  //                 child: SizedBox(
  //                     width: 100,
  //                     height: 100,
  //                     child: Image.asset(
  //                       'assets/alfamart.png',
  //                     )),
  //               ),
  //               Text(
  //                 'Alfamart / Alfamidi',
  //                 style: TextStyle(fontSize: 13, fontFamily: 'Poppins Bold'),
  //               )
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  metodeModernMarket(
      BuildContext context, List<BankCodeAccesses> bankCodeList) {
    // Map bank names to asset paths
    final Map<String, String> nameToAssetMap = {
      "INDOMARETESPAY": "assets/indomaret.png",
      "ALFAMARTESPAY": "assets/alfamart.png",
    };

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 990),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: bankCodeList.map((method) {
          // Ensure an asset exists for the bank code name
          final assetPath = nameToAssetMap[method.name] ?? "assets/default.png";

          return Column(
            children: [
              InkWell(
                onTap: () {
                  selectedMethodName = method.name;
                  selectedMethodValue = method.value;
                  // Trigger bankCode method in InvoiceGroupCubit
                  context.read<InvoiceGroupCubit>().bankCode(
                      // method.name ?? "",
                      // method.value ?? "",
                      selectedMethodName ?? '',
                      selectedMethodValue ?? '');

                  setState(() {
                    // Close the dialogs
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();

                    // Update the selected payment method
                    // selectedPaymentMethod =
                    //     "Modern Channel - ${method.description}";
                    if (method.name == "INDOMARETESPAY") {
                      selectedPaymentMethod = "Modern Channel - Indomaret";
                    } else if (method.name == "ALFAMARTESPAY") {
                      selectedPaymentMethod = "Modern Channel - Alfamart";
                    }
                  });

                  // Log the name and value of the selected payment method
                  print("Selected Name: ${method.name}");
                  print("Selected Value: ${method.value}");
                },
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: SizedBox(
                        width: 100,
                        height: 100,
                        child: Image.asset(assetPath),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        method.description ?? "",
                        style:
                            TextStyle(fontSize: 13, fontFamily: 'Poppins Bold'),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 5,
                color: Colors.grey[300],
              ),
              SizedBox(height: 15),
            ],
          );
        }).toList(),
      ),
    );
  }

  // metodeLainnya() {
  //   return ConstrainedBox(
  //     constraints: BoxConstraints(maxHeight: 990),
  //     child: Column(
  //       mainAxisSize: MainAxisSize.min,
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         //QRIS
  //         InkWell(
  //           onTap: () {
  //             setState(() {
  //               // Close the virtualAccount dialog first
  //               Navigator.of(context).pop();

  //               // Close the pilihPembayaran dialog
  //               Navigator.of(context).pop();
  //               selectedPaymentMethod = "QRIS"; // Update the text
  //             });
  //           },
  //           child: Row(
  //             children: [
  //               Padding(
  //                 padding: const EdgeInsets.only(right: 5),
  //                 child: SizedBox(
  //                     width: 100,
  //                     height: 100,
  //                     child: Image.asset(
  //                       'assets/qriss.png',
  //                     )),
  //               ),
  //               Text(
  //                 'QRIS',
  //                 style: TextStyle(fontSize: 13, fontFamily: 'Poppins Bold'),
  //               )
  //             ],
  //           ),
  //         ),
  //         Container(
  //           height: 5,
  //           color: Colors.grey[300],
  //         ),
  //         //BCA KLIK PAY
  //         InkWell(
  //           onTap: () {
  //             setState(() {
  //               // Close the virtualAccount dialog first
  //               Navigator.of(context).pop();

  //               // Close the pilihPembayaran dialog
  //               Navigator.of(context).pop();
  //               selectedPaymentMethod = "BCA KlikPay"; // Update the text
  //             });
  //           },
  //           child: Row(
  //             children: [
  //               Padding(
  //                 padding: const EdgeInsets.only(right: 5),
  //                 child: SizedBox(
  //                     width: 100,
  //                     height: 100,
  //                     child: Image.asset(
  //                       'assets/klikpay.png',
  //                     )),
  //               ),
  //               Text(
  //                 'BCA KlikPay',
  //                 style: TextStyle(fontSize: 13, fontFamily: 'Poppins Bold'),
  //               )
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  metodeLainnya(BuildContext context, List<BankCodeAccesses> bankCodeList) {
    // Map bank names to asset paths
    final Map<String, String> nameToAssetMap = {
      "SALDOMUQR": "assets/qriss.png",
      "BCAONEKLIK": "assets/klikpay.png",
    };

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 990),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: bankCodeList.map((method) {
          // Ensure an asset exists for the bank code name
          final assetPath = nameToAssetMap[method.name] ?? "assets/default.png";

          return Column(
            children: [
              InkWell(
                onTap: () {
                  selectedMethodName = method.name;
                  selectedMethodValue = method.value;
                  // Trigger bankCode method in InvoiceGroupCubit
                  context.read<InvoiceGroupCubit>().bankCode(
                      // method.name ?? "",
                      // method.value ?? "",
                      selectedMethodName ?? '',
                      selectedMethodValue ?? '');

                  setState(() {
                    // Close the dialogs
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();

                    // Update the selected payment method
                    // selectedPaymentMethod =
                    //     "Modern Channel - ${method.description}";
                    if (method.name == "SALDOMUQR") {
                      selectedPaymentMethod = "QRIS";
                    } else if (method.name == "BCAONEKLIK") {
                      selectedPaymentMethod = "BCA KlikPay";
                    }
                  });

                  // Log the name and value of the selected payment method
                  print("Selected Name: ${method.name}");
                  print("Selected Value: ${method.value}");
                },
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: SizedBox(
                        width: 100,
                        height: 100,
                        child: Image.asset(assetPath),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        method.description ?? "",
                        style:
                            TextStyle(fontSize: 13, fontFamily: 'Poppins Bold'),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 5,
                color: Colors.grey[300],
              ),
              SizedBox(height: 15),
            ],
          );
        }).toList(),
      ),
    );
  }
}
