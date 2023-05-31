//import 'dart:js_util';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:stock_counting_app/model/itemMaster.dart';
import 'package:stock_counting_app/model/stockOnhand.dart';
import 'package:stock_counting_app/model/successlogin.dart';
import 'package:stock_counting_app/providers/batch_provider.dart';
import 'package:stock_counting_app/screen/addbatch.dart';
import 'package:stock_counting_app/screen/bu_screen.dart';
import 'package:stock_counting_app/screen/counting_view.dart';
import 'package:provider/provider.dart';
import 'package:stock_counting_app/services/api.dart';
import 'package:stock_counting_app/services/store.dart';

import 'package:stock_counting_app/utility/alert.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qrscan/qrscan.dart' as scanner;

import 'package:http/http.dart' as http;
import 'package:stock_counting_app/model/bu_detail.dart';
import 'dart:convert' as json;
import 'dart:io';
import 'dart:async';

import 'package:stock_counting_app/model/bu_detail.dart';
import 'package:motion_tab_bar_v2/motion-badge.widget.dart';
import 'package:motion_tab_bar_v2/motion-tab-bar.dart';
import 'package:motion_tab_bar_v2/motion-tab-item.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:uuid/uuid.dart';

class Scan_Item extends StatefulWidget {
  const Scan_Item({super.key, required this.bu_detail
      //, required this.token
      });
  final BU_Detail bu_detail;
  //final String? token;
  @override
  State<Scan_Item> createState() => _Scan_ItemState();
}

class _Scan_ItemState extends State<Scan_Item> {
  final TextEditingController textController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  ItemMaster itemMaster = new ItemMaster();
  late Future<List<StockOnhand>> Batch_List;

  final StockOnhand batch_detail = StockOnhand();
  late List<StockOnhand> List_StockOnhand = [];
  late int? countItem = 0;
  late String? internalToken;

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  /*Future<ItemMaster> GetItemDetail(String itemCode) async {
    ItemMaster _ItemMaster = ItemMaster();
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${widget.token}',
      'Cookie':
          'refreshToken=p%2BBKUP28N7C%2BrTHUlBMM%2FUPeHg55hQD7KmLkNLZrduo%3D'
    };
    var request = http.Request(
        'GET',
        Uri.parse(
            'https://inventory-uat.princhealth.com/api/itemmasters/${itemCode}'));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    var Response = await http.Response.fromStream(response);
    if (response.statusCode == 200) {
      _ItemMaster = itemMasterFromJson(Response.body);
      setState(() {
        itemMaster = _ItemMaster;
      });
    } else {
      //_faillogin = failloginFromJson(Response.body);
      _ItemMaster.code = "";
      _ItemMaster.name = "";
      _ItemMaster.uomCode = "";
      showAlertDialog(context, "Item not found.");
      setState(() {
        itemMaster.code = "";
        itemMaster.name = "";
        itemMaster.uomCode = "";
      });
    }
    return _ItemMaster;
  }*/

