import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

String getFormattedHarga(String? harga) {
  if (harga == null || harga.isEmpty) {
    return 'Rp 0.00'; // Default if harga is null or empty
  }
  final double? hargaValue = double.tryParse(harga);
  if (hargaValue == null) {
    return 'Invalid Harga'; // Handle invalid input
  }

  final NumberFormat currencyFormat = NumberFormat.currency(
    locale: 'ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );
  return currencyFormat.format(hargaValue) + ',-';
}

// Widget cekHarga(BuildContext context, String harga, String hargaOrMessage) {
Widget cekHarga(
  BuildContext context,
  String? harga,
  String? errorMessage,
) {
  final TapGestureRecognizer _tapGestureRecognizer = TapGestureRecognizer();
  final String formattedHarga = getFormattedHarga(harga);

  // Check if the `harga` value is null or contains the sales link message.
  // final isSalesMessage = harga.contains('Call sales');
  // final bool isFailureMessage = hargaOrMessage.contains('Call sales');
  // String? errorMessage;

  return Padding(
    padding: const EdgeInsets.all(26.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Harga dapat berubah sewaktu-waktu silahkan hubungi sales kami secepatnya untuk melakukan konfirmasi harga.',
          style: TextStyle(
              color: Colors.grey[600],
              fontFamily: 'Poppins Regular',
              fontSize: 11),
          textAlign: TextAlign.justify,
        ),
        SizedBox(height: 10),
        Text(
          'Skema pengiriman adalah service DOOR TO DOOR, dengan asumsi lokasi pengiriman dan penerima dalam kota.',
          style: TextStyle(
              color: Colors.grey[600],
              fontFamily: 'Poppins Regular',
              fontSize: 11),
          textAlign: TextAlign.justify,
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: TextStyle(color: Colors.grey[600]),
                  children: [
                    TextSpan(
                        text: 'Saya telah setuju dengan ',
                        style: TextStyle(
                            fontFamily: 'Poppins Regular', fontSize: 11)),
                    TextSpan(
                      text: 'Term and Condition ',
                      style: TextStyle(
                        color: Colors.red[900],
                        fontFamily: 'Poppins Bold',
                        fontSize: 11,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: _tapGestureRecognizer
                        ..onTap = () async {
                          const url =
                              'https://niaga-logistics.com/news/term-condition-pengiriman/';
                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            throw 'Could not launch $url';
                          }
                        },
                    ),
                    TextSpan(
                        text: ' dari Niaga Logistics',
                        style: TextStyle(
                            fontFamily: 'Poppins Regular', fontSize: 11)),
                  ],
                ),
                textAlign: TextAlign.justify,
              ),
            ),
          ],
        ),
        SizedBox(height: 15),
        Container(
          height: 2,
          color: Colors.grey[300],
        ),
        SizedBox(height: 20),
        if (harga != null && errorMessage == null)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Estimasi Harga',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontFamily: 'Poppins Regular'),
                  ),
                  Text(
                    formattedHarga,
                    style: TextStyle(
                        color: Colors.orange[400],
                        fontSize: 16,
                        fontFamily: 'Poppins Regular'),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Text(
                'Harga berikut merupakan harga Free on Truck (FOT). Tidak termasuk biaya jasa bongkar/muat',
                style: TextStyle(
                    color: Colors.red[900],
                    fontSize: 11,
                    fontFamily: 'Poppins Regular'),
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        if (errorMessage != null)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () async {
                      const url = 'https://linktr.ee/niagalogistics';
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        // Handle error
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   SnackBar(content: Text('Could not launch WhatsApp')),
                        // );
                      }
                    },
                    child: Text(
                      '$errorMessage',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 14,
                        fontFamily: 'Poppins Regular',
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.red[900],
                        decorationStyle: TextDecorationStyle.solid,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Text(
                'Harga berikut merupakan harga Free on Truck (FOT). Tidak termasuk biaya jasa bongkar/muat',
                style: TextStyle(
                    color: Colors.red[900],
                    fontSize: 11,
                    fontFamily: 'Poppins Regular'),
                textAlign: TextAlign.justify,
              ),
            ],
          ),
      ],
    ),
  );
}
