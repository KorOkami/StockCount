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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) {
          return Batch_Provider();
        })
      ],
      child:
          Consumer(builder: (context, Batch_Provider provider, Widget? child) {
        return Column(
          children: [
            SizedBox(
              child: Text(
                "Item Code : ${provider.bList[0].itemCode}",
                style: GoogleFonts.prompt(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Color.fromARGB(255, 1, 57, 83)),
              ),
            ),
            SizedBox(
              child: Text(
                "Item Name : ${provider.bList[0].itemName}",
                style: GoogleFonts.prompt(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Color.fromARGB(255, 1, 57, 83)),
              ),
            ),
            SizedBox(
              child: Text(
                "Base Uom : ${provider.bList[0].uomName}",
                style: GoogleFonts.prompt(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Color.fromARGB(255, 1, 57, 83)),
              ),
            ),
            ListView.builder(
                itemCount: provider.bList.length,
                itemBuilder: (context, int index) {
                  StockOnhand data = provider.bList[index];
                  return Card(
                    elevation: 5,
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                    child: ListTile(
                      title: Text("Batch : ${data.batchId}"),
                      subtitle: Text("OnHand : ${data.qty}"),
                    ),
                  );
                })
          ],
        );
      }),
    );
  }
}
