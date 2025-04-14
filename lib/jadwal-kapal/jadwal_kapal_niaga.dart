import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:niaga_apps_mobile/tracking/menu_tracking_niaga.dart';
import '../Invoice/menu_invoice_niaga.dart';
import '../cubit/niaga/jadwal_kapal_cubit.dart';
import '../cubit/wa_cubit.dart';
import '../model/niaga/jadwal-kapal/jadwal_kapal.dart';
import '../order/menu_order_niaga.dart';
import '../profile/profil_niaga.dart';
import '../screen-niaga/home_niaga.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

class JadwalKapalNiagaPage extends StatefulWidget {
  final String portAsal; // Add this line
  final String portTujuan; // Add this line
  final String date;
  final String kotaAsal;
  final String kotaTujuan;
  const JadwalKapalNiagaPage({
    Key? key,
    required this.portAsal,
    required this.portTujuan,
    required this.date,
    required this.kotaAsal,
    required this.kotaTujuan,
  }) : super(key: key);

  @override
  State<JadwalKapalNiagaPage> createState() => _JadwalKapalNiagaPageState();
}

class _JadwalKapalNiagaPageState extends State<JadwalKapalNiagaPage> {
  @override
  //untuk BottomNavigationBarItem
  int _selectedIndex = 0;
  //untuk BottomNavigationBarItem
  bool isSelected = false;
  int currentPageIndex = 0;
  int itemsPerPage = 5;
  ScrollController _scrollController = ScrollController(); //untuk pagination

  List<JadwalKapalNiagaAccesses> kapalModellist = [];

  TextEditingController _pageController = TextEditingController();

