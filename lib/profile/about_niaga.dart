import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:niaga_apps_mobile/profile/profil_niaga.dart';
import '../Invoice/menu_invoice_niaga.dart';
import '../cubit/niaga/tentang_niaga_cubit.dart';
import '../model/niaga/tentang_niaga.dart';
import '../order/menu_order_niaga.dart';
import '../screen-niaga/home_niaga.dart';
import '../tracking/menu_tracking_niaga.dart';

class AboutNiagaPage extends StatefulWidget {
  const AboutNiagaPage({Key? key}) : super(key: key);

  @override
  State<AboutNiagaPage> createState() => _AboutNiagaPageState();
}

class _AboutNiagaPageState extends State<AboutNiagaPage> {
  @override

  //untuk BottomNavigationBarItem
  int _selectedIndex = 0;
  List<TentangNiagaAccesses> tentangNiagaList = [];

  //untuk BottomNavigationBarItem
  static List<Widget> _widgetOptions = <Widget>[
    MenuOrderNiagaPage(),
    MenuTrackingNiagaPage(resiNumber: ''),
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

  @override
  void initState() {
    super.initState();
    BlocProvider.of<TentangNiagaCubit>(context).tentangNiaga(true);
  }

  Widget build(BuildContext context) {
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
                  "Tentang Niaga Logistics",
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
      body: BlocConsumer<TentangNiagaCubit, TentangNiagaState>(
          listener: (context, state) {
        if (state is TentangNiagaSuccess) {
          tentangNiagaList.clear();
          tentangNiagaList = state.response;
          tentangNiagaList.sort((a, b) => a.id!.compareTo(b.id!));
        }
      }, builder: (context, state) {
        if (state is TentangNiagaInProgress) {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.amber[600],
            ),
          );
        }
        return SingleChildScrollView(
          child: Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(20.0),
                itemCount: tentangNiagaList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tentangNiagaList[index].name.toString(),
                          style: TextStyle(
                              fontSize: 16, fontFamily: 'Poppins Bold'),
                        ),
                        SizedBox(height: 5),
                        Text(
                          tentangNiagaList[index].description.toString(),
                          style: TextStyle(
                              fontSize: 12, fontFamily: 'Poppins Regular'),
                          textAlign: TextAlign.justify,
                        ),
                      ],
                    ),
                  );
                },
              ),
              SizedBox(height: 60),
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
                        "Kembali",
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
      }),
    );
  }
}
