import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:stock_counting_app/screen/bu_screen.dart';
import 'package:stock_counting_app/screen/counting_view.dart';

import 'package:stock_counting_app/utility/alert.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qrscan/qrscan.dart' as scanner;

import 'package:stock_counting_app/model/bu_detail.dart';
import 'package:motion_tab_bar_v2/motion-badge.widget.dart';
import 'package:motion_tab_bar_v2/motion-tab-bar.dart';
import 'package:motion_tab_bar_v2/motion-tab-item.dart';

class Scan_Item extends StatefulWidget {
  const Scan_Item({super.key, required this.bu_detail});
  final BU_Detail bu_detail;
  @override
  State<Scan_Item> createState() => _Scan_ItemState();
}

class _Scan_ItemState extends State<Scan_Item> {
  TextEditingController textController = TextEditingController();
  TextEditingController? _textEditingController;
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: formKey,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            alignment: Alignment.center,
            child: Text(
                "${widget.bu_detail.buCode} - ${widget.bu_detail.whsCode}",
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
          ),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            child: Text(
              "Item Name :",
              style: GoogleFonts.prompt(
                  fontSize: 20, color: Color.fromARGB(255, 1, 57, 83)),
            ),
          ),
          SizedBox(
            child: Text(
              "Location :",
              style: GoogleFonts.prompt(
                  fontSize: 20, color: Color.fromARGB(255, 1, 57, 83)),
            ),
          ),
          SizedBox(
            child: Text(
              "Base Uom :",
              style: GoogleFonts.prompt(
                  fontSize: 20, color: Color.fromARGB(255, 1, 57, 83)),
            ),
          ),
          SizedBox(
            child: Text(
              "Batch",
              style: GoogleFonts.prompt(
                  fontSize: 20, color: Color.fromARGB(255, 1, 57, 83)),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          SizedBox(
            child: Text(
              "Onhand :",
              style: GoogleFonts.prompt(
                  fontSize: 20, color: Color.fromARGB(255, 1, 57, 83)),
            ),
          ),
          SizedBox(
            child: Text(
              "Counted :",
              style: GoogleFonts.prompt(
                  fontSize: 20, color: Color.fromARGB(255, 1, 57, 83)),
            ),
          ),
          SizedBox(
            child: Text(
              "Count :",
              style: GoogleFonts.prompt(
                  fontSize: 20, color: Color.fromARGB(255, 1, 57, 83)),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              label: Text(
                "ยืนยัน",
                style: GoogleFonts.prompt(fontSize: 20, color: Colors.white),
              ),
              icon: Icon(
                Icons.check_rounded,
                color: Colors.white,
              ),
              onPressed: () {
                if (formKey.currentState?.validate() == true) {
                  formKey.currentState?.save();

                  //formKey.currentState?.reset();
                }
              },
            ),
          )
        ]),
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
