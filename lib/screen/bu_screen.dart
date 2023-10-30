import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:stock_counting_app/model/bu_detail.dart';
import 'dart:convert' as json;
import 'dart:io';
import 'dart:async';

import 'package:stock_counting_app/model/countingDoc.dart';
import 'package:stock_counting_app/model/drugsMaster.dart';
import 'package:stock_counting_app/model/itemMaster.dart';
import 'package:stock_counting_app/model/successlogin.dart';
import 'package:stock_counting_app/screen/count_screen.dart';
import 'package:stock_counting_app/services/api.dart';
import 'package:stock_counting_app/services/store.dart';
import 'package:stock_counting_app/utility/alert.dart';

import 'package:stock_counting_app/model/refrashToken.dart';

class BU_Screen extends StatefulWidget {
  const BU_Screen({super.key, required this.token, required this.userName});
  final String? token;
  final String? userName;
  @override
  State<BU_Screen> createState() => _BU_ScreenState();
}

class _BU_ScreenState extends State<BU_Screen> {
  final formKey = GlobalKey<FormState>();
  late Future<List<CountingDoc>> Document_List;
  BU_Detail BU = BU_Detail("", "", "", "", "", "", "", "", "", "", true);
  late String? internalToken;
  late ItemMaster _itemMaster = ItemMaster();

  @override
  void initState() {
    // TODO: implement initState
    api.checktoken().then((result) {
      if (result == "success") {
        Document_List = api.GetBU();
      } else {
        showDisconnect_AlertDialog(context, result);
      }
    });

    _itemMaster.code = "";
    _itemMaster.name = "";
    _itemMaster.uomCode = "";
    _itemMaster.location = "";
    super.initState();
  }

  /*Future<List<CountingDoc>> GetBU() async {
    late List<CountingDoc> _DocumentCounting;
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${widget.token ?? internalToken}',
      'Cookie':
          'refreshToken=p%2BBKUP28N7C%2BrTHUlBMM%2FUPeHg55hQD7KmLkNLZrduo%3D'
    };
    var request = http.Request(
        'GET',
        Uri.parse(
            'https://inventory-uat.princhealth.com/api/stockcounts/mobile'));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    var Response = await http.Response.fromStream(response);
    if (response.statusCode == 200) {
      _DocumentCounting = countingDocFromJson(Response.body);
      //print(await Response.body);
    } else {}
    return _DocumentCounting;
  }*/