  //untuk BottomNavigationBarItem
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
    // BlocProvider.of<JadwalKapalNiagaCubit>(context)
    //     .jadwalKapalNiaga('SBY', 'MKS', '14/10/2024');
    BlocProvider.of<JadwalKapalNiagaCubit>(context).jadwalKapalNiaga(
      widget.portAsal,
      widget.portTujuan,
      widget.date,
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void _onItemTapped(int index) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => _widgetOptions[index]),
    );
  }

  Future searchPage() => showDialog(
      context: context,
      //alert diberi SingleChildScrollView agar bisa di scroll
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
                  content: searchPagination()),
            ),
          ));

  searchPagination() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Align content to start
        children: [
          SizedBox(height: 5),
          Table(
            columnWidths: {
              0: FlexColumnWidth(4),
              1: FlexColumnWidth(1),
              2: FlexColumnWidth(4),
            },
            children: [
              TableRow(children: [
                TableCell(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 2.0),
                    child: Text(
                      "Menuju Halaman",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontFamily: 'Poppinss'),
                    ),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 12.0, horizontal: 2.0),
                    child: Text(':',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontFamily: 'Poppinss')),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                    child: Container(
                      width: 50,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5.0),
                        border: Border.all(
                          color: Colors.black,
                          width: 1.0,
                        ),
                      ),
                      padding:
                          EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),
                      child: TextField(
                        controller: _pageController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 13),
                          border: InputBorder.none,
                        ),
                        style: TextStyle(
                            color: Colors.black,
                            fontSize:
                                _pageController.text.length > 5 ? 10.0 : 12.0,
                            fontFamily: 'Montserrat'),
                        onChanged: (value) {
                          // Handle the input value if needed
                        },
                      ),
                    ),
                  ),
                ),
              ]),
            ],
          ),
          SizedBox(height: 10),
          Table(
            columnWidths: {
              0: FlexColumnWidth(4),
              1: FlexColumnWidth(1),
              2: FlexColumnWidth(4),
            },
            children: [
              TableRow(children: [
                TableCell(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 2.0),
                    child: Text(
                      "Halaman Terakhir",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontFamily: 'Poppinss'),
                    ),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 12.0, horizontal: 2.0),
                    child: Text(':',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontFamily: 'Poppinss')),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                    child: Text(
                        ((kapalModellist.length / itemsPerPage).ceil())
                            .toString(),
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontFamily: 'Poppinss')),
                  ),
                ),
              ]),
            ],
          ),
          SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Flexible(
                child: SizedBox(
                  width: 80,
                  height: 40,
                  child: Material(
                    borderRadius: BorderRadius.circular(7.0),
                    color: Colors.white,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        minimumSize: Size(100, 50),
                        side: BorderSide(color: Colors.red[900]!, width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7.0),
                        ),
                        backgroundColor: Colors.white,
                      ),
                      onPressed: () {
                        int pageNumber =
                            int.tryParse(_pageController.text) ?? 1;
                        int maxPage =
                            (kapalModellist.length / itemsPerPage).ceil();
                        if (pageNumber > 0 && pageNumber <= maxPage) {
                          setState(() {
                            currentPageIndex = pageNumber - 1;
                            _scrollController.animateTo(
                              0.0,
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                            );
                          });
                          Navigator.of(context).pop();
                        }
                      },
                      child: Text(
                        'Find',
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.red[900],
                            fontFamily: 'Poppins Med'), // Smaller font
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Flexible(
                child: SizedBox(
                  width: 90,
                  height: 40,
                  child: Material(
                    borderRadius: BorderRadius.circular(7.0),
                    color: Colors.red[900],
                    child: MaterialButton(
                      padding: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "Cancel",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          letterSpacing: 1.5,
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future downloadSuccess() => showDialog(
      context: context,
      //alert diberi SingleChildScrollView agar bisa di scroll
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
                    children: [
                      // IconButton(
                      //     icon: Icon(Icons.close),
                      //     onPressed: () {
                      //       Navigator.of(context).pop();
                      //     })
                    ],
                  ),
                  content: downloadGambar()),
            ),
          ));

  //untuk fungsi pop up dialog search
  Future searchMyInvoice() => showDialog(
      context: context,
      //alert diberi SingleChildScrollView agar bisa di scroll
      builder: (BuildContext context) => SingleChildScrollView(
            child: AlertDialog(
              //untuk memberi border melengkung
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              content: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 40, maxWidth: 300),
                child: Form(
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          BlocProvider.of<WACubit>(context).sendwhatsapp(
                            portAsal: "Jakarta",
                            portTujuan: "Surabaya",
                            shippingLine: "XYZ Shipping",
                            vesselName: "Vessel 123",
                            voyageNo: "VOY001",
                            rutePanjang: "Jakarta - Surabaya",
                            tglClosing: "2024-09-01",
                            etd: "2024-09-05",
                            eta: "2024-09-10",
                          );
                        },
                        child: Expanded(
                          child: Image.asset(
                            'assets/WA.png', // Replace 'your_image.png' with your image asset path
                            height: 80, // Adjust height as needed
                            width: 80, // Adjust width as needed
                          ),
                        ),
                      ),
                      Expanded(
                        child: Image.asset(
                          'assets/telegram.png', // Replace 'your_image.png' with your image asset path
                          height: 80, // Adjust height as needed
                          width: 80, // Adjust width as needed
                        ),
                      ),
                      Expanded(
                        child: Image.asset(
                          'assets/Image.png', // Replace 'your_image.png' with your image asset path
                          height: 80, // Adjust height as needed
                          width: 80, // Adjust width as needed
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ));

  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return BlocConsumer<JadwalKapalNiagaCubit, JadwalKapalNiagaState>(
        listener: (context, state) async {
      if (state is DownloadImageKapalSuccess) {
        await downloadSuccess();
      }
    }, builder: (context, state) {
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
                    "Jadwal Kapal",
                    style: TextStyle(
                        fontSize: 17,
                        color: Colors.red[900],
                        fontFamily: 'Poppins Extra Bold'),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    String kotaAsal =
                        widget.portAsal.isEmpty ? '' : widget.portAsal;
                    String kotaTujuan =
                        widget.portTujuan.isEmpty ? '' : widget.portTujuan;
                    String portAsal =
                        widget.kotaAsal.isEmpty ? 'semua' : widget.kotaAsal;
                    String portTujuan =
                        widget.kotaTujuan.isEmpty ? 'semua' : widget.kotaTujuan;
                    String etdFrom = widget.date.isEmpty ? '' : widget.date;

                    print("kotaAsal type: ${kotaAsal.runtimeType}");
                    print("kotaTujuan type: ${kotaTujuan.runtimeType}");
                    print("portAsal type: ${portAsal.runtimeType}");
                    print("portTujuan type: ${portTujuan.runtimeType}");

                    context.read<JadwalKapalNiagaCubit>().downloadImageKapal(
                          portAsal,
                          portTujuan,
                          kotaAsal,
                          kotaTujuan,
                          etdFrom
                        );
                  },
                  child: Image.asset(
                    'assets/Image.png',
                    height: 70,
                    width: 70,
                  ),
                ),
              ],
            ),
            toolbarHeight: 0.07 * MediaQuery.of(context).size.height,
          ),
        ),
        body: BlocConsumer<WACubit, WAState>(
          listener: (context, state) {
            if (state is SendWhatsappSuccess) {
              // Show success message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  // content: Text('PDF sent via WhatsApp'),
                  // duration: Duration(seconds: 2),
                  content: Text('Success sent WA'),
                  duration: Duration(seconds: 2),
                ),
              );
            }
            if (state is SendWhatsappFailure) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                // content: Text('Failed to send PDF via WhatsApp'),
                // duration: Duration(seconds: 2),
                content: Text('Failed to send via WhatsApp'),
                duration: Duration(seconds: 2),
              ));
            }
          },
          builder: (context, state) {
            return BlocConsumer<JadwalKapalNiagaCubit, JadwalKapalNiagaState>(
              listener: (context, state) async {
                // if (state is JadwalKapalInProgress) {
                //   await showLoadingDialog(context);
                // } else
                if (state is JadwalKapalNiagaSuccess) {
                  // await Future.delayed(Duration(seconds: 3));
                  kapalModellist.clear();
                  kapalModellist = state.response;
                  //order by ascending
                  // kapalModellist.sort((a, b) => a.id!.compareTo(b.id!));
                  // hideLoadingDialog(context);
                }
              },
              builder: (context, state) {
                if (state is JadwalKapalNiagaInProgress ||
                    state is LogNiagaInProgress) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Colors.amber[600],
                    ),
                  );
                }
                if (state is DownloadImageKapalInProgress) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Colors.amber[600],
                    ),
                  );
                }
                return SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.end,
                      //   children: [
                      //     Image.asset(
                      //       'assets/WA.png', // Replace 'your_image.png' with your image asset path
                      //       height: 80, // Adjust height as needed
                      //       width: 80, // Adjust width as needed
                      //     ),
                      //     Image.asset(
                      //       'assets/Image.png', // Replace 'your_image.png' with your image asset path
                      //       height: 80, // Adjust height as needed
                      //       width: 80, // Adjust width as needed
                      //     ),
                      //   ],
                      // ),
                      ListView.builder(
                          shrinkWrap: true,
                          // physics: NeverScrollableScrollPhysics(),
                          // itemCount: kapalModellist.length,
                          itemCount:
                              (kapalModellist.length / itemsPerPage).ceil() > 0
                                  ? itemsPerPage
                                  : 0,
                          controller: ScrollController(),
                          itemBuilder: (context, index) {
                            final int itemIndex =
                                currentPageIndex * itemsPerPage + index;
                            // var data = kapalModellist[index];
                            if (itemIndex < kapalModellist.length) {
                              var data = kapalModellist[itemIndex];
                              return Container(
                                // margin: EdgeInsets.all(18),
                                margin: EdgeInsets.only(
                                    left: 18, top: 18, right: 18),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                  // boxShadow: [
                                  //   BoxShadow(
                                  //     color: Color(
                                  //         0xFFB0BEC5), // A color close to grey[350]
                                  //     offset: Offset(0, 6),
                                  //     blurRadius: 10,
                                  //     spreadRadius: 1,
                                  //   )
                                  // ]
                                ),
                                //untuk form
                                child: Padding(
                                  // padding: EdgeInsets.all(16.0),
                                  padding: EdgeInsets.only(
                                      left: 12, top: 10, right: 12, bottom: 14),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            data.vesselName!,
                                            // '${data.shippingLine!} ${data.vesselName!}',
                                            style: TextStyle(
                                                color: Colors.red[900],
                                                fontSize: 15,
                                                fontFamily: 'Poppins Med'),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              final String portAsal =
                                                  data.portAsal.toString();
                                              final String portTujuan =
                                                  data.portTujuan.toString();
                                              final String shippingLine =
                                                  data.shippingLine.toString();
                                              final String vesselName =
                                                  data.vesselName.toString();
                                              final String voyageNo =
                                                  data.voyageNo.toString();
                                              final String rutePanjang =
                                                  data.rutePanjang.toString();
                                              final String tglClosing =
                                                  data.tglClosing.toString();
                                              final String etd =
                                                  data.etd.toString();
                                              final String eta =
                                                  data.eta.toString();

                                              void _launchWhatsApp() async {
                                                final url =
                                                    'https://api.whatsapp.com/send?text=*JADWAL%20KAPAL%20NIAGA%20LOGISTICS*%0A%0AUntuk%20Jadwal%20Kapal%20Dengan%20Rute:%0A$portAsal-$portTujuan,%20Meliputi%0A%0A*$shippingLine*%0A$vesselName%20Voy%20$voyageNo%0ARute%20Lengkap%20:%20$rutePanjang%0AClossing%20Cargo%20:%20$tglClosing%0AEst%20Berangkat%20:%20$etd%0AEst%20Tiba%20:%20$eta';

                                                if (await canLaunch(url)) {
                                                  await launch(url);
                                                } else {
                                                  throw 'Could not launch $url';
                                                }
                                              }

                                              _launchWhatsApp();
                                            },
                                            child: SizedBox(
                                                height: 40.0,
                                                child: Image.asset(
                                                    'assets/WA.png')),
                                          )
                                        ],
                                      ),
                                      //untuk membuat tabel
                                      SizedBox(height: 10),
                                      Table(
                                        //mengatur panjang atau ukuran tabel
                                        columnWidths: {
                                          0: FlexColumnWidth(3),
                                          1: FlexColumnWidth(1),
                                          2: FlexColumnWidth(5),
                                          // 0: FlexColumnWidth(5), // First column
                                          // 1: FlexColumnWidth(1),
                                          // 2: FlexColumnWidth(6), // Third column
                                          // 3: FlexColumnWidth(6),
                                        },
                                        children: [
                                          TableRow(children: [
                                            //baris 1 No Voyage kolom tabel
                                            TableCell(
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 4.0,
                                                    horizontal: 2.0),
                                                child: Text(
                                                  'No Voyage',
                                                  style: TextStyle(
                                                      fontFamily: 'Poppins Med',
                                                      fontSize: 12),
                                                ),
                                              ),
                                            ),
                                            TableCell(
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 4.0,
                                                    horizontal: 2.0),
                                                child: Text(
                                                  ':',
                                                  style: TextStyle(
                                                      fontFamily: 'Poppins Med',
                                                      fontSize: 12),
                                                ),
                                              ),
                                            ),
                                            TableCell(
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 4.0,
                                                    horizontal: 2.0),
                                                child:
                                                    // (item.containsKey('voyage'))
                                                    Text(
                                                  data.voyageNo!,
                                                  style: TextStyle(
                                                      fontFamily: 'Poppins Med',
                                                      fontSize: 12),
                                                ),
                                              ),
                                            ),
                                            // TableCell(
                                            //   child: Row(
                                            //     children: [
                                            //       IconButton(
                                            //         icon: Icon(
                                            //             Icons.calendar_today,
                                            //             size: 20),
                                            //         onPressed: () {
                                            //           // Handle ETA calendar action
                                            //         },
                                            //       ),
                                            //       Expanded(
                                            //         child: Text(
                                            //             // 'ETA ${data.etaDate ?? 'N/A'}',
                                            //             'ETA ${data.eta}', // Use formattedTime here
                                            //             style: TextStyle(
                                            //                 fontWeight:
                                            //                     FontWeight.w900,
                                            //                 fontSize: 10)),
                                            //       ),
                                            //     ],
                                            //   ),
                                            // ),
                                          ]),
                                          //baris ke 2 Tanggal Closing
                                          TableRow(children: [
                                            TableCell(
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 4.0,
                                                    horizontal: 2.0),
                                                child: Text(
                                                  'Tanggal Closing',
                                                  style: TextStyle(
                                                      fontFamily: 'Poppins Med',
                                                      fontSize: 12),
                                                ),
                                              ),
                                            ),
                                            TableCell(
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 4.0,
                                                    horizontal: 2.0),
                                                child: Text(
                                                  ':',
                                                  style: TextStyle(
                                                      fontFamily: 'Poppins Med',
                                                      fontSize: 12),
                                                ),
                                              ),
                                            ),
                                            TableCell(
                                                child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 4.0,
                                                  horizontal: 2.0),
                                              child: Text(
                                                data.tglClosing!,
                                                style: TextStyle(
                                                    fontFamily: 'Poppins Med',
                                                    fontSize: 12),
                                              ),
                                            )),
                                            // TableCell(
                                            //   child: Row(
                                            //     children: [
                                            //       IconButton(
                                            //         icon: Icon(
                                            //             Icons.calendar_today,
                                            //             size: 20),
                                            //         onPressed: () {
                                            //           // Handle ETA calendar action
                                            //         },
                                            //       ),
                                            //       Expanded(
                                            //         child: Text(
                                            //             // 'ETD ${data.etaDate ?? 'N/A'}',
                                            //             'ETD ${data.etd}', // Use formattedTime here
                                            //             style: TextStyle(
                                            //                 fontWeight:
                                            //                     FontWeight.w900,
                                            //                 fontSize: 10)),
                                            //       ),
                                            //     ],
                                            //   ),
                                            // ),
                                          ]),
                                          //baris ke 3 rute tujuan
                                          TableRow(children: [
                                            TableCell(
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 4.0,
                                                    horizontal: 2.0),
                                                child: Text(
                                                  'Rute dan Tujuan',
                                                  style: TextStyle(
                                                      fontFamily: 'Poppins Med',
                                                      fontSize: 12),
                                                ),
                                              ),
                                            ),
                                            TableCell(
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 4.0,
                                                    horizontal: 2.0),
                                                child: Text(
                                                  ':',
                                                  style: TextStyle(
                                                      fontFamily: 'Poppins Med',
                                                      fontSize: 12),
                                                ),
                                              ),
                                            ),
                                            TableCell(
                                                child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 4.0,
                                                  horizontal: 2.0),
                                              child: Text(
                                                '${data.portAsal} - ${data.portTujuan}',
                                                style: TextStyle(
                                                    fontFamily: 'Poppins Med',
                                                    fontSize: 12),
                                              ),
                                            )),
                                            // TableCell(child: SizedBox()),
                                          ]),
                                          //baris ke 4 rute panjang
                                          TableRow(children: [
                                            TableCell(
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 4.0,
                                                    horizontal: 2.0),
                                                child: Text(
                                                  'Rute Panjang',
                                                  style: TextStyle(
                                                      fontFamily: 'Poppins Med',
                                                      fontSize: 12),
                                                ),
                                              ),
                                            ),
                                            TableCell(
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 4.0,
                                                    horizontal: 2.0),
                                                child: Text(
                                                  ':',
                                                  style: TextStyle(
                                                      fontFamily: 'Poppins Med',
                                                      fontSize: 12),
                                                ),
                                              ),
                                            ),
                                            TableCell(
                                                child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 4.0,
                                                  horizontal: 2.0),
                                              child: Text(
                                                data.rutePanjang!,
                                                textAlign: TextAlign.justify,
                                                style: TextStyle(
                                                    fontFamily: 'Poppins Med',
                                                    fontSize: 12),
                                              ),
                                            )),
                                            // TableCell(child: SizedBox()),
                                            // TableCell(
                                            //   child: Row(
                                            //     mainAxisAlignment:
                                            //         MainAxisAlignment.end,
                                            //     children: [
                                            //       // Image.asset(
                                            //       //   'assets/WA.png',
                                            //       // ),
                                            //       SizedBox(
                                            //         height: 50.0,
                                            //         child: Image.asset(
                                            //             'assets/WA.png'),
                                            //       ),
                                            //     ],
                                            //   ),
                                            // ),
                                          ])
                                        ],
                                      ),
                                      //ETA
                                      // Row(
                                      //   mainAxisAlignment:
                                      //       MainAxisAlignment.spaceBetween,
                                      //   children: [
                                      //     //ETA
                                      //     Expanded(
                                      //       child: Row(
                                      //         children: [
                                      //           IconButton(
                                      //             icon: Icon(
                                      //               Icons.calendar_today,
                                      //               size: 15,
                                      //             ),
                                      //             onPressed: () {},
                                      //           ),
                                      //           Text(
                                      //             // data.eta!,
                                      //             'ETA ${data.eta}',
                                      //             style: TextStyle(
                                      //                 fontWeight: FontWeight.w900,
                                      //                 fontSize: 14),
                                      //           ),
                                      //         ],
                                      //       ),
                                      //     ),
                                      //     //ETD
                                      //     Expanded(
                                      //       child: Row(
                                      //         children: [
                                      //           IconButton(
                                      //             icon: Icon(
                                      //               Icons.calendar_today,
                                      //               size: 15,
                                      //             ),
                                      //             onPressed: () {},
                                      //           ),
                                      //           Text(
                                      //             // data.etd!,
                                      //             'ETD ${data.etd}',
                                      //             style: TextStyle(
                                      //                 fontWeight: FontWeight.w900,
                                      //                 fontSize: 14),
                                      //           ),
                                      //         ],
                                      //       ),
                                      //     ),
                                      //   ],
                                      // ),
                                      Row(
                                        children: [
                                          IconButton(
                                            icon: Icon(
                                              Icons.calendar_today,
                                              size: 15,
                                            ),
                                            onPressed: () {},
                                          ),
                                          Text(
                                            // data.eta!,
                                            'ETA ${data.eta}',
                                            style: TextStyle(
                                                fontFamily: 'Poppins Med',
                                                fontSize: 12),
                                          ),
                                        ],
                                      ),
                                      // //ETD
                                      Row(
                                        children: [
                                          IconButton(
                                            icon: Icon(
                                              Icons.calendar_today,
                                              size: 15,
                                            ),
                                            onPressed: () {},
                                          ),
                                          Text(
                                            // data.etd!,
                                            'ETD ${data.etd}',
                                            style: TextStyle(
                                                fontFamily: 'Poppins Med',
                                                fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                          }),
                      if (kapalModellist.isNotEmpty &&
                          ((kapalModellist.length / itemsPerPage).ceil() > 1))
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            height: 40,
                            child: Row(
                              children: [
                                //search icon
                                IconButton(
                                  icon: Icon(Icons.search, color: Colors.black),
                                  iconSize: 20,
                                  onPressed: () {
                                    _pageController.text = '';
                                    searchPage();
                                  },
                                ),
                                // Double Arrow Back
                                SizedBox(
                                  height: 60,
                                  child: IconButton(
                                    icon: Icon(Icons.first_page,
                                        color: Colors.black),
                                    onPressed: () {
                                      setState(() {
                                        if (currentPageIndex != 0) {
                                          currentPageIndex = 0;
                                          _scrollController.animateTo(
                                            0.0,
                                            duration:
                                                Duration(milliseconds: 500),
                                            curve: Curves.easeInOut,
                                          );
                                        }
                                      });
                                    },
                                  ),
                                ),
                                //single arrow back
                                SizedBox(
                                  height: 60,
                                  child: IconButton(
                                    icon: Icon(Icons.arrow_back_ios),
                                    iconSize: 20,
                                    onPressed: currentPageIndex > 0
                                        ? () {
                                            setState(() {
                                              currentPageIndex--;
                                              _scrollController.animateTo(
                                                0.0,
                                                duration:
                                                    Duration(milliseconds: 500),
                                                curve: Curves.easeInOut,
                                              );
                                            });
                                          }
                                        : null,
                                  ),
                                ),
                                Expanded(
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount:
                                        (kapalModellist.length / itemsPerPage)
                                            .ceil(),
                                    itemBuilder: (context, pageIndex) {
                                      // Only show 5 pages at a time
                                      int startPage =
                                          (currentPageIndex ~/ 5) * 5;
                                      int endPage = startPage + 5;
                                      if (pageIndex < startPage ||
                                          pageIndex >= endPage) {
                                        return SizedBox.shrink();
                                      }
                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            currentPageIndex = pageIndex;
                                            _scrollController.animateTo(
                                              0.0,
                                              duration:
                                                  Duration(milliseconds: 500),
                                              curve: Curves.easeInOut,
                                            );
                                          });
                                        },
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 3),
                                          child: Container(
                                            width: 30,
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 4.0),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                              color: pageIndex ==
                                                      currentPageIndex
                                                  ? Colors.blue[
                                                      300] // Active page color
                                                  : Colors.grey[
                                                      300], // Inactive page color
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Color(0xFFB0BEC5),
                                                  offset: Offset(0, 2),
                                                  blurRadius: 5,
                                                  spreadRadius: 1,
                                                ),
                                              ],
                                            ),
                                            child: Center(
                                              child: Text(
                                                '${pageIndex + 1}',
                                                style: TextStyle(
                                                  color: pageIndex ==
                                                          currentPageIndex
                                                      ? Colors
                                                          .white // Active page text color
                                                      : Colors
                                                          .black, // Inactive page text color
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                //single arrow forward
                                SizedBox(
                                  height: 50,
                                  child: IconButton(
                                    icon: Icon(Icons.arrow_forward_ios),
                                    iconSize: 20,
                                    onPressed: currentPageIndex <
                                            (kapalModellist.length /
                                                        itemsPerPage)
                                                    .ceil() -
                                                1
                                        ? () {
                                            setState(() {
                                              currentPageIndex++;
                                              _scrollController.animateTo(
                                                0.0,
                                                duration:
                                                    Duration(milliseconds: 500),
                                                curve: Curves.easeInOut,
                                              );
                                            });
                                          }
                                        : null,
                                  ),
                                ),
                                // Double Arrow Forward
                                SizedBox(
                                  height: 50,
                                  child: IconButton(
                                    icon: Icon(Icons.last_page,
                                        color: Colors.black),
                                    onPressed: () {
                                      setState(() {
                                        int lastPageIndex =
                                            (kapalModellist.length /
                                                        itemsPerPage)
                                                    .ceil() -
                                                1;
                                        if (currentPageIndex != lastPageIndex) {
                                          currentPageIndex = lastPageIndex;
                                          _scrollController.animateTo(
                                            0.0,
                                            duration:
                                                Duration(milliseconds: 500),
                                            curve: Curves.easeInOut,
                                          );
                                        }
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      if (kapalModellist.isEmpty)
                        SizedBox(
                          child:
                              Image.asset('assets/pencarian daftar harga.png'),
                        ),
                      if (kapalModellist.isEmpty) SizedBox(height: 15),
                      if (kapalModellist.isEmpty)
                        Text(
                          'TIdak ada data yang dapat ditampilkan',
                          style: TextStyle(
                              fontWeight: FontWeight.w900, fontSize: 16),
                        ),
                      if (kapalModellist.isEmpty) SizedBox(height: 10),
                      if (kapalModellist.isEmpty)
                        Text(
                          'Hubungi admin untuk detail selengkapnya',
                          style: TextStyle(
                              fontWeight: FontWeight.w900, color: Colors.grey),
                        ),
                      SizedBox(height: 20),
                    ],
                  ),
                );
              },
            );
          },
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
    });
  }

  downloadGambar() {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center, // Align content to start
        children: [
          SizedBox(height: 10),
          Center(
            child: SizedBox(
              height: 40.0, // Adjust the height as needed
              child: Image.asset('assets/notif register.png'),
            ),
          ),
          SizedBox(height: 15),
          Center(
            child: Text(
              "Download Successful. The image has been saved to your gallery",
              style: TextStyle(
                  color: Colors.black, fontSize: 14, fontFamily: 'Poppinss'),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 10),
          Center(
            child: SizedBox(
              width: 150,
              height: 35,
              child: Material(
                borderRadius: BorderRadius.circular(7.0),
                color: Colors.red[900],
                // shadowColor: Colors.grey[350],
                // elevation: 5,
                child: MaterialButton(
                  padding: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
                  onPressed: () {
                    Navigator.of(context).pop();
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
          SizedBox(height: 5),
        ],
      ),
    );
  }
}
