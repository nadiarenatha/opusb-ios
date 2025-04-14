import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../Invoice/menu_invoice_niaga.dart';
import '../cubit/niaga/warehouse_niaga_cubit.dart';
import '../model/niaga/warehouse_niaga.dart';
import '../order/menu_order_niaga.dart';
import '../profile/profil_niaga.dart';
import '../screen-niaga/home_niaga.dart';
import '../shared/constants.dart';
import '../shared/functions/flutter_secure_storage.dart';
import '../tracking/menu_tracking_niaga.dart';
import 'detail_stok_barang_niaga.dart';
import 'dart:math';
import 'package:flutter/services.dart';

class StokBarangNiagaPage extends StatefulWidget {
  const StokBarangNiagaPage({Key? key}) : super(key: key);

  @override
  State<StokBarangNiagaPage> createState() => _StokBarangNiagaPageState();
}

class _StokBarangNiagaPageState extends State<StokBarangNiagaPage>
    with SingleTickerProviderStateMixin {
  @override
  //untuk BottomNavigationBarItem
  int _selectedIndex = 0;
  //untuk BottomNavigationBarItem
  bool isSelected = false;
  //untuk pagination
  late ScrollController _scrollController;
  int currentPageIndex = 0;
  int itemsPerPage = 5; // Number of items per page
  int _totalPages = 0; // Store total pages from API
  int _currentPage = 1; // Track the current page
  int totalPages = 0; // Declare totalPages as a class-level variable
  int pageIndex = 1;
  int visiblePages = 5; // Number of visible page numbers

  bool noResults = false;

  List<WarehouseNiagaAccesses> warehouseModellist = [];
  List<WarehouseNiagaAccesses> filteredList = [];

  //untuk calendar pada pop up dialog search dengan nama _dateController
  //2 nama berbeda karena tgl di calendar berbeda
  TextEditingController _dateController1 = TextEditingController();
  TextEditingController _dateController2 = TextEditingController();
  TextEditingController _namaPenerimaController = TextEditingController();
  TextEditingController _tujuanController = TextEditingController();
  TextEditingController _pageController = TextEditingController();

  bool _isSearchButtonClicked = false;

  String _customerDistribusi = '';
  String _tujuan = '';

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
    _scrollController = ScrollController();
    // BlocProvider.of<WarehouseNiagaCubit>(context).warehouseNiaga();
    BlocProvider.of<WarehouseNiagaCubit>(context).searchWarehouseNiaga();

    _dateController1.addListener(() {
      String text = _dateController1.text;
      // Remove any non-digit characters
      text = text.replaceAll(RegExp(r'[^0-9]'), '');
      // Automatically format the input as dd/mm/yyyy
      if (text.length >= 2 && text.length <= 4) {
        text = text.substring(0, 2) +
            (text.length >= 3 ? '/' + text.substring(2) : '');
      } else if (text.length > 4) {
        text = text.substring(0, 2) +
            '/' +
            text.substring(2, 4) +
            '/' +
            text.substring(4, min(8, text.length)); // Use min here
      }

      // Update the controller text with formatted date
      _dateController1.value = _dateController1.value.copyWith(
        text: text,
        selection: TextSelection.collapsed(offset: text.length),
      );
    });

    //2
    _dateController2.addListener(() {
      // if (_isProgrammaticChange) return;

      String text = _dateController2.text;
      // Remove any non-digit characters
      text = text.replaceAll(RegExp(r'[^0-9]'), '');

      // Automatically format the input as dd/mm/yyyy
      if (text.length >= 2 && text.length <= 4) {
        text = text.substring(0, 2) +
            (text.length >= 3 ? '/' + text.substring(2) : '');
      } else if (text.length > 4) {
        text = text.substring(0, 2) +
            '/' +
            text.substring(2, 4) +
            '/' +
            text.substring(4, min(8, text.length)); // Use min here
      }

      // Update the controller text with formatted date
      _dateController2.value = _dateController2.value.copyWith(
        text: text,
        selection: TextSelection.collapsed(offset: text.length),
      );
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _dateController1.dispose();
    _dateController2.dispose();
    super.dispose();
  }

  int getStartPageIndex() {
    return ((currentPageIndex ~/ visiblePages) * visiblePages).toInt();
  }

  int getEndPageIndex() {
    int endPage = (getStartPageIndex() + visiblePages).toInt();
    return endPage > _totalPages ? _totalPages : endPage;
  }

  void _fetchDataForPage(int pageIndex) {
    print('Customer Distribusi: $_customerDistribusi');
    print('Tujuan: $_tujuan');

    // Assuming you are using a Bloc to fetch warehouse data
    BlocProvider.of<WarehouseNiagaCubit>(context).searchWarehouseNiaga(
      pageIndex: pageIndex,
      customerDistribusi: _customerDistribusi,
      tujuan: _tujuan,
      tglAwal: _dateController1.text.isEmpty ? null : _dateController1.text,
      tglAkhir: _dateController2.text.isEmpty ? null : _dateController2.text,
    );
  }

  void _onItemTapped(int index) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => _widgetOptions[index]),
    );
  }

  //untuk fungsi calendar pada pop up dialog search dengan nama _dateController
  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Current date
      firstDate: DateTime(2000), // The earliest date the user can pick
      lastDate: DateTime(2101), // The latest date the user can pick
    );
    if (picked != null) {
      setState(() {
        // Add leading zero to day and month if necessary
        String day = picked.day < 10 ? '0${picked.day}' : '${picked.day}';
        String month =
            picked.month < 10 ? '0${picked.month}' : '${picked.month}';
        String formattedDate = "$day/$month/${picked.year}";

        controller.text = formattedDate;

        // controller.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  Future downloadSuccess() => showDialog(
      context: context,
      //alert diberi SingleChildScrollView agar bisa di scroll
      builder: (BuildContext context) => Center(
            child: SingleChildScrollView(
              child: AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  titlePadding: EdgeInsets.zero,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 25, vertical: 3),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [],
                  ),
                  content: downloadfile()),
            ),
          ));

  downloadfile() {
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
              "Download Successful. The file has been saved to your device",
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
                    child: Text(_totalPages.toString(),
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
                        if (pageNumber > 0 && pageNumber <= _totalPages) {
                          setState(() {
                            currentPageIndex = pageNumber - 1;
                            _fetchDataForPage(pageNumber);
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

  //untuk fungsi pop up dialog search
  Future searchWarehouse() => showDialog(
      context: context,
      builder: (context) => SingleChildScrollView(
            child: AlertDialog(
              //untuk memberi border melengkung
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              //untuk mengatur letak dari close icon
              titlePadding: EdgeInsets.zero,
              contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 3),
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
              content: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 900, maxWidth: 300),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Nama Penerima",
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Poppin',
                          fontSize: 14),
                    ),
                    SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                          color: Colors.black, // Set border color
                          width: 1.0, // Set border width
                        ),
                      ),
                      child: TextFormField(
                        controller: _namaPenerimaController,
                        decoration: InputDecoration(
                          hintText: 'Masukkan nama penerima',
                          hintStyle: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 10.0),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Tujuan",
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Poppin',
                          fontSize: 14),
                    ),
                    SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                          color: Colors.black, // Set border color
                          width: 1.0, // Set border width
                        ),
                      ),
                      child: TextFormField(
                        controller: _tujuanController,
                        decoration: InputDecoration(
                          hintText: 'Masukkan tujuan',
                          hintStyle: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 10.0),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Tanggal Masuk",
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Poppin',
                          fontSize: 14),
                    ),
                    SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                          color: Colors.black, // Set border color
                          width: 1.0, // Set border width
                        ),
                      ),
                      child: TextFormField(
                        //controller 1 digunakan untuk input tgl di calendar
                        controller: _dateController1,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            hintText: 'dd/mm/yyyy',
                            hintStyle: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                            //untuk mengatur letak hint text
                            //horizontal ke kanan kiri
                            //vertical ke atas  bawah
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 15.0),
                            border: InputBorder.none,
                            //untuk tambah icon calendar
                            suffixIcon: IconButton(
                              icon: Icon(Icons.calendar_today, size: 20),
                              onPressed: () =>
                                  _selectDate(context, _dateController1),
                            )),
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                          color: Colors.black, // Set border color
                          width: 1.0, // Set border width
                        ),
                      ),
                      child: TextFormField(
                        //controller 2 digunakan untuk input tgl di calendar
                        controller: _dateController2,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            hintText: 'dd/mm/yyyy',
                            hintStyle: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                            //untuk mengatur letak hint text
                            //horizontal ke kanan kiri
                            //vertical ke atas  bawah
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 15.0),
                            border: InputBorder.none,
                            //untuk tambah icon calendar
                            suffixIcon: IconButton(
                              icon: Icon(Icons.calendar_today, size: 20),
                              onPressed: () =>
                                  _selectDate(context, _dateController2),
                            )),
                      ),
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: Material(
                        borderRadius: BorderRadius.circular(7.0),
                        color: Colors.red[900],
                        child: MaterialButton(
                          onPressed: () {
                            // Navigator.of(context).pop();
                            setState(() {
                              _isSearchButtonClicked =
                                  true; // Set to true when button is clicked
                              noResults = false;
                              currentPageIndex =
                                  0; // Reset to the first page agar klik search kembali ke halaman awal
                            });
                            performSearch();
                            if (_dateController1.text.isEmpty &&
                                _dateController2.text.isEmpty &&
                                _namaPenerimaController.text.isEmpty &&
                                _tujuanController.text.isEmpty) {
                              context
                                  .read<WarehouseNiagaCubit>()
                                  .searchWarehouseNiaga();
                            }
                          },
                          child: Text(
                            'Terapkan',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ));

  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

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
                  "Barang dalam Gudang",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.red[900],
                      fontFamily: 'Poppins Extra Bold'),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                // width: 30,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Color.fromARGB(255, 184, 33, 22), // Red border color
                    width: 2.0, // Border width
                  ),
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: Color(0xFFB0BEC5), // A color close to grey[350]
                  //     offset: Offset(0, 2),
                  //     blurRadius: 5,
                  //     spreadRadius: 1,
                  //   )
                  // ],
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                  iconSize: 24,
                  onPressed: () {
                    _namaPenerimaController.text = '';
                    _tujuanController.text = '';
                    _dateController1.text = '';
                    _dateController2.text = '';
                    searchWarehouse();
                  },
                ),
              ),
            ],
          ),
          //agar tulisan di appbar berada di tengah tinggi bar
          toolbarHeight: 0.07 * MediaQuery.of(context).size.height,
        ),
      ),
      //untuk setting form
      body: BlocConsumer<WarehouseNiagaCubit, WarehouseNiagaState>(
        listener: (context, state) async {
          print('noResults nya : $noResults');
          // if (state is WarehouseNiagaSuccess) {
          //   // warehouseModellist.clear();
          //   _totalPages = state.totalPages;
          //   print("Total Pages Warehouse: $_totalPages");
          //   warehouseModellist = state.response;
          //   // filteredList.clear();
          //   // filteredList = state.response;
          //   print("Ini Data Warehouse Model List: $warehouseModellist");

          //   if (warehouseModellist.isNotEmpty) {
          //     // Assuming totalPage is included in each WarehouseNiagaAccesses
          //     _totalPages = warehouseModellist[0].totalPage ?? 0;
          //   }
          // }
          if (state is SearchWarehouseNiagaSuccess) {
            warehouseModellist.clear();
            warehouseModellist = state.response;
            // noResults = warehouseModellist.isEmpty;
            // filteredList.clear();
            // filteredList = state.response;
            print("Ini Data Search Warehouse Model List: $warehouseModellist");

            // Recalculate total pages based on the filtered list
            if (warehouseModellist.isNotEmpty) {
              // _totalPages = (filteredList.length / itemsPerPage).ceil();
              // currentPageIndex =
              //     0; // Reset to the first page of filtered results
              _totalPages = warehouseModellist[0].totalPage ?? 0;
              print('Ini Total Page nya $_totalPages');
            } else {
              _totalPages = 0;
              noResults = true; // No results
            }
          }
          if (state is SearchWarehouseNiagaFailure) {
            print('noResults fail nya : $noResults');
            warehouseModellist.clear();
            noResults = true;
            _totalPages = 0;
          }
          if (state is LogNiagaSuccess) {
            noResults = false;
          }
          if (state is DownloadWarehouseSuccess) {
            await downloadSuccess();
          }
        },
        builder: (context, state) {
          if (state is WarehouseNiagaInProgress ||
              state is SearchWarehouseNiagaInProgress ||
              state is DownloadWarehouseInProgress ||
              state is LogWarehouseNiagaInProgress) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.amber[600],
              ),
            );
          }

          // final List<WarehouseNiagaAccesses> listToDisplay =
          //     filteredList.isNotEmpty ? filteredList : warehouseModellist;

          return SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 10),
                // if (filteredList.isNotEmpty)
                if (warehouseModellist.isNotEmpty &&
                    warehouseModellist.any((item) => item.data.isNotEmpty))
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // Padding(
                      //   padding: const EdgeInsets.only(left: 18),
                      //   child: Material(
                      //     borderRadius: BorderRadius.circular(7.0),
                      //     color: Colors.red[900],
                      //     //membuat bayangan pada button Detail
                      //     shadowColor: Colors.grey[350],
                      //     elevation: 5,
                      //     child: MaterialButton(
                      //       minWidth: 150, // Adjust the width as needed
                      //       height: 40, // Adjust the height as needed
                      //       onPressed: () async {
                      //         String? ownerCode = await storage.read(
                      //           key: AuthKey.ownerCode.toString(),
                      //           aOptions: const AndroidOptions(
                      //               encryptedSharedPreferences: true),
                      //         );
                      //         if (ownerCode != null) {
                      //           // Pass the ownerCode to the downloadwarehouse method
                      //           BlocProvider.of<WarehouseNiagaCubit>(context)
                      //               .downloadwarehouse(ownerCode);
                      //         }
                      //       },
                      //       child: Text(
                      //         'Download',
                      //         style: TextStyle(
                      //             fontSize: 16, color: Colors.white),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      Padding(
                        padding: const EdgeInsets.only(left: 18),
                        child: SizedBox(
                          width: 130,
                          height: 40,
                          child: Material(
                            borderRadius: BorderRadius.circular(7.0),
                            color: Colors.red[900],
                            // shadowColor: Colors.grey[350],
                            // elevation: 5,
                            child: MaterialButton(
                              padding: EdgeInsets.symmetric(
                                  vertical: 8,
                                  horizontal: 10), // Adjust padding for size
                              onPressed: () async {
                                String? ownerCode = await storage.read(
                                  key: AuthKey.ownerCode.toString(),
                                  aOptions: const AndroidOptions(
                                      encryptedSharedPreferences: true),
                                );
                                if (ownerCode != null) {
                                  // Pass the ownerCode to the downloadwarehouse method
                                  BlocProvider.of<WarehouseNiagaCubit>(context)
                                      .downloadwarehouse(ownerCode);
                                }
                              },
                              child: Text(
                                'Download',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontFamily: 'Poppins Med'),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                // _totalPages == 0
                // _isSearchButtonClicked
                if (_isSearchButtonClicked == true &&
                    warehouseModellist.isEmpty)
                  // if (_isSearchButtonClicked)
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 20),
                        SizedBox(
                          child:
                              Image.asset('assets/pencarian daftar harga.png'),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Data tidak ditemukan',
                          style: TextStyle(
                              fontWeight: FontWeight.w900, fontSize: 16),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Ubah parameter pencarian untuk mencari data yang ditampilkan',
                          style: TextStyle(
                              fontWeight: FontWeight.w900, color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                else if (_isSearchButtonClicked == true ||
                    warehouseModellist.isNotEmpty)
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: warehouseModellist.length,
                    //LAMA
                    // itemCount: filteredList.length,
                    // itemCount: listToDisplay.length,
                    controller: ScrollController(),
                    itemBuilder: (context, index) {
                      // Each element in warehouseModellist is of type WarehouseNiagaAccesses
                      var warehouseAccess = warehouseModellist[index];
                      //LAMA
                      // var warehouseAccess = filteredList[index];
                      //BARU
                      // var warehouseAccess = listToDisplay[index];
                      print('data total_page $_totalPages');

                      // Now, iterate over the 'data' list inside each WarehouseNiagaAccesses
                      return Column(
                        children: List.generate(warehouseAccess.data.length,
                            (itemIndex) {
                          var data = warehouseAccess
                              .data[itemIndex]; // WarehouseItemAccesses

                          return InkWell(
                            onTap: () {
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: (context) {
                                return DetailStokBarangNiagaPage(stok: data);
                              }));
                            },
                            child: Container(
                              // margin: EdgeInsets.all(18),
                              margin:
                                  EdgeInsets.only(left: 18, top: 18, right: 18),
                              decoration: BoxDecoration(
                                // color: Colors.grey[200],
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Color.fromARGB(255, 196, 193, 193),
                                  width: 1.0,
                                ),
                                // boxShadow: [
                                //   BoxShadow(
                                //     color: Color(0xFFB0BEC5),
                                //     offset: Offset(0, 6),
                                //     blurRadius: 10,
                                //     spreadRadius: 1,
                                //   ),
                                // ],
                              ),
                              child: Padding(
                                // padding: EdgeInsets.all(10.0),
                                padding: EdgeInsets.only(left: 11, top: 5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(data.customerDistribusi ?? '',
                                        style: TextStyle(
                                            color: Colors.red[900],
                                            fontSize: 16,
                                            fontFamily: 'Poppinss')),
                                    SizedBox(height: 10),
                                    Table(
                                      columnWidths: {
                                        0: FlexColumnWidth(3),
                                        1: FlexColumnWidth(1),
                                        2: FlexColumnWidth(5),
                                      },
                                      children: [
                                        TableRow(children: [
                                          TableCell(
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 8.0,
                                                  horizontal: 2.0),
                                              child: Text(
                                                'Kota Tujuan',
                                                style: TextStyle(
                                                    fontFamily:
                                                        'Poppins Regular',
                                                    fontSize: 12),
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 8.0,
                                                  horizontal: 2.0),
                                              child: Text(
                                                ':',
                                                style: TextStyle(
                                                    fontFamily:
                                                        'Poppins Regular',
                                                    fontSize: 12),
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 8.0,
                                                  horizontal: 2.0),
                                              child: Text(
                                                data.tujuan ?? '',
                                                style: TextStyle(
                                                    fontFamily:
                                                        'Poppins Regular',
                                                    fontSize: 12),
                                              ),
                                            ),
                                          ),
                                        ]),
                                        TableRow(children: [
                                          TableCell(
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 8.0,
                                                  horizontal: 2.0),
                                              child: Text(
                                                'Tanggal Masuk',
                                                style: TextStyle(
                                                    fontFamily:
                                                        'Poppins Regular',
                                                    fontSize: 12),
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 8.0,
                                                  horizontal: 2.0),
                                              child: Text(
                                                ':',
                                                style: TextStyle(
                                                    fontFamily:
                                                        'Poppins Regular',
                                                    fontSize: 12),
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 8.0,
                                                  horizontal: 2.0),
                                              child: Text(
                                                data.tanggalMasuk ?? '',
                                                style: TextStyle(
                                                    fontFamily:
                                                        'Poppins Regular',
                                                    fontSize: 12),
                                              ),
                                            ),
                                          ),
                                        ]),
                                        TableRow(children: [
                                          TableCell(
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 8.0,
                                                  horizontal: 2.0),
                                              child: Text(
                                                'Total Volume',
                                                style: TextStyle(
                                                    fontFamily:
                                                        'Poppins Regular',
                                                    fontSize: 12),
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 8.0,
                                                  horizontal: 2.0),
                                              child: Text(
                                                ':',
                                                style: TextStyle(
                                                    fontFamily:
                                                        'Poppins Regular',
                                                    fontSize: 12),
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 8.0,
                                                  horizontal: 2.0),
                                              child: Text(
                                                '${data.totalVolume ?? 0} M3',
                                                style: TextStyle(
                                                    fontFamily:
                                                        'Poppins Regular',
                                                    fontSize: 12),
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
                          );
                        }),
                      );
                    },
                  ),
                SizedBox(height: 20),
                //mengatur pagination
                // if (_totalPages > 1 &&
                //     _isSearchButtonClicked == true &&
                //     warehouseModellist.isNotEmpty)
                if (_totalPages > 1)
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      color: Colors.white,
                      height: 50,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
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
                                icon:
                                    Icon(Icons.first_page, color: Colors.black),
                                onPressed: () {
                                  setState(() {
                                    if (currentPageIndex != 0) {
                                      currentPageIndex = 0;
                                      _fetchDataForPage(1); // First page
                                      _scrollController.animateTo(
                                        0.0,
                                        duration: Duration(milliseconds: 500),
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
                                onPressed: () {
                                  setState(() {
                                    if (currentPageIndex > 0) {
                                      currentPageIndex--;
                                      _fetchDataForPage(currentPageIndex + 1);
                                      _scrollController.animateTo(
                                        0.0,
                                        duration: Duration(milliseconds: 500),
                                        curve: Curves.easeInOut,
                                      );
                                    }
                                  });
                                },
                              ),
                            ),
                            Expanded(
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                controller:
                                    _scrollController, // Attach the ScrollController here
                                itemCount:
                                    getEndPageIndex() - getStartPageIndex(),
                                itemBuilder: (context, pageIndex) {
                                  int actualPageIndex =
                                      getStartPageIndex() + pageIndex;
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        currentPageIndex = actualPageIndex;
                                        _fetchDataForPage(currentPageIndex + 1);
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 3),
                                      child: Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 4.0),
                                        width:
                                            30, // Width of each page indicator
                                        decoration: BoxDecoration(
                                          color: actualPageIndex ==
                                                  currentPageIndex
                                              ? Colors.blue[
                                                  300] // Active page color
                                              : Colors.grey[300],
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        child: Center(
                                          child: Text(
                                            '${actualPageIndex + 1}', // Display page number
                                            style: TextStyle(
                                              // color: Colors.white,
                                              color: actualPageIndex ==
                                                      currentPageIndex
                                                  ? Colors
                                                      .white // Active page text color
                                                  : Colors.black,
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
                                onPressed: () {
                                  setState(() {
                                    if (currentPageIndex < _totalPages - 1) {
                                      currentPageIndex++;
                                      _fetchDataForPage(currentPageIndex + 1);
                                      _scrollController.animateTo(
                                        0.0,
                                        duration: Duration(milliseconds: 500),
                                        curve: Curves.easeInOut,
                                      );
                                    }
                                  });
                                },
                              ),
                            ),
                            // Double Arrow Forward
                            SizedBox(
                              height: 50,
                              child: IconButton(
                                icon:
                                    Icon(Icons.last_page, color: Colors.black),
                                onPressed: () {
                                  setState(() {
                                    if (currentPageIndex != _totalPages - 1) {
                                      currentPageIndex = _totalPages - 1;
                                      _fetchDataForPage(
                                          _totalPages); // Last page
                                      _scrollController.animateTo(
                                        0.0,
                                        duration: Duration(milliseconds: 500),
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
                  ),
                // if (filteredList.isEmpty)
                // if (warehouseModellist.isEmpty)
                if (warehouseModellist.isEmpty &&
                    _isSearchButtonClicked == false)
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 20),
                        SizedBox(
                          child:
                              Image.asset('assets/pencarian daftar harga.png'),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'TIdak ada data yang dapat ditampilkan',
                          style: TextStyle(
                              fontWeight: FontWeight.w900, fontSize: 16),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Hubungi admin untuk detail selengkapnya',
                          style: TextStyle(
                              fontWeight: FontWeight.w900, color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                //   SizedBox(
                //     child: Image.asset('assets/pencarian daftar harga.png'),
                //   ),
                // if (warehouseModellist.isEmpty && _isSearchButtonClicked == false)
                //   SizedBox(height: 15),
                // if (warehouseModellist.isEmpty && _isSearchButtonClicked == false)
                //   Text(
                //     'TIdak ada data yang dapat ditampilkan',
                //     style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                //   ),
                // if (warehouseModellist.isEmpty && _isSearchButtonClicked == false)
                //   SizedBox(height: 10),
                // if (warehouseModellist.isEmpty && _isSearchButtonClicked == false)
                //   Text(
                //     'Hubungi admin untuk detail selengkapnya',
                //     style: TextStyle(
                //         fontWeight: FontWeight.w900, color: Colors.grey),
                //   ),
                // SizedBox(height: 10)
              ],
            ),
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
  }

  void performSearch() {
    //   setState(() {
    //   _isSearchButtonClicked = true;
    //   noResults = false; // Reset noResults for each search
    // });

    String searchTextPenerima =
        _namaPenerimaController.text.trim().toUpperCase();
    String searchTextTujuan = _tujuanController.text.trim().toUpperCase();
    String searchTextTanggal = _dateController1.text
        .trim(); // Assuming the date is formatted in dd/mm/yyyy
    String searchTextTanggal2 = _dateController2.text
        .trim(); // Assuming the date is formatted in dd/mm/yyyy

    // Debugging: Log the input values
    // print('Nama Penerima adalah: $searchTextPenerima');
    // print('Tujuan adalah: $searchTextTujuan');
    // print('Tanggal Masuk adalah: $searchTextTanggal');

    // if (searchTextTanggal.isEmpty &&
    //     searchTextPenerima.isEmpty &&
    //     searchTextTujuan.isEmpty) {
    //   searchTextPenerima = '';
    //   searchTextTujuan = '';
    //   searchTextTanggal = '';
    // }
    if (searchTextTanggal.isNotEmpty && searchTextTanggal2.isEmpty) {
      _dateController2.text = searchTextTanggal;
      searchTextTanggal2 = searchTextTanggal;
    } else if (searchTextTanggal2.isNotEmpty && searchTextTanggal.isEmpty) {
      _dateController1.text = searchTextTanggal2;
      searchTextTanggal = searchTextTanggal2;
    }

    print('Nama Penerima adalah: $searchTextPenerima');
    print('Tujuan adalah: $searchTextTujuan');
    print('Tanggal Masuk adalah: $searchTextTanggal');

    if (searchTextTanggal.isEmpty &&
        searchTextTanggal2.isEmpty &&
        searchTextPenerima.isEmpty &&
        searchTextTujuan.isEmpty) {
      // filteredList = warehouseModellist;
      warehouseModellist.clear();
      // Close the dialog if no search terms are provided
      Navigator.of(context).pop();
      return;
    }

    final RegExp dateRegex = RegExp(r"^\d{2}/\d{2}/\d{4}$");
    if (searchTextTanggal.isNotEmpty &&
        !dateRegex.hasMatch(searchTextTanggal)) {
      print('Invalid date format');
      return; // You may also want to display an error message to the user.
    }

    setState(() {
      _customerDistribusi = searchTextPenerima;
      _tujuan = searchTextTujuan;
    });

    BlocProvider.of<WarehouseNiagaCubit>(context).searchWarehouseNiaga(
      pageIndex: pageIndex,
      customerDistribusi: searchTextPenerima,
      tujuan: searchTextTujuan,
      // tglAwal: searchTextTanggal,
      tglAwal: _dateController1.text.isEmpty ? null : _dateController1.text,
      tglAkhir: _dateController2.text.isEmpty ? null : _dateController2.text,
    );

    // filteredList = warehouseModellist.where((item) {
    warehouseModellist.where((item) {
      // Since item is of type WarehouseNiagaAccesses, you need to check its 'data'
      bool matchesSearch = true;

      if (searchTextTanggal.isNotEmpty) {
        matchesSearch = item.data.any((warehouseItem) {
          // Check if tanggalMasuk contains the search text
          return warehouseItem.tanggalMasuk != null &&
              warehouseItem.tanggalMasuk!
                  .toLowerCase()
                  .contains(searchTextTanggal.toLowerCase());
        });
      }
      if (searchTextTanggal2.isNotEmpty) {
        matchesSearch = item.data.any((warehouseItem) {
          // Check if tanggalMasuk contains the search text
          return warehouseItem.tanggalMasuk != null &&
              warehouseItem.tanggalMasuk!
                  .toLowerCase()
                  .contains(searchTextTanggal2.toLowerCase());
        });
      }
      if (searchTextPenerima.isNotEmpty) {
        matchesSearch = item.data.any((warehouseItem) {
          // Check if tanggalMasuk contains the search text
          return warehouseItem.customerDistribusi != null &&
              warehouseItem.customerDistribusi!
                  .toLowerCase()
                  .contains(searchTextPenerima.toUpperCase());
        });
      }
      if (searchTextTujuan.isNotEmpty) {
        matchesSearch = item.data.any((warehouseItem) {
          // Check if tanggalMasuk contains the search text
          return warehouseItem.tujuan != null &&
              warehouseItem.tujuan!
                  .toUpperCase()
                  .contains(searchTextTujuan.toUpperCase());
        });
      }

      return matchesSearch;
    }).toList();

    noResults = warehouseModellist.isEmpty;
    // setState(() {
    //   noResults = warehouseModellist.isEmpty;
    // });

    // Close the dialog
    Navigator.of(context).pop();
  }
}
