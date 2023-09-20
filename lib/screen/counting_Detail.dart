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
import 'package:stock_counting_app/model/stockOnhand.dart';
import 'package:stock_counting_app/providers/batch_provider.dart';
import 'package:stock_counting_app/providers/token_provider.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:stock_counting_app/services/api.dart';
import 'package:stock_counting_app/services/store.dart';
import 'package:stock_counting_app/utility/alert.dart';
import 'package:flutter/services.dart';

class Counting_Detail extends StatefulWidget {
  const Counting_Detail(
      {super.key,
      required this.token,
      required this.onHandId,
      required this.BatchID,
      required this.bu_ID,
      required this.itemCode});
  final String? token;
  final String? onHandId;
  final String? BatchID;
  final String? bu_ID;
  final String? itemCode;
  @override
  State<Counting_Detail> createState() => _Counting_DetailState();
}

class _Counting_DetailState extends State<Counting_Detail> {
  final formKey = GlobalKey<FormState>();
  final formKeyComments = GlobalKey<FormState>();
  late Future<List<CountingDetail>> futurecountingDetailList;
  late List<CountingDetail>? countingDetailList = [];
  late String deleteRes = "";
  final api = stockCountingAPI();
  late Future<List<StockOnhand>> Batch_List;
  late List<StockOnhand> List_StockOnhand = [];
  bool _isDelete = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  /*Future<String> GetCountingDetail() async {
    List<CountingDetail> _countingDetail = [];
    final token = await Store.getToken();
    String result = "";
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${token}',
      'Cookie':
          'refreshToken=p%2BBKUP28N7C%2BrTHUlBMM%2FUPeHg55hQD7KmLkNLZrduo%3D'
    };
    var request = http.Request(
        'GET',
        Uri.parse(
            'https://inventory-uat.princhealth.com/api/stockcounts/onhands/${widget.onHandId}/actuals'));
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
  }*/

