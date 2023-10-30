import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stock_counting_app/model/bu_detail.dart';
import 'package:stock_counting_app/model/itemMaster.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as json;
import 'dart:io';
import 'dart:async';

import 'package:intl/intl.dart';

import 'package:provider/provider.dart';
import 'package:stock_counting_app/model/stockOnhand.dart';
import 'package:stock_counting_app/providers/batch_provider.dart';
import 'package:stock_counting_app/providers/token_provider.dart';
import 'package:stock_counting_app/screen/counting_Detail.dart';
import 'package:stock_counting_app/services/api.dart';

class Counting_View extends StatefulWidget {
  const Counting_View({
    super.key,
    required this.bu_detail,
    required this.itemMaster,
    required this.sortfield,
    required this.userName,
  });
  final BU_Detail bu_detail;
  final ItemMaster itemMaster;
  final String sortfield;
  final String userName;

  @override
  State<Counting_View> createState() => _Counting_ViewState();
}

class _Counting_ViewState extends State<Counting_View> {
  late Future<List<StockOnhand>> Batch_List;
  final StockOnhand batch_detail = StockOnhand();
  late List<StockOnhand> List_StockOnhand = [];
  late String _sortfield = widget.sortfield;
  //final List<StockOnhand> List_test = [];
  /*Future<void> GetBatchList(
      String itemCode, String token, String onhandID) async {
    late List<StockOnhand> _StockOnhand;
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${token}',
      'Cookie':
          'refreshToken=p%2BBKUP28N7C%2BrTHUlBMM%2FUPeHg55hQD7KmLkNLZrduo%3D'
    };
    var request = http.Request(
        'GET',
        Uri.parse(
            'https://inventory-uat.princhealth.com/api/stockcounts/onhandsbyitem/${onhandID}?ItemCode=${itemCode}'));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    var Response = await http.Response.fromStream(response);
    if (response.statusCode == 200) {
      _StockOnhand = stockOnhandFromJson(Response.body);
      setState(() {
        //List_StockOnhand = _StockOnhand;
      });

      if (_StockOnhand.length != 0) {
        Batch_Provider provider =
            Provider.of<Batch_Provider>(context, listen: false);
        provider.addBatchStockOnhand(_StockOnhand);
      }
    } else {
      //_faillogin = failloginFromJson(Response.body);
    }
    //return _StockOnhand;
  }*/

