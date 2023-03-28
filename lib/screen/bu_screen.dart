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

import 'package:stock_counting_app/model/drugsMaster.dart';
import 'package:stock_counting_app/screen/count_screen.dart';
import 'package:stock_counting_app/utility/alert.dart';

class BU_Screen extends StatefulWidget {
  const BU_Screen({super.key, required this.token, required this.userName});
  final String? token;
  final String? userName;
  @override
  State<BU_Screen> createState() => _BU_ScreenState();
}

class _BU_ScreenState extends State<BU_Screen> {
  final formKey = GlobalKey<FormState>();
  late Future<List<Drugs>> BU_List;
  BU_Detail BU = BU_Detail("", "", "");

  @override
  void initState() {
    // TODO: implement initState
    BU_List = GetBU();
    super.initState();
  }

  Future<List<Drugs>> GetBU() async {
    late List<Drugs> _drugsMaster;
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${widget.token}',
      'Cookie':
          'refreshToken=p%2BBKUP28N7C%2BrTHUlBMM%2FUPeHg55hQD7KmLkNLZrduo%3D'
    };
    var request = http.Request(
        'GET', Uri.parse('https://edrug-uat.princhealth.com/api/drugs'));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    var Response = await http.Response.fromStream(response);
    if (response.statusCode == 200) {
      _drugsMaster = drugsFromJson(Response.body);
      //print(await Response.body);
    } else {
      //_faillogin = failloginFromJson(Response.body);
    }
    return _drugsMaster;
  }

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
                              Icons.logout,
                              color: Colors.white,
                              size: 25,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text("Logout",
                                style: GoogleFonts.prompt(
                                    fontSize: 20, color: Colors.white)),
                          ],
                        ),
                      ),
                    ];
                  },
                  onSelected: (value) {
                    if (value == 0) {
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
                        child: Text(
                          "User Name",
                          style: GoogleFonts.prompt(
                              fontSize: 20,
                              color: Color.fromARGB(255, 1, 57, 83)),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                          //                    <--- top side
                          color: Colors.grey,
                          width: 1.0,
                        ))),
                        child: Text(
                          "${widget.userName}",
                          style: GoogleFonts.prompt(fontSize: 18),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        child: Text(
                          "Document No.",
                          style: GoogleFonts.prompt(
                              fontSize: 20,
                              color: Color.fromARGB(255, 1, 57, 83)),
                        ),
                      ),
                      DropdownSearch<Drugs>(
                        autoValidateMode: AutovalidateMode.onUserInteraction,
                        popupProps: PopupProps.dialog(
                            showSearchBox: true), // Popup search
                        asyncItems: (filter) => BU_List, //GetBU(filter),
                        itemAsString: (Drugs? u) =>
                            u?.genericName ?? "", //กำหนดฟิลล์ที่ต้องการให้เลือก

                        onChanged: (value) {
                          setState(() {
                            BU.DocNum = value!.code ?? "";
                            BU.BU = value.id ?? "";
                            BU.Warehouse = value.genericName ?? "";
                          });
                        },
                        dropdownDecoratorProps: DropDownDecoratorProps(
                            dropdownSearchDecoration: InputDecoration(
                                labelText: "Document No./BU/Warehose"),
                            baseStyle: GoogleFonts.prompt(fontSize: 18)),
                        validator: (value) {
                          if (value == null) {
                            return 'กรุณาเลือกเลขที่เอกสาร';
                          }
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        height: 80,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 177, 226, 248),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        //color: Color.fromARGB(255, 128, 210, 248),
                        child: SizedBox(
                          child: Text(
                            "BU : ${BU.BU}",
                            style: GoogleFonts.prompt(
                                fontSize: 20,
                                color: Color.fromARGB(255, 1, 57, 83)),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        height: 80,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 177, 226, 248),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: SizedBox(
                          child: Text(
                            "Warehouse : ${BU.Warehouse}",
                            style: GoogleFonts.prompt(
                                fontSize: 20,
                                color: Color.fromARGB(255, 1, 57, 83)),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton.icon(
                          label: Text(
                            "ยืนยัน",
                            style: GoogleFonts.prompt(
                                fontSize: 20, color: Colors.white),
                          ),
                          icon: Icon(
                            Icons.check_rounded,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            if (formKey.currentState?.validate() == true) {
                              formKey.currentState?.save();

                              if (widget.token != "") {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return CountScan(
                                    token: widget.token,
                                    userName: widget.userName,
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