  Future<String> DeleteCountingDetail(String actualID) async {
    String? token = await Store.getToken();
    String result = "";
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${token}',
      'Cookie':
          'refreshToken=p%2BBKUP28N7C%2BrTHUlBMM%2FUPeHg55hQD7KmLkNLZrduo%3D'
    };
    var request = http.Request(
        'DELETE',
        Uri.parse(
            'https://inventory-uat.princhealth.com/api/stockcounts/deleteactual/${actualID}'));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    var Response = await http.Response.fromStream(response);
    if (response.statusCode == 200) {
      result = "success";
      setState(() {
        deleteRes = "success";
      });
    } else {
      result = "fail";
    }
    return result;
  }

  /*Future<String> EditCountingDetail(String actualID, String countedQty) async {
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
            'https://inventory-uat.princhealth.com/api/stockcounts/editactual/${actualID}?countQty=${countedQty}'));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    var Response = await http.Response.fromStream(response);
    if (response.statusCode == 200) {
      result = "success";
    } else {}
    return result;
  }*/

  @override
  void initState() {
    // TODO: implement initState
    futurecountingDetailList = api.GetCountingDetail(widget.onHandId ?? "");
    Future.delayed(const Duration(
            milliseconds: 500)) //Delay ให้ข้อมูล Future เป็น List ธรรมดา
        .then((val) {
      setState(() {
        ConvertList();
      });
    });

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
        key: _scaffoldKey,
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
          widget.BatchID != ""
              ? Container(
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
                          )
                        ],
                      )),
                )
              : Container(),
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
                                          key: formKeyComments,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                TextFormField(
                                                  minLines: 1,
                                                  maxLines: 8,
                                                  maxLength: 100,
                                                  decoration: InputDecoration(
                                                    border:
                                                        OutlineInputBorder(),
                                                    labelText: 'Edit Remark',
                                                  ),
                                                  style: GoogleFonts.prompt(
                                                      fontSize: 18,
                                                      color: Colors.black),
                                                  keyboardType:
                                                      TextInputType.number,
                                                  onChanged: (value) {
                                                    // setState(() {
                                                    //   strCounted = value;
                                                    // });
                                                  },
                                                  // validator: RequiredValidator(
                                                  //     errorText:
                                                  //         "Please Enter Remark."),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                SizedBox(
                                                  width: double.infinity,
                                                  height: 50,
                                                  child: ElevatedButton(
                                                    onPressed: () {
                                                      if (formKeyComments
                                                              .currentState
                                                              ?.validate() ==
                                                          true) {
                                                        formKeyComments
                                                            .currentState
                                                            ?.save();

                                                        // api.EditCountingDetail(
                                                        //         data.id!,
                                                        //         strCounted)
                                                        //     .then((result) {
                                                        //   if (result ==
                                                        //       "success") {
                                                        //     refreshDataBatch(
                                                        //         data.itemCode!);
                                                        //     setState(() {
                                                        //       data.countQty =
                                                        //           int.parse(
                                                        //               strCounted);
                                                        //     });
                                                        //   } else {
                                                        //     showAlertDialog(
                                                        //         context,
                                                        //         "Update Failed.");
                                                        //   }
                                                        // });

                                                        // Navigator.pop(context);
                                                      }
                                                    },
                                                    child: Text("Update",
                                                        style:
                                                            GoogleFonts.prompt(
                                                                fontSize: 20,
                                                                color: Colors
                                                                    .white)),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ))
                                    ],
                                  ));
                        },
                        backgroundColor: Color.fromARGB(255, 49, 3, 253),
                        foregroundColor: Colors.white,
                        icon: Icons.edit_note,
                        label: 'Remark',
                      ),
                      SlidableAction(
                        label: 'Counted',
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
                                                    border:
                                                        OutlineInputBorder(),
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
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter
                                                        .allow(
                                                      RegExp("[0-9]"),
                                                    ),
                                                  ],
                                                  validator: (value) {
                                                    if (value!.isEmpty) {
                                                      return "Please Enter Counted.";
                                                    } else if (double.parse(
                                                                value)
                                                            .toInt() <
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

                                                        api.EditCountingDetail(
                                                                data.id!,
                                                                strCounted)
                                                            .then((result) {
                                                          if (result ==
                                                              "success") {
                                                            refreshDataBatch(
                                                                data.itemCode!);
                                                            setState(() {
                                                              data.countQty =
                                                                  int.parse(
                                                                      strCounted);
                                                            });
                                                          } else {
                                                            showAlertDialog(
                                                                context,
                                                                "Update Failed.");
                                                          }
                                                        });

                                                        Navigator.pop(context);
                                                      }
                                                    },
                                                    child: Text("Update",
                                                        style:
                                                            GoogleFonts.prompt(
                                                                fontSize: 20,
                                                                color: Colors
                                                                    .white)),
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
                        label: 'Delete',
                        onPressed: (context) {
                          setState(() {
                            showDelete_AlertDialog(context, data, index);
                            // if (_isDelete == true) {
                            //   DeleteCountingDetail(data.id!).then((result) {
                            //     if (result == "success") {
                            //       countingDetailList!.removeAt(index);
                            //       refreshDataBatch(data.itemCode!);
                            //     } else {}
                            //   });
                            // }
                          });
                        },
                        backgroundColor: Colors.red,
                        icon: Icons.delete,
                      )
                    ]),
                    child: Card(
                      shadowColor: Colors.lightBlue,
                      elevation: 5,
                      child: ListTile(
                        title: Text("Counted : ${data.countQty}",
                            style: GoogleFonts.prompt(
                                fontSize: 17,
                                color: Color.fromARGB(255, 1, 57, 83))),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("User : ${data.userName}",
                                style: GoogleFonts.prompt(
                                  fontSize: 15,
                                )),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                                "Remark : lsdhfahfd;aljshfksjdhfsdjfhsldhfsjdhfksadjhfkasdjhfksjdfhksjdfhkjh",
                                style: GoogleFonts.prompt(
                                    fontSize: 14,
                                    color: Color.fromARGB(255, 1, 57, 83)))
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          ),
        ]));
  }

  void refreshDataBatch(String itemcode) {
    Batch_List = api.GetBatchList(widget.bu_ID ?? "", itemcode);
    ConvertBatchList(); // แปลงจาก Future List เป็น List
    Future.delayed(const Duration(
            seconds: 1)) //Delay ให้ข้อมูล Future เป็น List ธรรมดา
        .then((val) {
      Batch_Provider provider =
          Provider.of<Batch_Provider>(context, listen: false);
      provider.addBatchStockOnhand(List_StockOnhand);
    });
  }

  void ConvertList() async {
    countingDetailList = await futurecountingDetailList;
  }

  void ConvertBatchList() async {
    List_StockOnhand = await Batch_List;
  }

  showDelete_AlertDialog(BuildContext context, CountingDetail data, int index) {
    // set up the buttons
    Widget OkButton = TextButton(
      child: Text(
        "Yes",
        style: GoogleFonts.prompt(fontSize: 20),
      ),
      onPressed: () {
        setState(() {
          _isDelete = true;
          DeleteCountingDetail(data.id!).then((result) {
            if (result == "success") {
              countingDetailList!.removeAt(index);
              refreshDataBatch(data.itemCode!);
            } else {
              showAlertDialog(context, "Delete Failed.");
            }
          });
        });
        Navigator.of(_scaffoldKey.currentContext!).pop();
      },
    );
    Widget cancelButton = TextButton(
        child: Text(
          "No",
          style: GoogleFonts.prompt(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        onPressed: () => Navigator.of(_scaffoldKey.currentContext!).pop());

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        "Warning",
        style: GoogleFonts.prompt(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      content: Text(
        "Are you sure you want to delete?",
        style: GoogleFonts.prompt(fontSize: 16),
      ),
      actions: [
        OkButton,
        cancelButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
