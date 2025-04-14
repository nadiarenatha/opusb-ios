import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

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

Widget cekSimulasiHarga(
  BuildContext context,
  dynamic harga,
) {
  print('Harga simulasi: $harga'); // Print the harga value
  final TapGestureRecognizer _tapGestureRecognizer = TapGestureRecognizer();
  String formattedHarga;
  String? caption;
  String? url;

  // if (harga is int) {
  //   formattedHarga = getFormattedHarga(harga.toString());
  //   print('formattedHarga 1: $formattedHarga');
  // } else if (harga is String) {
  //   final parsedHarga = int.tryParse(harga); // Try parsing as int
  //   if (parsedHarga != null) {
  //     formattedHarga = getFormattedHarga(parsedHarga.toString());
  //     print('formattedHarga 2: $formattedHarga');
  //   } else {
  //     formattedHarga = 'Call Sales';
  //     print('formattedHarga 3: $formattedHarga');
  //   }
  // } else if (harga is Map<String, dynamic>) {
  //   caption = harga['caption'];
  //   url = harga['url'];
  //   print('Caption: $caption, URL: $url');

  //   formattedHarga = (caption ?? 'Call Sales') + (url != null ? ' ($url)' : '');
  //   print('formattedHarga 4: $formattedHarga');
  // } else {
  //   formattedHarga = 'Call Sales';
  //   print('formattedHarga 5: $formattedHarga');
  // }

  //New

  String fixJsonString(String input) {
    return input
        .replaceAll('{', '{"') // Add double quotes after opening brace
        .replaceAll(': ', '": "') // Add quotes around keys
        .replaceAll(', ', '", "') // Add quotes around values
        .replaceAll('}', '"}'); // Add closing quote before closing brace
  }

  if (harga is int) {
    formattedHarga = getFormattedHarga(harga.toString());
    print('formattedHarga 1: $formattedHarga');
  } else if (harga is String) {
    final parsedHarga = int.tryParse(harga); // Try parsing as int
    if (parsedHarga != null) {
      formattedHarga = getFormattedHarga(parsedHarga.toString());
      print('formattedHarga 2: $formattedHarga');
    } else {
      try {
        final String fixedHarga = fixJsonString(harga); // Fix JSON format
        final Map<String, dynamic> hargaMap = jsonDecode(fixedHarga);
        caption = hargaMap['caption'];
        url = hargaMap['url'];
        print('Caption: $caption, URL: $url');

        // formattedHarga =
        //     (caption ?? 'Call Sales') + (url != null ? ' $url' : '');
        formattedHarga = (caption ?? 'Call Sales');
        print('formattedHarga 4: $formattedHarga');
      } catch (e) {
        formattedHarga = 'Call Sales';
        print('formattedHarga 3: $formattedHarga (Failed to parse JSON: $e)');
      }
    }
  } else if (harga is Map<String, dynamic>) {
    caption = harga['caption'];
    url = harga['url'];
    print('Caption: $caption, URL: $url');

    formattedHarga = (caption ?? 'Call Sales') + (url != null ? ' ($url)' : '');
    print('formattedHarga 4: $formattedHarga');
  } else {
    formattedHarga = 'Call Sales';
    print('formattedHarga 5: $formattedHarga');
  }

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
        if (harga != null)
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
                  Flexible(
                    child: GestureDetector(
                      onTap: () async {
                        if (formattedHarga.contains('Call Sales')) {
                          const url = 'https://linktr.ee/niagalogistics';
                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            throw 'Could not launch $url';
                          }
                        }
                      },
                      child: Text(
                        formattedHarga,
                        style: TextStyle(
                            color: formattedHarga.contains('Call Sales')
                                ? Colors.blue
                                : Colors.orange[400],
                            fontSize: 14,
                            fontWeight: formattedHarga.contains('Call Sales')
                                ? FontWeight.w900
                                : FontWeight.normal,
                            fontFamily: 'Poppins Regular',
                            decoration: formattedHarga.contains('Call Sales')
                                ? TextDecoration.underline
                                : TextDecoration.none),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
              // if (url != null)
              //   GestureDetector(
              //     onTap: () async {
              //       if (await canLaunch(url.toString())) {
              //         await launch(url.toString());
              //       } else {
              //         throw 'Could not launch $url';
              //       }
              //     },
              //     child: Text(
              //       // 'Contact Sales',
              //       '',
              //       style: TextStyle(
              //         color: Colors.blue,
              //         decoration: TextDecoration.underline,
              //       ),
              //     ),
              //   ),
              SizedBox(height: 5),
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
