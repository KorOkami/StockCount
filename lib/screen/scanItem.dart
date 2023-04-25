//import 'dart:js_util';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:stock_counting_app/model/itemMaster.dart';
import 'package:stock_counting_app/model/stockOnhand.dart';
import 'package:stock_counting_app/providers/batch_provider.dart';
import 'package:stock_counting_app/screen/addbatch.dart';
import 'package:stock_counting_app/screen/bu_screen.dart';
import 'package:stock_counting_app/screen/counting_view.dart';
import 'package:provider/provider.dart';

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
  const Scan_Item({super.key, required this.bu_detail, required this.token});
  final BU_Detail bu_detail;
  final String? token;
  @override
  State<Scan_Item> createState() => _Scan_ItemState();
}

class _Scan_ItemState extends State<Scan_Item> {
  TextEditingController textController = TextEditingController();
  TextEditingController? _textEditingController;
  final formKey = GlobalKey<FormState>();
  ItemMaster itemMaster = ItemMaster();
  late Future<List<StockOnhand>> Batch_List;
  final StockOnhand batch_detail = StockOnhand();
  late List<StockOnhand> List_StockOnhand;

  Future<ItemMaster> GetItemDetail(String itemCode) async {
    ItemMaster _ItemMaster = ItemMaster();
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${widget.token}',
      'Cookie':
          'refreshToken=p%2BBKUP28N7C%2BrTHUlBMM%2FUPeHg55hQD7KmLkNLZrduo%3D'
    };
    var request = http.Request('GET',
        Uri.parse('http://172.24.9.24:5000/api/itemmasters/${itemCode}'));
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
  }

  Future<List<StockOnhand>> GetBatchList(String itemCode) async {
    late List<StockOnhand> _StockOnhand;
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${widget.token}',
      'Cookie':
          'refreshToken=p%2BBKUP28N7C%2BrTHUlBMM%2FUPeHg55hQD7KmLkNLZrduo%3D'
    };
    var request = http.Request(
        'GET',
        Uri.parse(
            'http://172.24.9.24:5000/api/stockcounts/onhandsbyitem/328ab602-f0ac-49b0-9c65-0b8995140983?ItemCode=${itemCode}'));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    var Response = await http.Response.fromStream(response);
    if (response.statusCode == 200) {
      _StockOnhand = stockOnhandFromJson(Response.body);
      //List_StockOnhand = await _StockOnhand;
      if (_StockOnhand.length != 0) {
        Batch_Provider provider =
            Provider.of<Batch_Provider>(context, listen: false);
        provider.addBatchStockOnhand(_StockOnhand);
      }
    } else {
      //_faillogin = failloginFromJson(Response.body);
    }
    return _StockOnhand;
  }

  Future<String> AddStockActual(StockOnhand _stockOnhand) async {
    ItemMaster _ItemMaster = ItemMaster();
    String result = "";
    var uuid = Uuid();
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${widget.token}',
      'Cookie':
          'refreshToken=p%2BBKUP28N7C%2BrTHUlBMM%2FUPeHg55hQD7KmLkNLZrduo%3D'
    };
    var request = http.Request('POST',
        Uri.parse('http://172.24.9.24:5000/api/stockcounts/createactual'));
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
  }

  @override
  void initState() {
    // TODO: implement initState
    itemMaster.code = "";
    itemMaster.name = "";
    itemMaster.uomCode = "";
    batch_detail.qty = 0;
    batch_detail.binLoc = "";
    batch_detail.countQty = 0;
    Batch_List = GetBatchList("");
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
                    autoValidateMode: AutovalidateMode.onUserInteraction,
                    popupProps:
                        PopupProps.dialog(showSearchBox: true), // Popup search

                    asyncItems: (filter) => Batch_List, //GetBU(filter),

                    itemAsString: (StockOnhand? u) =>
                        u?.batchId ?? "", //กำหนดฟิลล์ที่ต้องการให้เลือก

                    onChanged: (value) {
                      setState(() {
                        batch_detail.id = value!.id;
                        batch_detail.qty = value.qty;
                        batch_detail.countQty = value.countQty;
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
                /*Expanded(
                        child: SizedBox(
                      height: 50,
                      child: TextFormField(
                        style: TextStyle(fontSize: 20),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Batch No.',
                        ),
                      ),
                    )),*/
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 8, 18),
                  child: IconButton(
                    alignment: Alignment.topCenter,
                    onPressed: () {
                      if (widget.token != "") {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return AddBatch(
                            token: widget.token,
                            itemCode: itemMaster.code,
                            stockID: widget.bu_detail.id,
                            bu_detail: widget.bu_detail,
                          );
                        }));
                        //GetItemDetail(textController.text);
                      } else {
                        /*print(result?.ErrorM);
                                                  showAlertDialog(
                                                      context, result?.ErrorM);*/
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
                    "${batch_detail.countQty}",
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
                    validator:
                        RequiredValidator(errorText: "Please Enter Count Qty."),
                    keyboardType: TextInputType.number,
                    onSaved: (countItem) {
                      batch_detail.countQty = int.parse(countItem!);
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
                  "Submit",
                  style: GoogleFonts.prompt(fontSize: 20, color: Colors.white),
                ),
                icon: Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                ),
                onPressed: () {
                  if (formKey.currentState?.validate() == true) {
                    formKey.currentState?.save();
                    AddStockActual(batch_detail).then((result) {
                      if (result == "success") {
                        //showAddBatch_AlertDialog(context);
                      } else if (result == "fail") {}
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

    setState(() {
      textController.text = cameraScanResult ?? "";
      GetItemDetail(textController.text);
      Batch_List = GetBatchList(textController.text);
    });
  }
}
