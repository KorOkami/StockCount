import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stock_counting_app/model/bu_detail.dart';
import 'package:stock_counting_app/model/itemMaster.dart';

import 'package:provider/provider.dart';
import 'package:stock_counting_app/model/stockOnhand.dart';
import 'package:stock_counting_app/providers/batch_provider.dart';

class Counting_View extends StatefulWidget {
  const Counting_View({super.key});
  //final ItemMaster itm_detail;

  @override
  State<Counting_View> createState() => _Counting_ViewState();
}

class _Counting_ViewState extends State<Counting_View> {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, Batch_Provider provider, Widget? child) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 120,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        child: Text(
                          "Item Code : ",
                          style: GoogleFonts.prompt(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Color.fromARGB(255, 1, 57, 83)),
                        ),
                      ),
                      SizedBox(
                        child: Text(
                          "${provider.bList[0].itemCode}",
                          style: GoogleFonts.prompt(
                              fontSize: 18, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          child: Text(
                            "Item Name : ",
                            style: GoogleFonts.prompt(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Color.fromARGB(255, 1, 57, 83)),
                          ),
                        ),
                        SizedBox(
                          child: Text(
                            "${provider.bList[0].itemName}",
                            style: GoogleFonts.prompt(
                                fontSize: 18,
                                color: Color.fromARGB(255, 1, 57, 83)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      SizedBox(
                        child: Text(
                          "Base Uom : ",
                          style: GoogleFonts.prompt(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Color.fromARGB(255, 1, 57, 83)),
                        ),
                      ),
                      SizedBox(
                        child: Text(
                          "${provider.bList[0].uomName}",
                          style: GoogleFonts.prompt(
                              fontSize: 18,
                              color: Color.fromARGB(255, 1, 57, 83)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                  primary: false,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: provider.bList.length,
                  itemBuilder: (context, int index) {
                    StockOnhand data = provider.bList[index];
                    return Card(
                      elevation: 5,
                      //margin: const EdgeInsets.symmetric(
                      //vertical: 8, horizontal: 5),
                      child: ListTile(
                        title: Text("Batch : ${data.batchId}",
                            style: GoogleFonts.prompt(
                                fontSize: 17,
                                color: Color.fromARGB(255, 1, 57, 83))),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("OnHand : ${data.qty}",
                                style: GoogleFonts.prompt(
                                  fontSize: 15,
                                )),
                            Text("Counted : ${data.countQty}",
                                style: GoogleFonts.prompt(
                                  fontSize: 15,
                                )),
                            Text("Diff : ${data.diffQty}",
                                style: GoogleFonts.prompt(
                                  fontSize: 15,
                                )),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      );
    });
  }
}
