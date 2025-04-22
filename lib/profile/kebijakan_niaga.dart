import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:niaga_apps_mobile/cubit/niaga/kebijakan_privasi_cubit.dart';
import 'package:niaga_apps_mobile/profile/profil_niaga.dart';
import '../Invoice/menu_invoice_niaga.dart';
import '../model/niaga/kebijakan.dart';
import '../order/menu_order_niaga.dart';
import '../screen-niaga/home_niaga.dart';
import '../tracking/menu_tracking_niaga.dart';

class KebijakanNiagaPage extends StatefulWidget {
  const KebijakanNiagaPage({Key? key}) : super(key: key);

  @override
  State<KebijakanNiagaPage> createState() => _KebijakanNiagaPageState();
}

class _KebijakanNiagaPageState extends State<KebijakanNiagaPage> {
  @override

  //untuk BottomNavigationBarItem
  int _selectedIndex = 0;
  List<KebijakanAccesses> KebijakanList = [];

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
    BlocProvider.of<KebijakanPrivasiCubit>(context).kebijakanPrivasi(true);
  }

  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          0.07 * MediaQuery.of(context).size.height,
        ),
        child: AppBar(
          backgroundColor: Colors.white,
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
                  "Kebijakan Privasi",
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
      body: BlocConsumer<KebijakanPrivasiCubit, KebijakanPrivasiState>(
          listener: (context, state) {
        if (state is KebijakanPrivasiSuccess) {
          KebijakanList.clear();
          KebijakanList = state.response;
          KebijakanList.sort((a, b) => a.id!.compareTo(b.id!));
        }
      }, builder: (context, state) {
        if (state is KebijakanPrivasiInProgress) {
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
                itemCount: KebijakanList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          KebijakanList[index].name.toString(),
                          style: TextStyle(
                              fontSize: 16, fontFamily: 'Poppins Bold'),
                        ),
                        SizedBox(height: 5),
                        Text(
                          KebijakanList[index].description.toString(),
                          style: TextStyle(
                              fontSize: 12, fontFamily: 'Poppins Regular'),
                          textAlign: TextAlign.justify,
                        ),
                      ],
                    ),
                  );
                },
              ),
              SizedBox(height: 120),
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
              SizedBox(height: 20),
            ],
          ),
        );
      }),
    );
  }
}
