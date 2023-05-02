import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:http/http.dart' as http;
import 'package:stock_counting_app/model/bu_detail.dart';
import 'dart:convert' as json;
import 'dart:io';
import 'dart:async';

import 'package:provider/provider.dart';

import 'package:stock_counting_app/model/countingDetail.dart';
import 'package:stock_counting_app/providers/token_provider.dart';

class Counting_Detail extends StatefulWidget {
  const Counting_Detail(
      {super.key,
      required this.token,
      required this.onHandId,
      required this.BatchID});
  final String? token;
  final String? onHandId;
  final String? BatchID;
  @override
  State<Counting_Detail> createState() => _Counting_DetailState();
}

class _Counting_DetailState extends State<Counting_Detail> {
  List<CountingDetail>? countingDetailList = [];

  Future<String> GetCountingDetail() async {
    List<CountingDetail> _countingDetail = [];
    String result = "";
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${widget.token}',
      'Cookie':
          'refreshToken=p%2BBKUP28N7C%2BrTHUlBMM%2FUPeHg55hQD7KmLkNLZrduo%3D'
    };
    var request = http.Request(
        'GET',
        Uri.parse(
            'http://172.24.9.24:5000/api/stockcounts/actuals/${widget.onHandId}'));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    var Response = await http.Response.fromStream(response);
    if (response.statusCode == 200) {
      _countingDetail = countingDetailFromJson(Response.body);
      setState(() {
        countingDetailList = _countingDetail;
      });
    } else {
      //showAlertDialog(context, "Item not found.");
      setState(() {});
    }
    return result;
  }

  @override
  void initState() {
    // TODO: implement initState
    GetCountingDetail();
    super.initState();
  }

  /*_getSumByUser(List<CountingDetail> list) {
    Map<String?, int?> sumMap = {};

    list.forEach((product) {
      if (sumMap.containsKey(product.userName)) {
        sumMap[product.userName] += product.countQty!;
      } else {
        sumMap[product.userName] = product.countQty;
      }
    });

    return sumMap;
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Counting Detail",
          style: GoogleFonts.prompt(fontSize: 25, color: Colors.white),
        ),
        //automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(children: [
        Container(
          height: 50,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SizedBox(
                      child: Text(
                        "Batch : ",
                        style: GoogleFonts.prompt(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Color.fromARGB(255, 1, 57, 83)),
                      ),
                    ),
                    SizedBox(
                      child: Text(
                        "${widget.BatchID}",
                        style: GoogleFonts.prompt(
                            fontSize: 18, color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
              primary: false,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: countingDetailList!.length,
              itemBuilder: (context, int index) {
                CountingDetail data = countingDetailList![index];
                return Slidable(
                  key: Key('$data'),
                  endActionPane:
                      ActionPane(motion: const ScrollMotion(), children: [
                    SlidableAction(
                      onPressed: (context) {},
                      backgroundColor: Colors.green,
                      icon: Icons.edit,
                    ),
                    SlidableAction(
                      onPressed: (context) {
                        setState(() {
                          countingDetailList!.removeAt(index);
                        });
                      },
                      backgroundColor: Colors.red,
                      icon: Icons.delete,
                    )
                  ]),
                  child: Card(
                    elevation: 5,
                    //margin: const EdgeInsets.symmetric(
                    //vertical: 8, horizontal: 5),
                    child: ListTile(
                      title: Text("Counted : ${data.countQty}",
                          style: GoogleFonts.prompt(
                              fontSize: 17,
                              color: Color.fromARGB(255, 1, 57, 83))),
                      subtitle: Text("User : ${data.userName}",
                          style: GoogleFonts.prompt(
                            fontSize: 15,
                          )),
                      /*trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
                          IconButton(
                              onPressed: () {}, icon: Icon(Icons.delete)),
                        ],
                      ),*/
                    ),
                  ),
                );
              }),
        ),
      ]),
    );
  }
}
