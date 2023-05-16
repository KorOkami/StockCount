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

import 'package:provider/provider.dart';
import 'package:stock_counting_app/model/stockOnhand.dart';
import 'package:stock_counting_app/providers/batch_provider.dart';
import 'package:stock_counting_app/providers/token_provider.dart';
import 'package:stock_counting_app/screen/counting_Detail.dart';

class Counting_View extends StatefulWidget {
  const Counting_View({super.key});
  //final ItemMaster itm_detail;

  @override
  State<Counting_View> createState() => _Counting_ViewState();
}

class _Counting_ViewState extends State<Counting_View> {
  Future<void> GetBatchList(
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
            'http://172.24.9.24:5000/api/stockcounts/onhandsbyitem/${onhandID}?ItemCode=${itemCode}'));
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
  }

  @override
  Widget build(BuildContext context) {
    final userStore = Provider.of<Batch_Provider>(context, listen: true);
    return Consumer2<Batch_Provider, Token_Provider>(builder: (context,
        Batch_Provider provider, Token_Provider token_provider, Widget? child) {
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
              child: RefreshIndicator(
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
                          onTap: () {
                            //print(Text("${data.id}"));

                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return Counting_Detail(
                                token: token_provider.token,
                                onHandId: data.id,
                                BatchID: data.batchId,
                              );
                            }));
                          },
                        ),
                      );
                    }),
                onRefresh: _getData,
              ),
            ),
          ],
        ),
      );
    });
  }

  Future<void> _getData() async {
    setState(() {
      //GetBatchList(itm, tok, id);
    });
  }
}
