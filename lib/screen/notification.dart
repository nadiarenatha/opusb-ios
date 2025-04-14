import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

// class NotificationModel {
//   bool isSelected = false;

//   NotificationModel(this.isSelected);
// }

class _NotificationPageState extends State<NotificationPage> {
  // For managing the selected notification type
  String selectedNotification = '';

  bool showAllNotifications = false;

  // List<Widget> allNotificationWidgets = [];
  // bool isSelected = false;

// Combine all types of notifications into a single list
  final List<Map<String, dynamic>> allNotifications = [
    // Departure notifications
    {
      'id': 1,
      'text': 'Transaksi Berhasil',
      'icon': Icons.payment,
      'keterangan': 'Transaksi',
      'keterangan2': 'berhasil dibayar melalui QRIS',
      'tanggal': '21/06/2024',
      'value': false,
    },
    // ETA Change notifications
    {
      'id': 2,
      'text': 'Invoice',
      'icon': Icons.note,
      'keterangan': 'Transaksi',
      'keterangan2': 'berhasil dibayar melalui QRIS',
      'tgl': '22/06/2024',
      'value': false,
    },
    // Pre Arrival notifications
    {
      'id': 3,
      'text': 'Transaksi Berhasil',
      'icon': Icons.payment,
      'keterangan': 'Transaksi',
      'keterangan2': 'berhasil dibayar melalui QRIS',
      'tanggal': '23/06/2024',
      'value': false,
    },
    // Booking Status notifications
    {
      'id': 4,
      'text': 'Invoice',
      'icon': Icons.note,
      'keterangan': 'Transaksi',
      'keterangan2': 'berhasil dibayar melalui QRIS',
      'tgl': '24/06/2024',
      'value': false,
    },
  ];

  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

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
          flexibleSpace: Container(
            alignment: Alignment.bottomLeft,
            padding: EdgeInsets.only(left: 45, bottom: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Notifikasi Saya",
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.red[900],
                      fontFamily: 'Poppin',
                      fontWeight: FontWeight.w900),
                ),
                Positioned(
                  bottom: 16,
                  left: 16,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color:
                                Color(0xFFB0BEC5), // A color close to grey[350]
                            offset: Offset(0, 2),
                            blurRadius: 5,
                            spreadRadius: 1,
                          )
                        ]),
                    child: IconButton(
                        icon: Icon(
                          Icons.settings,
                          color: Colors.black,
                        ),
                        onPressed: () {}),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              children: [
                //untuk membuat tombol tab
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            //ALL
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedNotification = 'allNotifications';
                                  showAllNotifications = !showAllNotifications;
                                });
                              },
                              child: Container(
                                //container tab yg dipilih
                                width: 125,
                                height: 40,
                                decoration: BoxDecoration(
                                    color: selectedNotification ==
                                            'allNotifications'
                                        ? Colors.blue
                                        : Colors.grey[350],
                                    borderRadius: BorderRadius.circular(25)),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.all_inbox),
                                      SizedBox(width: 5),
                                      Text(
                                        'All',
                                        style: TextStyle(
                                          color: selectedNotification ==
                                                  'allNotifications'
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            // Transaksi
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedNotification = 'Transaksi Berhasil';
                                });
                              },
                              child: Container(
                                //container tab yg dipilih
                                width: 125,
                                height: 40,
                                decoration: BoxDecoration(
                                    color: selectedNotification ==
                                            'Transaksi Berhasil'
                                        ? Colors.blue
                                        : Colors.grey[350],
                                    borderRadius: BorderRadius.circular(25)),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.payment),
                                      SizedBox(width: 5),
                                      Text(
                                        'Transaksi',
                                        style: TextStyle(
                                          color: selectedNotification ==
                                                  'Transaksi Berhasil'
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            // Invoice
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  // selectedNotification = 'Invoice';
                                  selectedNotification = 'Invoice';
                                  showAllNotifications = false;
                                });
                              },
                              child: Container(
                                //container tab yg dipilih
                                width: 125,
                                height: 40,
                                decoration: BoxDecoration(
                                    color: selectedNotification == 'Invoice'
                                        ? Colors.blue
                                        : Colors.grey[350],
                                    borderRadius: BorderRadius.circular(25)),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.note),
                                      SizedBox(width: 5),
                                      Text(
                                        'Invoice',
                                        style: TextStyle(
                                          color:
                                              selectedNotification == 'Invoice'
                                                  ? Colors.white
                                                  : Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                if (selectedNotification.isNotEmpty)
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 14.0, top: 10.0),
                      child: GestureDetector(
                        onTap: () {
                          selectedNotification = '';
                          showAllNotifications = false;
                        },
                        child: Text(
                          'Mark all as read',
                          style: TextStyle(
                              color: Colors.blue[900],
                              fontWeight: FontWeight.w900),
                        ),
                      ),
                    ),
                  ),
                // Display selected notification details
                //looping
                ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: allNotifications.length,
                    itemBuilder: (context, index) {
                      var item = allNotifications[index];
                      if (selectedNotification == 'allNotifications' ||
                          selectedNotification == item['text']) {
                        //jika container di klik dr false akan berubah menjadi true
                        return InkWell(
                          // highlightColor: Colors.blue[900],
                          onTap: () {
                            setState(() {
                              item['value'] = !item['value'];
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.all(6),
                            width: mediaQuery.size.width * 0.9,
                            decoration: BoxDecoration(
                              color: item['value'] == false
                                  ? Colors.grey[200]
                                  : Colors.blue,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(
                                      0xFFB0BEC5), // A color close to grey[350]
                                  offset: Offset(0, 6),
                                  blurRadius: 10,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                children: [
                                  Icon(item['icon']),
                                  SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item['text'],
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: item['value'] == false
                                              ? Colors.black
                                              : Colors.white,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      if (item.containsKey('keterangan'))
                                        Row(
                                          children: [
                                            Text(
                                              item['keterangan'],
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: item['value'] == false
                                                    ? Colors.black
                                                    : Colors.white,
                                              ),
                                            ),
                                            SizedBox(width: 5),
                                            //Transaksi
                                            if (selectedNotification ==
                                                    'allNotifications' ||
                                                item['text'] ==
                                                    'Transaksi Berhasil')
                                              if (item.containsKey('tanggal'))
                                                Text(
                                                  item['tanggal'],
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color:
                                                        item['value'] == false
                                                            ? Colors.black
                                                            : Colors.white,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                            //UNTUK Invoice
                                            if (selectedNotification ==
                                                    'allNotifications' ||
                                                item['text'] == 'Invoice')
                                              if (item.containsKey('tgl'))
                                                Text(
                                                  item['tgl'],
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color:
                                                        item['value'] == false
                                                            ? Colors.black
                                                            : Colors.white,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                          ],
                                        ),
                                      if (item.containsKey('keterangan2'))
                                        Text(
                                          item['keterangan2'],
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: item['value'] == false
                                                ? Colors.black
                                                : Colors.white,
                                          ),
                                        ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                      return SizedBox.shrink();
                    })
                // Display selected notification details
                //untuk isi tab yg dipilih
              ],
            ),
          ],
        ),
      ),
    );
  }
}
