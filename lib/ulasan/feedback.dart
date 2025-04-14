import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';

Widget feedback(BuildContext context) {
  final TapGestureRecognizer _tapGestureRecognizer = TapGestureRecognizer();

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Masukkan dan Saran',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
      ),
      SizedBox(height: 20),
      Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white, // Background color of the outer container
          border: Border.all(
            color: Colors.grey, // Grey border color
            width: 2.0, // Border width
          ),
          boxShadow: [
            BoxShadow(
              // Grey shadow color with opacity
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2, // How far the shadow spreads
              blurRadius: 5, // How much the shadow is blurred
              offset: Offset(0, 3), // Position of the shadow
            ),
          ],
          borderRadius: BorderRadius.circular(8), // Optional: Add border radius
        ),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                // controller: _alamatBongkarController,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Berikan masukan dan saran anda disini...",
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 14.0),
                    fillColor: Colors.grey[600],
                    labelStyle: TextStyle(fontFamily: 'Montserrat')),
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.0,
                    fontFamily: 'Montserrat'),
                maxLines: null,
              ),
            ),
          ],
        ),
      ),
      SizedBox(height: 40),
      // Center(
      //   child: Column(
      //     children: [
      //       Material(
      //         borderRadius: BorderRadius.circular(7.0),
      //         color: Colors.white,
      //         shadowColor: Colors.grey[350],
      //         elevation: 5,
      //         child: OutlinedButton(
      //           style: OutlinedButton.styleFrom(
      //             minimumSize: Size(200, 50),
      //             side: BorderSide(color: Colors.red[900]!, width: 2),
      //             shape: RoundedRectangleBorder(
      //               borderRadius: BorderRadius.circular(7.0),
      //             ),
      //             backgroundColor: Colors.white,
      //           ),
      //           onPressed: () {
      //             Navigator.of(context).pop();
      //           },
      //           child: Text(
      //             'Batal',
      //             style: TextStyle(fontSize: 18, color: Colors.red[900]),
      //           ),
      //         ),
      //       ),
      //       SizedBox(height: 10),
      //       Material(
      //         borderRadius: BorderRadius.circular(7.0),
      //         color: Colors.red[900],
      //         //membuat bayangan pada button Detail
      //         shadowColor: Colors.grey[350],
      //         elevation: 5,
      //         child: MaterialButton(
      //           minWidth: 200, // Adjust the width as needed
      //           height: 50, // Adjust the height as needed
      //           onPressed: () {
      //             Navigator.of(context).pop();
      //           },
      //           child: Text(
      //             'Kirim',
      //             style: TextStyle(fontSize: 18, color: Colors.white),
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    ],
  );
}
