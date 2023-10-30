import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:stock_counting_app/model/history_model.dart';
import 'package:stock_counting_app/screen/counting_Detail.dart';
import 'package:stock_counting_app/services/api.dart';
import 'package:stock_counting_app/utility/alert.dart';

class history_screen extends StatefulWidget {
  const history_screen(
      {super.key
      //, required this.history_list
      ,
      required this.stockcountID,
      required this.userName});
  final String? stockcountID;
  final String? userName;
  //final List<history> history_list;

  @override
  State<history_screen> createState() => _history_screenState();
}

class _history_screenState extends State<history_screen> {
  // late Future<List<history>> history_List;
  late List<history> _List_history = [];

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
    getLog();
    // api.checktoken().then((result) {
    //   if (result == "success") {
    //     api.GetHistory(widget.stockcountID!, widget.userName ?? "").then((value) {
    //       setState(() {
    //         _List_history = value;
    //       });
    //     });
    //   } else {
    //     showDisconnect_AlertDialog(context, result);
    //   }
    // });
    super.initState();
  }

  final api = stockCountingAPI();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Counting Log",
          style: GoogleFonts.prompt(fontSize: 25, color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
              onPressed: () {
                getLog();
              },
              icon: const Icon(
                Icons.refresh,
                color: Colors.white,
                size: 30,
              ))
        ],
      ),
      body: ListView.builder(
          // reverse: false,
          physics: const AlwaysScrollableScrollPhysics(),
          primary: false,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: _List_history.length,
          //itemCount: getLog().length,
          itemBuilder: (context, int index) {
            history data = _List_history[index];
            //history data = getLog()[index];
            if (data != null)
              return Card(
                child: ListTile(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return Counting_Detail(
                        //token: token_provider.token,
                        onHandId: data.onhandId,
                        BatchID: data.batchId,
                        bu_ID: widget.stockcountID,
                        itemCode: data.itemCode,
                        userName: data.userName,
                      );
                    })).then((value) => getLog());
                  },
                  title: Text(DateFormat('dd/MM/yyyy : HH:mm:ss').format(DateTime.parse(data.createDate!).add(Duration(hours: 7))), style: GoogleFonts.prompt(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold)),
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
                      data.comments != null
                          ? Text("Comments : ${data.comments!}",
                              style: GoogleFonts.prompt(
                                fontSize: 15,
                              ))
                          : Text("Comments : ",
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

  void getLog() {
    api.checktoken().then((result) {
      if (result == "success") {
        api.GetHistory(widget.stockcountID!, widget.userName ?? "").then((value) {
          setState(() {
            _List_history = value;
          });
        });
      } else {
        showDisconnect_AlertDialog(context, result);
      }
    });
  }
}
