import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:niaga_apps_mobile/login/login_body.dart';

import '../cubit/niaga/syarat_create_user_cubit.dart';
import '../model/niaga/syarat_create_user.dart';

class SyaratKetentuanPage extends StatefulWidget {
  const SyaratKetentuanPage({Key? key}) : super(key: key);

  @override
  State<SyaratKetentuanPage> createState() => _SyaratKetentuanPageState();
}

class _SyaratKetentuanPageState extends State<SyaratKetentuanPage> {
  bool isAgreed = false; // State to track checkbox
  List<SyaratCreateUserAccesses> syaratCreateUserList = [];

  @override
  void initState() {
    super.initState();
    BlocProvider.of<SyaratCreateUserCubit>(context).syaratCreateUser(true);
  }

  Future notifCreateAccount() => showDialog(
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
                  content: notifikasi()),
            ),
          ));

  @override
  Widget build(BuildContext context) {
    //final size agar gambar background sesuai dgn masing2 layar hp
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
        //agar saat input data keyboard
        resizeToAvoidBottomInset: true,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(
            0.07 * MediaQuery.of(context).size.height,
          ),
          child: AppBar(
            backgroundColor: Colors.red[900],
            title: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  height: 40.0, // Adjust the height as needed
                  child: Image.asset('assets/logo-niaga.png'),
                ),
              ],
            ),
            toolbarHeight: 0.07 * MediaQuery.of(context).size.height,
            leading: Container(),
          ),
        ),
        body: BlocConsumer<SyaratCreateUserCubit, SyaratCreateUserState>(
            listener: (context, state) {
          if (state is SyaratCreateUserSuccess) {
            syaratCreateUserList.clear();
            syaratCreateUserList = state.response;
          }
        }, builder: (context, state) {
          if (state is SyaratCreateUserInProgress) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.amber[600],
              ),
            );
          }
          return Center(
            child: SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: syaratCreateUserList.length,
                        itemBuilder: (context, index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                syaratCreateUserList[index].name.toString(),
                                style: TextStyle(
                                    fontFamily: 'Poppins Bold', fontSize: 16),
                              ),
                              SizedBox(height: 10),
                              Text(
                                syaratCreateUserList[index]
                                    .description
                                    .toString(),
                                style: TextStyle(
                                    fontFamily: 'Poppins Med', fontSize: 14),
                                textAlign: TextAlign.justify,
                              ),
                              SizedBox(height: 10),
                            ],
                          );
                        },
                      ),
                      SizedBox(height: 10),
                      // Centered Checkbox and Text
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Checkbox(
                              value: isAgreed,
                              onChanged: (bool? newValue) {
                                setState(() {
                                  isAgreed = newValue ?? false;
                                });
                              },
                            ),
                            Text(
                              'Saya Menyetujui Ketentuan ini',
                              style: TextStyle(
                                  fontFamily: 'Poppins Med', fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 90),
                      Center(
                        child: SizedBox(
                          height: 50,
                          width: 180,
                          child: Material(
                            borderRadius: BorderRadius.circular(7.0),
                            color: Colors.orange[600],
                            child: MaterialButton(
                              minWidth: MediaQuery.of(context).size.width,
                              padding:
                                  EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                              onPressed: () {
                                if (!isAgreed) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'Please agree to the terms to proceed.'),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                } else {
                                  notifCreateAccount();
                                }
                              },
                              child: Text(
                                "Buat Akun Saya",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    letterSpacing: 1.5,
                                    fontSize: 13,
                                    color: Colors.white,
                                    fontFamily: 'Poppinss'),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }));
  }

  Widget notifikasi() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Center(
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.center, // Align content to start
          children: [
            SizedBox(height: 13),
            SizedBox(
              height: 40.0, // Adjust the height as needed
              child: Image.asset('assets/notif register.png'),
            ),
            SizedBox(height: 10),
            Text(
              'Data Tersimpan!',
              style: TextStyle(fontSize: 20, fontFamily: 'Poppinss'),
            ),
            SizedBox(height: 20),
            //StatefulBuilder agar tampilan shoe dialog berubah
            // Text(
            //   'Silahkan cek Inbox/Spam Email anda untuk melakukan verfikasi data',
            //   style: TextStyle(
            //       fontSize: 14,
            //       color: Colors.grey[600],
            //       fontFamily: 'Poppins Regular'),
            //   textAlign: TextAlign.center,
            // ),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600], // Default text color
                  fontFamily: 'Poppins Regular',
                ),
                children: [
                  TextSpan(text: 'Silahkan cek '),
                  TextSpan(
                    text: 'Inbox/Spam',
                    style: TextStyle(
                      color: Colors.red, // Set red color for Inbox/Spam
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(text: ' Email anda untuk melakukan verifikasi data'),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Hanya akun yang terverifikasi yang bisa Login',
              style: TextStyle(fontSize: 14, fontFamily: 'Poppins Regular'),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            SizedBox(
              width: 75,
              height: 45,
              child: Material(
                borderRadius: BorderRadius.circular(7.0),
                color: Colors.red[900],
                child: MaterialButton(
                  minWidth: MediaQuery.of(context).size.width,
                  // padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) {
                      return LoginBody();
                    }));
                  },
                  child: Text(
                    "Ok",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        // letterSpacing: 1.5,
                        fontSize: 13,
                        color: Colors.white,
                        fontFamily: 'Poppins Med'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
