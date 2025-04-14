import 'package:flutter/material.dart';
import 'package:niaga_apps_mobile/pemesanan/via_pembayaran.dart';
import 'package:flutter/services.dart'; // Required for Clipboard

class PembayaranTransferBank extends StatefulWidget {
  const PembayaranTransferBank({super.key});

  @override
  State<PembayaranTransferBank> createState() => _PembayaranTransferBankState();
}

class _PembayaranTransferBankState extends State<PembayaranTransferBank> {
  String? _selectedPaymentMethod;
  String? _selectedItem;

  final List<String> dropdownItems = [
    'Via Bank ATM',
    'Via Mobile Banking',
    'Via Internet Banking',
  ];

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    // final List<String> dropdownItems;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          0.12 * MediaQuery.of(context).size.height,
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
          flexibleSpace: Container(
            alignment: Alignment.bottomLeft,
            padding: EdgeInsets.only(left: 45, bottom: 20),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Pemesanan",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.red[900],
                            fontFamily: 'Poppin',
                            fontWeight: FontWeight.w900),
                      ),
                      SizedBox(height: 15),
                      Row(
                        children: [
                          _buildStepItem('1', 'Kontrak Perjanjian', 1),
                          _buildSeparator(),
                          _buildStepItem(
                              '2', 'Detail Barang & Layanan Pengiriman', 2),
                          _buildSeparator(),
                          _buildStepItem('3', 'Jadwal Stuffing', 3),
                          _buildSeparator(),
                          _buildStepItem('4', 'Konfirmasi Detail Barang', 4),
                          _buildSeparator(),
                          _buildStepItem('5', 'Pembayaran', 5),
                          _buildSeparator(),
                          _buildStepItem('6', 'Stuffing Barang', 6),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  //metode pembayaran
                  Text(
                    'Pembayaran',
                    style: TextStyle(
                        color: Colors.red[900],
                        fontSize: 18,
                        fontWeight: FontWeight.w900),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Text(
                    'Transfer ke',
                    style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 15,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Text(
                    'a.n Niaga Logistics',
                    style: TextStyle(
                        color: Colors.red[900],
                        fontSize: 15,
                        fontWeight: FontWeight.w900),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  //no transfer
                  Container(
                    width: 340,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey
                              .withOpacity(0.5), // Color of the shadow
                          spreadRadius: 2, // Spread radius
                          blurRadius: 5, // Blur radius
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    // padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Table(
                              columnWidths: {
                                0: FlexColumnWidth(5),
                                // 1: FlexColumnWidth(5),
                                1: FlexColumnWidth(2),
                              },
                              children: [
                                TableRow(children: [
                                  TableCell(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 8.0, horizontal: 2.0),
                                      child: Text(
                                        '102938412',
                                        style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.w900),
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 8.0, horizontal: 2.0),
                                        child: GestureDetector(
                                          onTap: () {
                                            _copyToClipboardTransfer(
                                                '102938412', context);
                                          },
                                          child: Icon(
                                            Icons.copy,
                                            size: 24.0,
                                            color: Colors.red[900],
                                          ),
                                        )),
                                  )
                                ]),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  //jumlah transfer
                  Container(
                    width: 340,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey
                              .withOpacity(0.5), // Color of the shadow
                          spreadRadius: 2, // Spread radius
                          blurRadius: 5, // Blur radius
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    // padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Table(
                              columnWidths: {
                                0: FlexColumnWidth(5),
                                // 1: FlexColumnWidth(5),
                                1: FlexColumnWidth(2),
                              },
                              children: [
                                TableRow(children: [
                                  TableCell(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 8.0, horizontal: 2.0),
                                      child: Text(
                                        'Rp 14.000.000',
                                        style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.w900),
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 8.0, horizontal: 2.0),
                                        child: GestureDetector(
                                          onTap: () {
                                            _copyToClipboardBalance(
                                                'Rp 14.000.000', context);
                                          },
                                          child: Icon(
                                            Icons.copy,
                                            size: 24.0,
                                            color: Colors.red[900],
                                          ),
                                        )),
                                  )
                                ]),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 55,
                  ),
                  Container(
                    height: 2,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.grey[400],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  //tata cara pembayaran
                  Text(
                    'Tata Cara Pembayaran',
                    style: TextStyle(
                        color: Colors.red[900],
                        fontSize: 20,
                        fontWeight: FontWeight.w900),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  DropdownButton<String>(
                    hint: Text('Cara Pembayaran'),
                    value: _selectedItem,
                    onChanged: (String? value) {
                      setState(() {
                        _selectedItem = value;
                      });
                    },
                    items: dropdownItems.map((String item) {
                      return DropdownMenuItem<String>(
                        value: item,
                        child: Text(item),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 20.0),
                  if (_selectedItem != null)
                    Container(
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$_selectedItem:',
                              style: TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10.0),
                            viaPembayaran(context, _selectedItem!),
                            // if (_selectedItem == 'Via Bank ATM')
                            //   // viaPembayaran(context, _selectedItem!),
                            //   Column(
                            //     crossAxisAlignment: CrossAxisAlignment.start,
                            //     children: [
                            //       Text(
                            //         '1. Masukkan kartu ATM dan Pin BCA Anda',
                            //         style: TextStyle(fontSize: 16.0),
                            //       ),
                            //       SizedBox(height: 10),
                            //       Text(
                            //         '2. Pilih menu traksaksi lainnya',
                            //         style: TextStyle(fontSize: 16.0),
                            //       ),
                            //       SizedBox(height: 10),
                            //       Text(
                            //         '3. Pilih menu transfer',
                            //         style: TextStyle(fontSize: 16.0),
                            //       ),
                            //       SizedBox(height: 10),
                            //       Text(
                            //         '4. Pilih menu ke Rek BCA Anda',
                            //         style: TextStyle(fontSize: 16.0),
                            //       ),
                            //       SizedBox(height: 10),
                            //       Text(
                            //         '5. Masukkan kode bank + nomor pelanggan Anda',
                            //         style: TextStyle(fontSize: 16.0),
                            //       ),
                            //       SizedBox(height: 10),
                            //       Text(
                            //         '6. 08458 = PT.Saranabhakti Timur,',
                            //         style: TextStyle(fontSize: 16.0),
                            //       ),
                            //       SizedBox(height: 5),
                            //       Text(
                            //         'Contoh: 08258 xxxxxxx,',
                            //         style: TextStyle(fontSize: 16.0),
                            //       ),
                            //       SizedBox(height: 10),
                            //       Text(
                            //         '7. Masukkan nominal tagihan',
                            //         style: TextStyle(fontSize: 16.0),
                            //       ),
                            //       SizedBox(height: 10),
                            //       Text(
                            //         '8. Ikuti instruksi untuk menyelesaikan transaksi',
                            //         style: TextStyle(fontSize: 16.0),
                            //       ),
                            //     ],
                            //   ),
                          ]),
                    ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Column(
                children: [
                  Material(
                    borderRadius: BorderRadius.circular(7.0),
                    color: Colors.red[900],
                    //membuat bayangan pada button Detail
                    shadowColor: Colors.grey[350],
                    elevation: 5,
                    child: MaterialButton(
                      minWidth: 220, // Adjust the width as needed
                      height: 60, // Adjust the height as needed
                      onPressed: () {},
                      child: Text(
                        'Cek Pembayaran',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Material(
                    borderRadius: BorderRadius.circular(7.0),
                    color: Colors.white,
                    //membuat bayangan pada button Detail
                    shadowColor: Colors.grey[350],
                    elevation: 5,
                    child: MaterialButton(
                      minWidth: 220, // Adjust the width as needed
                      height: 60, // Adjust the height as needed
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Kembali',
                        style: TextStyle(fontSize: 16, color: Colors.red[900]),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }
}

//copy no rekening
void _copyToClipboardTransfer(String text, BuildContext context) {
  Clipboard.setData(ClipboardData(text: text));
  final snackBar = SnackBar(
    content: Text('Copied to Clipboard'),
    duration: Duration(seconds: 2),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

//copy nominal transfer
void _copyToClipboardBalance(String text, BuildContext context) {
  Clipboard.setData(ClipboardData(text: text));
  final snackBar = SnackBar(
    content: Text('Copied to Clipboard'),
    duration: Duration(seconds: 2),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

int _currentStep = 1;
Widget _buildStepItem(String number, String title, int stepNumber) {
  // bool isSelected = _currentStep == stepNumber;
  Color itemColor =
      // isSelected
      stepNumber == 5
          ? (Colors.red[900] ?? Colors.red)
          : (Colors.grey[400] ?? Colors.grey);
  Color textColor =
      // isSelected
      stepNumber == 5 ? Colors.white : Colors.black;

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0),
    child: Row(
      children: [
        Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(
                    color: itemColor,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                Text(
                  number,
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.w800,
                    fontSize: 20,
                  ),
                )
              ],
            ),
          ],
        ),
        SizedBox(width: 5),
        Text(
          title,
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
  );
}

Widget _buildSeparator() {
  return Container(
    width: 45,
    height: 3,
    color: Colors.grey[400],
    margin: EdgeInsets.symmetric(horizontal: 8),
  );
}