  final api = stockCountingAPI();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false; //ป้องการกดปุ่มยอนกลับบน mobile
      },
      child: Scaffold(
          appBar: AppBar(
              elevation: 0,
              title: Text(
                "Stock Counting",
                style: GoogleFonts.prompt(fontSize: 25, color: Colors.white),
              ),
              automaticallyImplyLeading: false,
              leading: PopupMenuButton(
                  elevation: 0,
                  color: Color.fromARGB(255, 1, 68, 122),
                  shadowColor: Colors.black,
                  icon: Icon(
                    Icons.menu,
                    color: Colors.white,
                    size: 35,
                  ),
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem<int>(
                        value: 0,
                        child: Row(
                          children: [
                            Icon(
                              Icons.person_2,
                              color: Colors.white,
                              size: 25,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text("${widget.userName}", style: GoogleFonts.prompt(fontSize: 20, color: Colors.white)),
                          ],
                        ),
                      ),
                      PopupMenuItem<int>(
                        value: 1,
                        child: Row(
                          children: [
                            Icon(
                              Icons.logout,
                              color: Colors.white,
                              size: 25,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text("Logout", style: GoogleFonts.prompt(fontSize: 20, color: Colors.white)),
                          ],
                        ),
                      ),
                    ];
                  },
                  onSelected: (value) {
                    if (value == 1) {
                      showLogout_AlertDialog(context);
                    }
                  })),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset("asset/images/PrincLogo.png"),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        child: Text(
                          "Please select.",
                          style: GoogleFonts.prompt(fontSize: 20, color: Color.fromARGB(255, 1, 57, 83)),
                        ),
                      ),
                      DropdownSearch<CountingDoc>(
                        autoValidateMode: AutovalidateMode.onUserInteraction,
                        popupProps: PopupProps.dialog(showSearchBox: true, searchFieldProps: TextFieldProps(decoration: InputDecoration(labelText: "Search..."))), // Popup search

                        asyncItems: (filter) => Document_List, //GetBU(filter),

                        itemAsString: (CountingDoc? u) => u?.userAsString() ?? "", //กำหนดฟิลล์ที่ต้องการให้เลือก

                        onChanged: (value) {
                          setState(() {
                            BU.id = value!.id ?? "";
                            BU.buCode = value.buCode ?? "";
                            BU.buName = value.buName ?? "";
                            BU.whsCode = value.whsCode ?? "";
                            BU.whsName = value.whsName ?? "";
                            BU.docNum = value.docNum ?? "";
                            BU.controlLot = value.controlLot ?? "";
                            BU.remark = value.remarks ?? "";
                            BU.status = value.status ?? "";
                            BU.subject = value.subject ?? "";
                            BU.showOnhand = value.showOnhand;
                          });
                        },
                        dropdownDecoratorProps: DropDownDecoratorProps(dropdownSearchDecoration: InputDecoration(labelText: "Warehouse - Business Unit - Subject"), baseStyle: GoogleFonts.prompt(fontSize: 18)),
                        validator: (value) {
                          if (value == null) {
                            return 'Please select Business Unit.';
                          }
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            child: Icon(
                              Icons.business,
                              color: Color.fromARGB(255, 1, 57, 83),
                              size: 35,
                            ),
                          ),
                          Text(
                            " Business Unit",
                            style: GoogleFonts.prompt(fontSize: 20, color: Color.fromARGB(255, 1, 57, 83)),
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 177, 226, 248),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        //color: Color.fromARGB(255, 128, 210, 248),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            child: Text(
                              "${BU.buName}",
                              style: GoogleFonts.prompt(fontSize: 20, color: Color.fromARGB(255, 1, 57, 83)),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            child: Icon(
                              Icons.warehouse,
                              color: Color.fromARGB(255, 1, 57, 83),
                              size: 35,
                            ),
                          ),
                          Text(
                            " Warehouse",
                            style: GoogleFonts.prompt(fontSize: 20, color: Color.fromARGB(255, 1, 57, 83)),
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 177, 226, 248),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  child: Text(
                                    "${BU.whsName}",
                                    style: GoogleFonts.prompt(fontSize: 20, color: Color.fromARGB(255, 1, 57, 83)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            child: Icon(
                              Icons.subject,
                              color: Color.fromARGB(255, 1, 57, 83),
                              size: 35,
                            ),
                          ),
                          Text(
                            " Subject",
                            style: GoogleFonts.prompt(fontSize: 20, color: Color.fromARGB(255, 1, 57, 83)),
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 177, 226, 248),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  child: Text(
                                    "${BU.subject}",
                                    style: GoogleFonts.prompt(fontSize: 20, color: Color.fromARGB(255, 1, 57, 83)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton.icon(
                          label: Text(
                            "Start Counting",
                            style: GoogleFonts.prompt(fontSize: 20, color: Colors.white),
                          ),
                          icon: Icon(
                            Icons.play_circle,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            if (formKey.currentState?.validate() == true) {
                              formKey.currentState?.save();

                              if (widget.token != "") {
                                Navigator.push(context, MaterialPageRoute(builder: (context) {
                                  return CountScan(
                                    token: widget.token,
                                    userName: widget.userName,
                                    bu_detail: BU,
                                    itemCode: "",
                                    itemMaster: _itemMaster,
                                  );
                                }));
                              } else {
                                /*print(result?.ErrorM);
                                                showAlertDialog(
                                                    context, result?.ErrorM);*/
                              }
                              //formKey.currentState?.reset();
                            }
                          },
                        ),
                      )
                    ],
                  )),
            ),
          )),
    );
  }
}
