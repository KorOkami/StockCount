import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';
import 'package:stock_counting_app/components/text_field_container.dart';
import 'package:stock_counting_app/model/bu_detail.dart';
import 'package:stock_counting_app/model/itemMaster.dart';
import 'package:stock_counting_app/model/registerResponse.dart';
import 'package:stock_counting_app/model/register_detail.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as json;
import 'dart:io';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:stock_counting_app/screen/count_screen.dart';
import 'package:stock_counting_app/screen/scanItem.dart';
import 'package:stock_counting_app/services/api.dart';
import 'package:stock_counting_app/utility/alert.dart';
import 'package:stock_counting_app/model/stockOnhand.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/cupertino.dart';

class AddBatch extends StatefulWidget {
  const AddBatch({super.key, required this.token, required this.itemCode, required this.stockID, required this.bu_detail, this.userName, required this.itemMaster});
  final String? token;
  final String? itemCode;
  final String? stockID;
  final BU_Detail bu_detail;
  final String? userName;
  final ItemMaster itemMaster;
  @override
  State<AddBatch> createState() => _AddBatchState();
}

class _AddBatchState extends State<AddBatch> {
  final formKey = GlobalKey<FormState>();
  Batch addBatch = Batch();
  TextEditingController dateController = TextEditingController();
  StockOnhand stockOnhand = StockOnhand();
  String? res;
  bool flagSaveDate = true;
  String? _currentDate = "";
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    stockOnhand.stockcountid = widget.stockID;
    stockOnhand.itemCode = widget.itemCode;
    res = "";
    super.initState();
  }

  final api = stockCountingAPI();

  /*Future<String> AddBatchExpire(StockOnhand _stockOnhand, Batch batch) async {
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
            'https://inventory-uat.princhealth.com/api/stockcounts/createonhand'));
    request.body = json.jsonEncode({
      "id": "${uuid.v4()}",
      "stockCountId": "${_stockOnhand.stockcountid}",
      "lineNum": 0,
      "itemCode": "${_stockOnhand.itemCode}",
      "batchID": "${batch.batchNumber}",
      "expiryDate": "${batch.epireDate}",
      "qty": 0,
      "uomCode": "",
      "binLoc": ""
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    var Response = await http.Response.fromStream(response);
    if (response.statusCode == 200) {
      result = "success";
    } else {
      showAlertDialog(context, "Add Batch Failed.");
      result = "fail";
    }
    return result;
  }*/

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Add Batch/Expire",
            style: GoogleFonts.prompt(fontSize: 25, color: Colors.white),
          ),
          //automaticallyImplyLeading: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            //onPressed: () => Navigator.of(context).pop(),
            onPressed: () {
              if (res == "success") {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return CountScan(
                    token: widget.token,
                    userName: widget.userName,
                    bu_detail: widget.bu_detail,
                    itemCode: widget.itemCode,
                    itemMaster: widget.itemMaster,
                  );
                }));
              } else {
                Navigator.of(context).pop();
              }
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                // Text("Batch :",
                //     style: GoogleFonts.prompt(fontSize: 20, color: Colors.black)),
                SizedBox(
                  height: 5,
                ),
                TextFormFieldContainerRegister(
                  colors: Color.fromARGB(255, 217, 242, 253),
                  child: TextFormField(
                    style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 1, 103, 166)),
                    decoration: InputDecoration(
                      suffixIcon: Icon(
                        Icons.keyboard,
                        size: 30,
                      ),
                      border: InputBorder.none,
                      labelText: 'Batch',
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: RequiredValidator(errorText: "Please Enter Batch"),
                    onSaved: (batchNo) {
                      addBatch.batchNumber = batchNo ?? "";
                    },
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  child: TextFormFieldContainerRegister(
                    colors: Color.fromARGB(255, 217, 242, 253),
                    child: TextFormField(
                      style: GoogleFonts.prompt(fontSize: 20, color: Color.fromARGB(255, 1, 57, 83)),
                      //controller: dateController, //editing controller of this TextField
                      controller: flagSaveDate == false ? TextEditingController(text: "") : TextEditingController(text: _currentDate),
                      autovalidateMode: AutovalidateMode.always,
                      validator: RequiredValidator(errorText: "Please select Date"),
                      decoration: InputDecoration(
                        labelText: "Expire Date",
                        //contentPadding: EdgeInsets.zero,
                        border: InputBorder.none,
                        suffixIcon: IconButton(
                          onPressed: () {
                            _showDialog(
                              CupertinoDatePicker(
                                initialDateTime: DateTime.now(),
                                mode: CupertinoDatePickerMode.date,
                                minimumYear: 1990,
                                maximumYear: 2100,
                                dateOrder: DatePickerDateOrder.dmy,
                                onDateTimeChanged: (DateTime newDate) {
                                  //setState(() => date = newDate);
                                  setState(() {
                                    String formattedDate = DateFormat('dd-MM-yyyy').format(newDate);
                                    String SendformattedDate = DateFormat('yyyy-MM-dd').format(newDate);
                                    flagSaveDate = true;
                                    _currentDate = formattedDate;
                                    addBatch.epireDate = SendformattedDate;
                                  });
                                },
                              ),
                            );
                            /*showModalBottomSheet<void>(
                              context: context,
                              builder: (BuildContext context) {
                                return SizedBox(
                                  height: 200,
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        SizedBox(
                                          height: 200,
                                          child: ScrollDatePicker(
                                            viewType: const [
                                              DatePickerViewType.day,
                                              DatePickerViewType.month,
                                              DatePickerViewType.year,
                                            ],
                                            minimumDate: DateTime(2000),
                                            maximumDate: DateTime(2101),
                                            selectedDate: _selectedDate,
                                            options: DatePickerOptions(itemExtent: 35, diameterRatio: 5),
                                            scrollViewOptions: const DatePickerScrollViewOptions(day: ScrollViewDetailOptions(textStyle: TextStyle(fontSize: 22), selectedTextStyle: TextStyle(fontSize: 22), alignment: Alignment.center, margin: EdgeInsets.only(right: 12)), month: ScrollViewDetailOptions(alignment: Alignment.center, selectedTextStyle: TextStyle(fontSize: 22), textStyle: TextStyle(fontSize: 22)), year: ScrollViewDetailOptions(textStyle: TextStyle(fontSize: 22), selectedTextStyle: TextStyle(fontSize: 22), margin: EdgeInsets.only(left: 18))),
                                            onDateTimeChanged: (DateTime value) {
                                              setState(() {
                                                _selectedDate = value;
                                                String formattedDate = DateFormat('dd-MM-yyyy').format(value);
                                                String SendformattedDate = DateFormat('yyyy-MM-dd').format(value);
                                                flagSaveDate = true;
                                                _currentDate = formattedDate;
                                                addBatch.epireDate = SendformattedDate;
                                              });
                                            },
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );*/
                          },
                          icon: Icon(
                            Icons.calendar_today,
                            color: Colors.black,
                          ),
                        ), //icon of text field
                        // labelText: "Select Date",
                        //labelStyle: TextStyle(fontSize: 25)
                      ),
                      readOnly: true, // when true user cannot edit text
                      // onTap: () async {
                      //   //when click we have to show the datepicker
                      //   DateTime? pickedDate = await showDatePicker(
                      //       initialEntryMode: DatePickerEntryMode.calendarOnly,
                      //       context: context,
                      //       initialDate: DateTime.now(), //get today's date
                      //       firstDate: DateTime(2000), //DateTime.now() - not to allow to choose before today.
                      //       lastDate: DateTime(2101));
                      //   setState(() {
                      //     if (pickedDate != null) {
                      //       String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
                      //       String SendformattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                      //       flagSaveDate = true;
                      //       _currentDate = formattedDate;
                      //       addBatch.epireDate = SendformattedDate;
                      //     }
                      //   });
                      // },
                      // onSaved: (newValue) {
                      //   dateController.text = newValue!;
                      // },
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
                      "Save",
                      style: GoogleFonts.prompt(fontSize: 20, color: Colors.white),
                    ),
                    icon: Icon(
                      Icons.save,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () {
                      if (formKey.currentState?.validate() == true) {
                        formKey.currentState?.save();
                        api.checktoken().then((result) {
                          if (result == "success") {
                            api.AddBatchExpire(stockOnhand, addBatch).then((result) {
                              if (result?.status == "success") {
                                setState(() {
                                  res = result?.status;
                                  flagSaveDate = false;
                                  FocusManager.instance.primaryFocus?.unfocus();
                                });
                                showAddBatch_AlertDialog(context);
                                formKey.currentState?.reset();
                              } else if (result?.status == "fail") {
                                showAlertDialog(context, result?.ErrorM);
                              }
                            });
                          } else {
                            showDisconnect_AlertDialog(context, result);
                          }
                        });
                      }
                    },
                  ),
                )
              ]),
            ),
          ),
        ),
      ),
    );
  }

  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        // The Bottom margin is provided to align the popup above the system
        // navigation bar.
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        // Provide a background color for the popup.
        color: CupertinoColors.systemBackground.resolveFrom(context),
        // Use a SafeArea widget to avoid system overlaps.
        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
    );
  }
}
