import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:stock_counting_app/screen/bu_screen.dart';

import 'package:stock_counting_app/utility/alert.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qrscan/qrscan.dart' as scanner;

class CountScan extends StatefulWidget {
  const CountScan({super.key, required this.token, required this.userName});
  final String? token;
  final String? userName;
  @override
  State<CountScan> createState() => _CountScanState();
}

class _CountScanState extends State<CountScan> {
  TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false; //ป้องการกดปุ่มยอนกลับบน mobile
      },
      child: Scaffold(
        appBar: AppBar(
            elevation: 0,
            title: Text(
              "Stock Counting",
              style: GoogleFonts.prompt(fontSize: 25, color: Colors.white),
            ),
            automaticallyImplyLeading: false,
            leading: PopupMenuButton(
                elevation: 0,
                color: Color.fromARGB(255, 1, 68, 122),
                shadowColor: Colors.black,
                icon: Icon(
                  Icons.menu,
                  color: Colors.white,
                  size: 35,
                ),
                itemBuilder: (context) {
                  return [
                    PopupMenuItem<int>(
                      value: 0,
                      child: Row(
                        children: [
                          Icon(
                            Icons.home,
                            color: Colors.white,
                            size: 25,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text("Home",
                              style: GoogleFonts.prompt(
                                  fontSize: 20, color: Colors.white)),
                        ],
                      ),
                    ),
                    PopupMenuItem<int>(
                      value: 1,
                      child: Row(
                        children: [
                          Icon(
                            Icons.logout,
                            color: Colors.white,
                            size: 25,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text("Logout",
                              style: GoogleFonts.prompt(
                                  fontSize: 20, color: Colors.white)),
                        ],
                      ),
                    ),
                  ];
                },
                onSelected: (value) {
                  if (value == 0) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return BU_Screen(
                        token: widget.token,
                        userName: widget.userName,
                      );
                    }));
                  } else if (value == 1) {
                    showLogout_AlertDialog(context);
                  }
                })),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              alignment: Alignment.center,
              child: Text("PSUV-WH01",
                  style: GoogleFonts.prompt(
                      fontSize: 40, color: Color.fromARGB(255, 1, 68, 122))),
            ),
            SizedBox(
              height: 10,
            ),
            Text("Item QR/Barcode",
                style: GoogleFonts.prompt(
                    fontSize: 20, color: Color.fromARGB(255, 1, 57, 83))),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    child: TextFormField(
                        style: TextStyle(fontSize: 20),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Scan Item',
                        ))),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 8, 18),
                  child: IconButton(
                    alignment: Alignment.topCenter,
                    onPressed: startScan,
                    icon: Icon(
                      Icons.qr_code_scanner,
                      color: Colors.black,
                      size: 50,
                    ),
                  ),
                )
              ],
            )
          ]),
        ),
      ),
    );
  }

  startScan() async {
    String ttt = scanner.CameraAccessDenied;
    String? cameraScanResult = await scanner.scan();

    setState(() {
      textController.text = cameraScanResult ?? "";
    });
  }
}
