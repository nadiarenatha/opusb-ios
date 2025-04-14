import 'package:flutter/material.dart';

String? _selectedItem;

final List<String> dropdownItems = [
  'Via Bank ATM',
  'Via Mobile Banking',
  'Via Internet Banking',
];

Widget viaPembayaran(BuildContext context, String item) {
  if (item == 'Via Bank ATM') {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '1. Masukkan kartu ATM dan Pin BCA Anda',
          style: TextStyle(fontSize: 16.0),
        ),
        SizedBox(height: 10),
        Text(
          '2. Pilih menu traksaksi lainnya',
          style: TextStyle(fontSize: 16.0),
        ),
        SizedBox(height: 10),
        Text(
          '3. Pilih menu transfer',
          style: TextStyle(fontSize: 16.0),
        ),
        SizedBox(height: 10),
        Text(
          '4. Pilih menu ke Rek BCA Anda',
          style: TextStyle(fontSize: 16.0),
        ),
        SizedBox(height: 10),
        Text(
          '5. Masukkan kode bank + nomor pelanggan Anda',
          style: TextStyle(fontSize: 16.0),
        ),
        SizedBox(height: 10),
        Text(
          '6. 08458 = PT.Saranabhakti Timur, Contoh: 08258 xxxxxxx,',
          style: TextStyle(fontSize: 16.0),
        ),
        // SizedBox(height: 5),
        // Text(
        //   'Contoh: 08258 xxxxxxx,',
        //   style: TextStyle(fontSize: 16.0),
        // ),
        SizedBox(height: 10),
        Text(
          '7. Masukkan nominal tagihan',
          style: TextStyle(fontSize: 16.0),
        ),
        SizedBox(height: 10),
        Text(
          '8. Ikuti instruksi untuk menyelesaikan transaksi',
          style: TextStyle(fontSize: 16.0),
        ),
      ],
    );
  } else if (item == 'Via Mobile Banking') {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Add instructions for Mobile Banking
        Text(
          '1. Login ke akun m-BCA Anda',
          style: TextStyle(fontSize: 16.0),
        ),
        SizedBox(height: 10),
        Text(
          '2. Pilih menu m-Transfer',
          style: TextStyle(fontSize: 16.0),
        ),
        SizedBox(height: 10),
        Text(
          '3. Pilih BCA Virtual Account',
          style: TextStyle(fontSize: 16.0),
        ),
        SizedBox(height: 10),
        Text(
          '4. Masukkan Kode Bank + Nomor Pelanggan Anda',
          style: TextStyle(fontSize: 16.0),
        ),
        SizedBox(height: 10),
        Text(
          '5. 08458 = PT.Saranabhakti Timur, Contoh: 08258 xxxxxxx,',
          style: TextStyle(fontSize: 16.0),
        ),
        SizedBox(height: 10),
        Text(
          '6. Masukkan nominal tagihan',
          style: TextStyle(fontSize: 16.0),
        ),
        SizedBox(height: 10),
        Text(
          '7. Ikuti instruksi untuk menyelesaikan transaksi',
          style: TextStyle(fontSize: 16.0),
        ),
      ],
    );
  } else if (item == 'Via Internet Banking') {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '1. Login ke akun Klik BCA Anda',
          style: TextStyle(fontSize: 16.0),
        ),
        SizedBox(height: 10),
        Text(
          '2. Pilih menu Transfer Dana',
          style: TextStyle(fontSize: 16.0),
        ),
        SizedBox(height: 10),
        Text(
          '3. Pilih Transfer  ke BCA Virtual Account',
          style: TextStyle(fontSize: 16.0),
        ),
        SizedBox(height: 10),
        Text(
          '4. Masukkan Kode Bank + Nomor Pelanggan Anda',
          style: TextStyle(fontSize: 16.0),
        ),
        SizedBox(height: 10),
        Text(
          '5. 08458 = PT.Saranabhakti Timur, Contoh: 08258 xxxxxxx,',
          style: TextStyle(fontSize: 16.0),
        ),
        SizedBox(height: 10),
        Text(
          '6. Masukkan nominal tagihan',
          style: TextStyle(fontSize: 16.0),
        ),
        SizedBox(height: 10),
        Text(
          '7. Ikuti instruksi untuk menyelesaikan transaksi',
          style: TextStyle(fontSize: 16.0),
        ),
      ],
    );
  } else {
    return Container();
  }
}
