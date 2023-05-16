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
import 'package:form_field_validator/form_field_validator.dart';

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
  final formKey = GlobalKey<FormState>();
  List<CountingDetail>? countingDetailList = [];
  late String deleteRes = "";

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

  Future<String> DeleteCountingDetail(String actualID) async {
    //List<CountingDetail> _countingDetail = [];
    String result = "";
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${widget.token}',
      'Cookie':
          'refreshToken=p%2BBKUP28N7C%2BrTHUlBMM%2FUPeHg55hQD7KmLkNLZrduo%3D'
    };
    var request = http.Request(
        'DELETE',
        Uri.parse(
            'http://172.24.9.24:5000/api/stockcounts/deleteactual/${actualID}'));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    var Response = await http.Response.fromStream(response);
    if (response.statusCode == 200) {
      result = "success";
      setState(() {
        deleteRes = "success";
      });
    } else {
      //showAlertDialog(context, "Item not found.");
      setState(() {});
    }
    return result;
  }

  Future<String> EditCountingDetail(String actualID, String countedQty) async {
    //List<CountingDetail> _countingDetail = [];
    String result = "";
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${widget.token}',
      'Cookie':
          'refreshToken=p%2BBKUP28N7C%2BrTHUlBMM%2FUPeHg55hQD7KmLkNLZrduo%3D'
    };
    var request = http.Request(
        'PUT',
        Uri.parse(
            'http://172.24.9.24:5000/api/stockcounts/editactual/${actualID}?countQty=${countedQty}'));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    var Response = await http.Response.fromStream(response);
    if (response.statusCode == 200) {
      result = "success";
    } else {}
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
  String strCounted = '';

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
              itemBuilder: (context, index) {
                CountingDetail data = countingDetailList![index];
                return Slidable(
                  key: Key('$data'),
                  startActionPane:
                      ActionPane(motion: const ScrollMotion(), children: [
                    SlidableAction(
                      onPressed: (context) {
                        showDialog(
                            context: context,
                            builder: (context) => SimpleDialog(
                                  children: [
                                    Form(
                                        key: formKey,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              TextFormField(
                                                decoration: InputDecoration(
                                                  border: OutlineInputBorder(),
                                                  labelText:
                                                      'Edit Counted Item',
                                                ),
                                                style: GoogleFonts.prompt(
                                                    fontSize: 18,
                                                    color: Colors.black),
                                                keyboardType:
                                                    TextInputType.number,
                                                onChanged: (value) {
                                                  setState(() {
                                                    strCounted = value;
                                                  });
                                                },
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return "Please Enter Counted.";
                                                  } else if (double.parse(value)
                                                          .toInt() <=
                                                      0) {
                                                    return "Count should be greater than 0";
                                                  }
                                                },
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              SizedBox(
                                                width: double.infinity,
                                                height: 50,
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    if (formKey.currentState
                                                            ?.validate() ==
                                                        true) {
                                                      formKey.currentState
                                                          ?.save();

                                                      EditCountingDetail(
                                                              data.id!,
                                                              strCounted)
                                                          .then((result) {
                                                        if (result ==
                                                            "success") {
                                                          setState(() {
                                                            data.countQty =
                                                                int.parse(
                                                                    strCounted);
                                                          });
                                                        } else {}
                                                      });

                                                      Navigator.pop(context);
                                                    }
                                                  },
                                                  child: Text("Update",
                                                      style: GoogleFonts.prompt(
                                                          fontSize: 15,
                                                          color: Colors.white)),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ))
                                  ],
                                ));
                      },
                      backgroundColor: Colors.green,
                      icon: Icons.edit,
                    ),
                  ]),
                  endActionPane:
                      ActionPane(motion: const ScrollMotion(), children: [
                    SlidableAction(
                      onPressed: (context) {
                        setState(() {
                          DeleteCountingDetail(data.id!).then((result) {
                            if (result == "success") {
                              countingDetailList!.removeAt(index);
                            } else {}
                          });
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
