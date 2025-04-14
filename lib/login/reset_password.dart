// import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:niaga_apps_mobile/login/login_body.dart';

import '../cubit/niaga/password_cubit.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({Key? key}) : super(key: key);

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _emailController = TextEditingController();

  //untuk fungsi masking password
  bool _passwordVisible = true;
  bool _passwordConfirmVisible = true;
  bool savePassword = false;

  //untuk fungsi masking password
  void _togglevisibility() {
    setState(() {
      _passwordVisible = !_passwordVisible;
    });
  }

  //untuk visibility confirm password
  void _togglevisibilityConfirm() {
    setState(() {
      _passwordConfirmVisible = !_passwordConfirmVisible;
    });
  }

  Future alertEmail() => showDialog(
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
                    ],
                  ),
                  content: alert()),
            ),
          ));

  Future notifResetPassword() => showDialog(
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
                    ],
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
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 32,
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginBody()),
                );
              },
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "Reset Password",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontFamily: 'Poppins Extra Bold'),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(
                  height: 40.0, // Adjust the height as needed
                  child: Image.asset('assets/logo-niaga.png'),
                ),
              ],
            ),
            toolbarHeight: 0.07 * MediaQuery.of(context).size.height,
          ),
        ),
        body: BlocConsumer<PasswordCubit, PasswordState>(
            listener: (context, state) async {
          if (state is ForgotPasswordSuccess) {
            notifResetPassword();
          }
        }, builder: (context, state) {
          if (state is ForgotPasswordInProgress) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.amber[600],
              ),
            );
          }
          return Container(
            height: screenSize.height,
            width: screenSize.width,
            // decoration: BoxDecoration(
            //     image: DecorationImage(
            //         image: AssetImage('assets/background-login.jpeg'),
            //         fit: BoxFit.cover)),
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 200),
              child: Column(
                children: [
                  SizedBox(height: 20.0),
                  Text(
                    'Reset Your Password',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontFamily: 'Poppins Extra Bold'),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 40.0),
                      Text(
                        'Email Address',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontFamily: 'Poppins Bold'),
                      ),
                      SizedBox(height: 10.0),
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
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _emailController,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "johndoe@example.com",
                                    hintStyle: TextStyle(
                                      fontSize: 11,
                                      fontFamily: 'Poppins Regular',
                                      color: Colors.grey,
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 14.0),
                                    fillColor: Colors.grey[600],
                                    labelStyle:
                                        TextStyle(fontFamily: 'Montserrat')),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14.0,
                                    fontFamily: 'Montserrat'),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.0),
                      // Text(
                      //   'Password',
                      //   style: TextStyle(color: Colors.white, fontSize: 18),
                      // ),
                      // SizedBox(height: 10.0),
                      // Container(
                      //   height: 40,
                      //   decoration: BoxDecoration(
                      //     color: Colors.white,
                      //     borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      //     border: Border.all(
                      //       color: Colors.black, // Set border color here
                      //       width: 1.0, // Set border width here
                      //     ),
                      //   ),
                      //   child: Row(
                      //     children: [
                      //       Expanded(
                      //         child: TextFormField(
                      //           focusNode: _passwordFocus,
                      //           textInputAction: TextInputAction.done,
                      //           //untuk membuat masking password
                      //           obscureText: _passwordVisible,
                      //           controller: _passwordController,
                      //           decoration: InputDecoration(
                      //             border: InputBorder.none,
                      //             hintText: "********",
                      //             contentPadding: EdgeInsets.symmetric(
                      //                 horizontal: 10.0, vertical: 12.0),
                      //             fillColor: Colors.grey[600],
                      //             labelStyle: TextStyle(fontFamily: 'Montserrat'),
                      //             suffixIcon: GestureDetector(
                      //               onTap: () {
                      //                 _togglevisibility();
                      //               },
                      //               child: Icon(
                      //                 _passwordVisible
                      //                     ? Icons.visibility
                      //                     : Icons.visibility_off,
                      //                 // color: Theme.of(context).primaryColor,
                      //               ),
                      //             ),
                      //           ),
                      //           style: TextStyle(
                      //               color: Colors.grey[600],
                      //               fontSize: 14.0,
                      //               fontFamily: 'Montserrat'),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      // SizedBox(height: 20.0),
                      // Text(
                      //   'Confirm Password',
                      //   style: TextStyle(color: Colors.white, fontSize: 18),
                      // ),
                      // SizedBox(height: 10.0),
                      // Container(
                      //   height: 40,
                      //   decoration: BoxDecoration(
                      //     color: Colors.white,
                      //     borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      //     border: Border.all(
                      //       color: Colors.black, // Set border color here
                      //       width: 1.0, // Set border width here
                      //     ),
                      //   ),
                      //   child: Row(
                      //     children: [
                      //       Expanded(
                      //         child: TextFormField(
                      //           focusNode: _passwordConfirmFocus,
                      //           textInputAction: TextInputAction.done,
                      //           //untuk membuat masking password
                      //           obscureText: _passwordConfirmVisible,
                      //           controller: _passwordConfirmController,
                      //           decoration: InputDecoration(
                      //             border: InputBorder.none,
                      //             hintText: "********",
                      //             contentPadding: EdgeInsets.symmetric(
                      //                 horizontal: 10.0, vertical: 12.0),
                      //             fillColor: Colors.grey[600],
                      //             labelStyle: TextStyle(fontFamily: 'Montserrat'),
                      //             suffixIcon: GestureDetector(
                      //               onTap: () {
                      //                 _togglevisibilityConfirm();
                      //               },
                      //               child: Icon(
                      //                 _passwordConfirmVisible
                      //                     ? Icons.visibility
                      //                     : Icons.visibility_off,
                      //                 // color: Theme.of(context).primaryColor,
                      //               ),
                      //             ),
                      //           ),
                      //           style: TextStyle(
                      //               color: Colors.grey[600],
                      //               fontSize: 14.0,
                      //               fontFamily: 'Montserrat'),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      SizedBox(height: 45.0),
                      Center(
                        child: SizedBox(
                          width: 400,
                          height: 45,
                          child: Material(
                            borderRadius: BorderRadius.circular(7.0),
                            color: Colors.red[900],
                            child: MaterialButton(
                              minWidth: MediaQuery.of(context).size.width,
                              onPressed: () {
                                if (_emailController.text.isEmpty) {
                                  alertEmail();
                                } else {
                                  final email = _emailController.text;
                                  print('email nya: $email');
                                  context.read<PasswordCubit>().forgotPassword(email);
                                }
                              },
                              child: Text(
                                "Reset Password",
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
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
        }));
  }

  Widget notifikasi() {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(height: 5),
            SizedBox(
              height: 40.0, // Adjust the height as needed
              child: Image.asset('assets/notif register.png'),
            ),
            SizedBox(height: 10),
            Text(
              'Silakan Cek Email Anda!',
              style: TextStyle(fontSize: 20, fontFamily: 'Poppinss'),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 25),
            //StatefulBuilder agar tampilan shoe dialog berubah
            Center(
              child: Text(
                'Silahkan cek email anda untuk melakukan proses reset password',
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontFamily: 'Poppins Regular'),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: 70,
              height: 45,
              child: Material(
                borderRadius: BorderRadius.circular(7.0),
                color: Colors.red[900],
                child: MaterialButton(
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
                        letterSpacing: 1.5,
                        fontSize: 13,
                        color: Colors.white,
                        fontFamily: 'Poppins Med'),
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  alert() {
    return Padding(
      // padding: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.only(left: 8, right: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Align content to start
        children: [
          SizedBox(height: 15),
          Center(
            child: SizedBox(
              height: 40.0, // Adjust the height as needed
              child: Image.asset('assets/Cancel.png'),
            ),
          ),
          SizedBox(height: 10),
          Center(
            child: Text(
              "Anda belum mengisi Email !",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontFamily: 'Poppins Bold'),
            ),
          ),
          SizedBox(height: 15),
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