  /*Future<List<StockOnhand>> GetBatchList(String itemCode) async {
    late List<StockOnhand> _StockOnhand;
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${widget.token ?? internalToken}',
      'Cookie':
          'refreshToken=p%2BBKUP28N7C%2BrTHUlBMM%2FUPeHg55hQD7KmLkNLZrduo%3D'
    };
    /*var request = http.Request(
        'GET',
        Uri.parse(
            'https://inventory-uat.princhealth.com/api/stockcounts/onhandsbyitem/${widget.bu_detail.id}?ItemCode=${itemCode}'));*/
    var request = http.Request(
        'GET',
        Uri.parse(
            'https://inventory-uat.princhealth.com/api/stockcounts/${widget.bu_detail.id}/item?ItemCode=${itemCode}'));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    var Response = await http.Response.fromStream(response);
    if (response.statusCode == 200) {
      _StockOnhand = stockOnhandFromJson(Response.body);
      setState(() {
        List_StockOnhand = _StockOnhand;
        if (_StockOnhand.length != 0) {
          itemMaster.code = List_StockOnhand[0].itemCode;
          itemMaster.name = List_StockOnhand[0].itemName;
          itemMaster.uomCode = List_StockOnhand[0].uomCode;
          Batch_Provider provider =
              Provider.of<Batch_Provider>(context, listen: false);
          provider.addBatchStockOnhand(_StockOnhand);
        } else {
          itemMaster.code = "";
          itemMaster.name = "";
          itemMaster.uomCode = "";
          Batch_Provider provider =
              Provider.of<Batch_Provider>(context, listen: false);
          provider.ClearBatchStockOnhand(
              itemMaster.code!, itemMaster.name!, itemMaster.uomCode!);
          if (itemCode != "") {
            showAlertDialog(context, "Item not found in this Document.");
          }
        }
      });
    } else if (response.statusCode == 401) {
      //String test = Response.body;
    }
    return _StockOnhand;
  }*/

  /*Future<String> AddStockActual(StockOnhand _stockOnhand) async {
    ItemMaster _ItemMaster = ItemMaster();
    String result = "";
    var uuid = Uuid();
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${widget.token}',
      'Cookie':
          'refreshToken=p%2BBKUP28N7C%2BrTHUlBMM%2FUPeHg55hQD7KmLkNLZrduo%3D'
    };
    var request = http.Request(
        'POST',
        Uri.parse(
            'https://inventory-uat.princhealth.com/api/stockcounts/createactual'));
    request.body = json.jsonEncode({
      "id": "${uuid.v4()}",
      "onhandId": "${_stockOnhand.id}",
      "countQty": _stockOnhand.countQty
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    var Response = await http.Response.fromStream(response);
    if (response.statusCode == 200) {
      result = "success";
    } else {
      showAlertDialog(context, "Add Stock Actual fail.");
      result = "fail";
    }
    return result;
  }*/

  final api = stockCountingAPI();
  @override
  void initState() {
    // TODO: implement initState
    itemMaster.code = "";
    itemMaster.name = "";
    itemMaster.uomCode = "";
    batch_detail.qty = 0;
    batch_detail.binLoc = "";
    batch_detail.countQty = 0;
    Batch_List = api.GetBatchList(widget.bu_detail.id, "");
    ConvertList();
    //Batch_List = GetBatchList("");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: formKey,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              alignment: Alignment.center,
              child: Text(
                  "${widget.bu_detail.buCode} - ${widget.bu_detail.whsCode}",
                  style: GoogleFonts.prompt(
                      fontSize: 40, color: Color.fromARGB(255, 1, 68, 122))),
            ),
            SizedBox(
              height: 10,
            ),
            Text("Item QR/Barcode",
                style: GoogleFonts.prompt(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Color.fromARGB(255, 1, 57, 83))),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    child: TextFormField(
                  controller: textController,
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Scan Item',
                  ),
                  validator: RequiredValidator(errorText: "Please Scan Item."),
                  onEditingComplete: () {
                    setState(() {
                      if (textController.text != "") {
                        //Batch_List = GetBatchList(textController.text);
                        Batch_List = api.GetBatchList(
                            widget.bu_detail.id, textController.text);
                        if (Batch_List != null) {
                          ConvertList(); // แปลงจาก Future List เป็น List
                          Future.delayed(const Duration(
                                  seconds:
                                      1)) //Delay ให้ข้อมูล Future เป็น List ธรรมดา
                              .then((val) {
                            setState(() {
                              if (List_StockOnhand.length != 0) {
                                itemMaster.code = List_StockOnhand[0].itemCode;
                                itemMaster.name = List_StockOnhand[0].itemName;
                                itemMaster.uomCode =
                                    List_StockOnhand[0].uomCode;
                                itemMaster.location =
                                    List_StockOnhand[0].binLoc;
                                Batch_Provider provider =
                                    Provider.of<Batch_Provider>(context,
                                        listen: false);
                                provider.addBatchStockOnhand(List_StockOnhand);
                              } else {
                                showAlertDialog(context,
                                    "Item not found in this Document.");
                              }
                            });
                          });
                        }
                      } else {
                        itemMaster.code = "";
                        itemMaster.name = "";
                        itemMaster.uomCode = "";
                        itemMaster.location = "";
                      }
                    });
                  },
                )),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 8, 18),
                  child: IconButton(
                    alignment: Alignment.topCenter,
                    onPressed: startScan,
                    icon: Icon(
                      Icons.qr_code_scanner,
                      color: Colors.black,
                      size: 50,
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              child: Text(
                "Item Name : ",
                style: GoogleFonts.prompt(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Color.fromARGB(255, 1, 57, 83)),
              ),
            ),
            SizedBox(
              child: Text(
                "${itemMaster.name}",
                style: GoogleFonts.prompt(fontSize: 20, color: Colors.black),
              ),
            ),
            SizedBox(
              child: Text(
                "Location : ${batch_detail.binLoc}",
                style: GoogleFonts.prompt(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Color.fromARGB(255, 1, 57, 83)),
              ),
            ),
            Row(
              children: [
                SizedBox(
                  child: Text(
                    "Base Uom : ",
                    style: GoogleFonts.prompt(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Color.fromARGB(255, 1, 57, 83)),
                  ),
                ),
                SizedBox(
                  child: Text(
                    "${itemMaster.uomCode}",
                    style:
                        GoogleFonts.prompt(fontSize: 20, color: Colors.black),
                  ),
                ),
              ],
            ),
            SizedBox(
              child: Text(
                "Batch",
                style: GoogleFonts.prompt(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Color.fromARGB(255, 1, 57, 83)),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: DropdownSearch<StockOnhand>(
                    //autoValidateMode: AutovalidateMode.onUserInteraction,
                    popupProps: PopupProps.dialog(
                      showSearchBox: true,
                      searchFieldProps: TextFieldProps(
                          decoration: InputDecoration(labelText: "Search...")),
                    ), // Popup search

                    asyncItems: (filter) => Batch_List, //GetBU(filter),

                    itemAsString: (StockOnhand? u) =>
                        u?.batchId ?? "", //กำหนดฟิลล์ที่ต้องการให้เลือก

                    onChanged: (value) {
                      setState(() {
                        batch_detail.id = value!.id;
                        batch_detail.qty = value.qty;
                        batch_detail.countQty = value.countQty;
                        countItem = batch_detail.countQty;
                        if (value.binLoc != null) {
                          batch_detail.binLoc = value.binLoc;
                        } else {
                          batch_detail.binLoc = "";
                        }
                      });
                    },

                    dropdownDecoratorProps: DropDownDecoratorProps(
                        dropdownSearchDecoration:
                            InputDecoration(labelText: "Batch"),
                        baseStyle: GoogleFonts.prompt(fontSize: 18)),
                    validator: (value) {
                      if (value == null) {
                        return 'Please select Batch.';
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 8, 18),
                  child: IconButton(
                    alignment: Alignment.topCenter,
                    onPressed: () {
                      if (itemMaster.code != "") {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return AddBatch(
                            //token: widget.token,
                            itemCode: itemMaster.code,
                            stockID: widget.bu_detail.id,
                            bu_detail: widget.bu_detail,
                          );
                        }));
                      } else {
                        if (itemMaster.code == "") {
                          showAlertDialog(context, "Item Code is not null");
                        }
                      }
                    },
                    icon: Icon(
                      Icons.add_box_rounded,
                      color: Color.fromARGB(255, 242, 233, 58),
                      size: 50,
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                SizedBox(
                  child: Text(
                    "Onhand : ",
                    style: GoogleFonts.prompt(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Color.fromARGB(255, 1, 57, 83)),
                  ),
                ),
                SizedBox(
                  child: Text(
                    "${batch_detail.qty}",
                    style:
                        GoogleFonts.prompt(fontSize: 20, color: Colors.black),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              children: [
                SizedBox(
                  child: Text(
                    "Counted : ",
                    style: GoogleFonts.prompt(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Color.fromARGB(255, 1, 57, 83)),
                  ),
                ),
                SizedBox(
                  child: Text(
                    "${countItem}",
                    style:
                        GoogleFonts.prompt(fontSize: 20, color: Colors.black),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                SizedBox(
                  child: Text(
                    "Count :",
                    style: GoogleFonts.prompt(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Color.fromARGB(255, 1, 57, 83)),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: SizedBox(
                  height: 50,
                  child: TextFormField(
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Count Item',
                    ),
                    //validator:
                    //RequiredValidator(errorText: "Please Enter Count Qty."),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please Enter Count.";
                      } else if (double.parse(value).toInt() <= 0) {
                        return "Count should be greater than 0";
                      }
                    },
                    keyboardType: TextInputType.number,
                    onSaved: (countItem1) {
                      setState(() {
                        countItem = countItem! + int.parse(countItem1!);
                      });

                      batch_detail.countQty = int.parse(countItem1!);
                    },
                  ),
                ))
              ],
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                label: Text(
                  "Save",
                  style: GoogleFonts.prompt(fontSize: 20, color: Colors.white),
                ),
                icon: Icon(
                  Icons.save,
                  color: Colors.white,
                ),
                onPressed: () {
                  if (formKey.currentState?.validate() == true) {
                    formKey.currentState?.save();
                    api.AddStockActual(batch_detail).then((result) {
                      if (result == "success") {
                        print(result);
                        api.GetBatchList(
                            widget.bu_detail.id, textController.text);
                        setState(() {
                          //batch_detail.countQty =
                          //batch_detail.countQty! + countItem!;
                        });
                        formKey.currentState?.reset();
                      } else if (result == "fail") {
                        showAlertDialog(context, "Add Stock Actual fail.");
                      }
                    });

                    //formKey.currentState?.reset();
                  }
                },
              ),
            )
          ]),
        ),
      ),
    );
  }

  startScan() async {
    String ttt = scanner.CameraAccessDenied;
    String? cameraScanResult = await scanner.scan();
    textController.text = cameraScanResult ?? "";
    setState(() {
      //textController.text = cameraScanResult ?? "";
      //GetItemDetail(textController!.text);
      Batch_List = api.GetBatchList(widget.bu_detail.id, textController.text);
    });
  }

  void ConvertList() async {
    List_StockOnhand = await Batch_List;
  }
}
