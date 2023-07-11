import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:stock_counting_app/model/history_model.dart';
import 'package:stock_counting_app/services/api.dart';

class history_screen extends StatefulWidget {
  const history_screen({super.key, required this.history_list});
  // final String? stockcountID;
  // final String? userName;
  final List<history> history_list;

  @override
  State<history_screen> createState() => _history_screenState();
}

class _history_screenState extends State<history_screen> {
  // late Future<List<history>> history_List;
  // late List<history> _List_history = [];

  @override
  void initState() {
    // TODO: implement initState
    // history_List =
    //     api.GetHistory(widget.stockcountID ?? "", widget.userName ?? "");

    // Future.delayed(const Duration(
    //         seconds: 1)) //Delay ให้ข้อมูล Future เป็น List ธรรมดา
    //     .then((val) {
    //   ConverthistoryList();
    // });
    super.initState();
  }

  final api = stockCountingAPI();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "History",
          style: GoogleFonts.prompt(fontSize: 25, color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView.builder(
          // reverse: false,
          physics: const AlwaysScrollableScrollPhysics(),
          primary: false,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: widget.history_list.length,
          itemBuilder: (context, int index) {
            history data = widget.history_list[index];
            if (data != null)
              return Card(
                child: ListTile(
                  title: Text(
                      DateFormat('dd/MM/yyyy : HH:mm:ss').format(
                          DateTime.parse(data.createDate!)
                              .add(Duration(hours: 7))),
                      style: GoogleFonts.prompt(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("ItemCode : ${data.itemCode ?? ""}",
                          style: GoogleFonts.prompt(
                            fontSize: 15,
                          )),
                      Text("ItemName : ${data.itemName ?? ""}",
                          style: GoogleFonts.prompt(
                            fontSize: 15,
                          )),
                      Text("Batch : ${data.batchId ?? ""}",
                          style: GoogleFonts.prompt(
                            fontSize: 15,
                          )),
                      data.expiryDate != null
                          ? Text("Expiry Date : ${data.expiryDate!}",
                              style: GoogleFonts.prompt(
                                fontSize: 15,
                              ))
                          : Text("Expiry Date : ",
                              style: GoogleFonts.prompt(
                                fontSize: 15,
                              )),
                      Text("Count Qty : ${data.countQty!}",
                          style: GoogleFonts.prompt(
                            fontSize: 15,
                          )),
                      Text("User : ${data.userName!}",
                          style: GoogleFonts.prompt(
                            fontSize: 15,
                          )),
                      SizedBox(
                        height: 5,
                      )
                    ],
                  ),
                ),
              );
          }),
    );
  }

  // void ConverthistoryList() async {
  //   _List_history = await history_List;
  // }
}
