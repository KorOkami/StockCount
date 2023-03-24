import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:stock_counting_app/screen/bu_screen.dart';
import 'package:stock_counting_app/screen/counting_view.dart';

import 'package:stock_counting_app/utility/alert.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qrscan/qrscan.dart' as scanner;

import 'package:motion_tab_bar_v2/motion-badge.widget.dart';
import 'package:motion_tab_bar_v2/motion-tab-bar.dart';
import 'package:motion_tab_bar_v2/motion-tab-item.dart';

class Scan_Item extends StatefulWidget {
  const Scan_Item({super.key});

  @override
  State<Scan_Item> createState() => _Scan_ItemState();
}

class _Scan_ItemState extends State<Scan_Item> {
  TextEditingController textController = TextEditingController();
  TextEditingController? _textEditingController;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
              controller: _textEditingController,
              style: TextStyle(fontSize: 20),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Scan Item',
              ),
            )),
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