  @override
  Widget build(BuildContext context) {
    final userStore = Provider.of<Batch_Provider>(context, listen: true);
    return Consumer2<Batch_Provider, Token_Provider>(builder: (context, Batch_Provider provider, Token_Provider token_provider, Widget? child) {
      return provider.bList.length != 0
          ? Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    flex: 0,
                    ////////////////////////////////////////////////////////////////
                    //height: 150,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              child: Text(
                                "Item Code : ",
                                style: GoogleFonts.prompt(fontWeight: FontWeight.bold, fontSize: 18, color: Color.fromARGB(255, 1, 57, 83)),
                              ),
                            ),
                            SizedBox(
                              child: Text(
                                "${widget.itemMaster.code}",
                                style: GoogleFonts.prompt(fontSize: 18, color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              child: Text(
                                "Item Name : ",
                                style: GoogleFonts.prompt(fontWeight: FontWeight.bold, fontSize: 18, color: Color.fromARGB(255, 1, 57, 83)),
                              ),
                            ),
                            SizedBox(
                              child: Text(
                                "${widget.itemMaster.name}",
                                style: GoogleFonts.prompt(fontSize: 18, color: Color.fromARGB(255, 1, 57, 83)),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(
                              child: Text(
                                "Base Uom : ",
                                style: GoogleFonts.prompt(fontWeight: FontWeight.bold, fontSize: 18, color: Color.fromARGB(255, 1, 57, 83)),
                              ),
                            ),
                            SizedBox(
                              child: Text(
                                "${widget.itemMaster.uomCode == null ? "" : widget.itemMaster.uomCode}",
                                style: GoogleFonts.prompt(fontSize: 18, color: Color.fromARGB(255, 1, 57, 83)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    // child: RefreshIndicator(
                    //   onRefresh: _getData,
                    child: ListView.builder(
                        // reverse: false,
                        physics: const AlwaysScrollableScrollPhysics(),
                        primary: false,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: provider.bList.length,
                        itemBuilder: (context, int index) {
                          // final List_test = provider.bList
                          //   ..sort((a, b) {
                          //     //sorting in ascending order
                          //     return DateTime.parse(b.expiryDate!)
                          //         .compareTo(DateTime.parse(a.expiryDate!));
                          //   });
                          final List_test = getSorting(provider.bList, widget.sortfield);
                          StockOnhand data = List_test[index];
                          // StockOnhand data = provider.bList[index];
                          if (data != null)
                            return Card(
                              shadowColor: Colors.lightBlue,
                              color: Color.fromARGB(255, 239, 249, 253),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              elevation: 5,
                              child: ListTile(
                                title: data.batchId != "" && data.batchId != null
                                    ? Text("Batch : ${data.batchId ?? ""}", style: GoogleFonts.prompt(fontSize: 17, color: Color.fromARGB(255, 1, 57, 83)))
                                    : Container(
                                        height: 5,
                                      ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    data.batchId != "" && data.expiryDate != null
                                        ? checkexpDate(data.expiryDate!) == true
                                            ? Text("Expire Date : ${DateFormat('dd-MM-yyyy').format(DateTime.parse(data.expiryDate!))}",
                                                style: GoogleFonts.prompt(
                                                  color: Colors.red,
                                                  fontSize: 12,
                                                ))
                                            : Text("Expire Date : ${DateFormat('dd-MM-yyyy').format(DateTime.parse(data.expiryDate!))}",
                                                style: GoogleFonts.prompt(
                                                  color: Colors.green,
                                                  fontSize: 12,
                                                ))
                                        : Container(
                                            height: 2,
                                          ),
                                    Text("OnHand : ${data.qty ?? ""}",
                                        style: GoogleFonts.prompt(
                                          fontSize: 15,
                                        )),
                                    Text("Counted : ${data.countQty ?? ""}",
                                        style: GoogleFonts.prompt(
                                          fontSize: 15,
                                        )),
                                    Text("Diff : ${data.diffQty ?? ""}",
                                        style: GoogleFonts.prompt(
                                          fontSize: 15,
                                        )),
                                    SizedBox(
                                      height: 5,
                                    )
                                  ],
                                ),
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                                    return Counting_Detail(
                                      //token: token_provider.token,
                                      onHandId: data.id,
                                      BatchID: data.batchId,
                                      bu_ID: widget.bu_detail.id,
                                      itemCode: data.itemCode,
                                      userName: widget.userName,
                                    );
                                  }));
                                },
                              ),
                            );
                        }),
                    //),
                  ),
                ],
              ),
            )
          : Center(
              child: Text("No Items found.",
                  style: GoogleFonts.prompt(
                    fontSize: 20,
                  )),
            );
    });
  }

  final api = stockCountingAPI();

  // Future<void> _getData() async {
  //   setState(() {
  //     Batch_List =
  //         api.GetBatchList(widget.bu_detail.id, widget.itemMaster.code ?? "");
  //     if (Batch_List != null) {
  //       ConvertBatchList();
  //       Future.delayed(const Duration(
  //               seconds: 1)) //Delay ให้ข้อมูล Future เป็น List ธรรมดา
  //           .then((val) {
  //         Batch_Provider provider =
  //             Provider.of<Batch_Provider>(context, listen: false);
  //         provider.addBatchStockOnhand(List_StockOnhand);
  //       });
  //     }
  //   });
  // }

  void ConvertBatchList() async {
    List_StockOnhand = await Batch_List;
    //List_StockOnhand = getSorting(List_StockOnhand, widget.sortfield);
  }

  bool checkexpDate(String expDate) {
    bool result = false;
    DateTime dtExp = DateTime.parse(expDate);
    Duration diff = dtExp.difference(DateTime.now());
    if (diff.inDays <= 180) {
      result = true;
    }
    return result;
  }

  List<StockOnhand> getSorting(List<StockOnhand> batchlist, String srtfield) {
    List<StockOnhand> resSorted = [];
    if (srtfield == "Exp") {
      resSorted = batchlist
        ..sort((a, b) {
          return DateTime.parse(a.expiryDate!).compareTo(DateTime.parse(b.expiryDate!));
        });
    } else if (srtfield == "Onhand") {
      resSorted = batchlist
        ..sort((a, b) {
          return b.qty!.compareTo(a.qty!);
        });
    } else if (srtfield == "Count") {
      resSorted = batchlist
        ..sort((a, b) {
          return b.countQty!.compareTo(a.countQty!);
        });
    } else if (srtfield == "Diff") {
      resSorted = batchlist
        ..sort((a, b) {
          return b.diffQty!.compareTo(a.diffQty!);
        });
    } else if (srtfield == "Batch") {
      resSorted = batchlist
        ..sort((a, b) {
          return a.batchId!.compareTo(b.batchId!);
        });
    } else {
      resSorted = batchlist;
    }

    return resSorted;
  }
}
