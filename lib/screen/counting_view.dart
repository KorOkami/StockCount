import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stock_counting_app/model/bu_detail.dart';
import 'package:stock_counting_app/model/itemMaster.dart';

class Counting_View extends StatefulWidget {
  const Counting_View({super.key});
  //final ItemMaster itm_detail;

  @override
  State<Counting_View> createState() => _Counting_ViewState();
}

class _Counting_ViewState extends State<Counting_View> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            child: Text(
              "Item Code :",
              style: GoogleFonts.prompt(
                  fontSize: 20, color: Color.fromARGB(255, 1, 57, 83)),
            ),
          ),
          SizedBox(
            child: Text(
              "Item Name : ",
              style: GoogleFonts.prompt(
                  fontSize: 20, color: Color.fromARGB(255, 1, 57, 83)),
            ),
          ),
          SizedBox(
            child: Text(
              "Base Uom : ",
              style: GoogleFonts.prompt(
                  fontSize: 20, color: Color.fromARGB(255, 1, 57, 83)),
            ),
          ),
        ],
      ),
    );
  }
}
