import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:stock_counting_app/model/itemMaster.dart';
import 'package:stock_counting_app/screen/count_screen.dart';
import 'package:stock_counting_app/services/api.dart';
import 'package:stock_counting_app/utility/alert.dart';

import '../components/text_field_container.dart';
import 'package:flutter/services.dart';

import 'package:flutter/cupertino.dart';

class AddItem extends StatefulWidget {
  const AddItem({
    super.key,
    required this.batchControl,
    required this.stockID,
  });
  final String? batchControl;
  final String? stockID;

  @override
  State<AddItem> createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  final TextEditingController textController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  Batch addBatch = Batch();
  bool showAddBatch = true;
  final formKey = GlobalKey<FormState>();
  late Future<ItemMaster> fItemMaster;
  ItemMaster _ItemMaster = ItemMaster();
  String? res;
  bool flagSave = true;
  bool flagSaveDate = true;
  String? _currentItemValue = "";
  String? _currentDate = "";
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.batchControl == "N") {
      showAddBatch = false;
    }
    _ItemMaster = ItemMaster();
    _ItemMaster.code = "";
    _ItemMaster.name = "";
    _ItemMaster.uomCode = "";
    _ItemMaster.location = "";
  }

  final api = stockCountingAPI();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return true; //ป้องการกดปุ่มยอนกลับบน mobile
        },
        child: GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
            //flagSave = true;
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                "Add Item",
                style: GoogleFonts.prompt(fontSize: 25, color: Colors.white),
              ),
              automaticallyImplyLeading: true,
              leading: const BackButton(
                color: Colors.white,
              ),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Item QR/Barcode", style: GoogleFonts.prompt(fontWeight: FontWeight.bold, fontSize: 20, color: Color.fromARGB(255, 1, 57, 83))),
                      SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        // controller: textController,
                        controller: flagSave == false ? TextEditingController(text: "") : TextEditingController(text: _currentItemValue),
                        style: TextStyle(fontSize: 20),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Scan new item',
                            suffixIcon: IconButton(
                              onPressed: () => barcodeScan(),
                              //onPressed: () {},
                              icon: Icon(
                                Icons.qr_code_scanner,
                                color: Colors.grey,
                              ),
                              iconSize: 40,
                            )),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: RequiredValidator(errorText: "Please Scan Item."),
                        onChanged: (value) {
                          _currentItemValue = value;
                          flagSave = true;
                        },
                        onEditingComplete: () {
                          if (_currentItemValue != "") {
                            api.checktoken().then((result) {
                              if (result == "success") {
                                api.GetItemMaster(_currentItemValue!).then((value) {
                                  _ItemMaster = value;
                                  setState(() {
                                    if (_ItemMaster.name == "") {
                                      showAlertDialog(context, "No Items found.");
                                    }
                                  });
                                });
                              } else {
                                showDisconnect_AlertDialog(context, result);
                              }
                            });

                            // fItemMaster = api.GetItemMaster(_currentItemValue!);
                            // if (fItemMaster != null) {
                            //   ConvertItem();
                            //   Future.delayed(const Duration(seconds: 1)) //Delay ให้ข้อมูล Future เป็น List ธรรมดา
                            //       .then((val) {
                            //     setState(() {
                            //       if (_ItemMaster.name == "") {
                            //         showAlertDialog(context, "No Items found.");
                            //       }
                            //     });
                            //   });
                            // }
                          } else {
                            setState(() {
                              _ItemMaster.code = "";
                              _ItemMaster.name = "";
                              _ItemMaster.uomCode = "";
                              _ItemMaster.location = "";
                            });
                            showAlertDialog(context, "No Items found.");
                          }
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        child: Text(
                          "Item Name : ",
                          style: GoogleFonts.prompt(fontWeight: FontWeight.bold, fontSize: 20, color: Color.fromARGB(255, 1, 57, 83)),
                        ),
                      ),
                      SizedBox(
                        child: Text(
                          "${_ItemMaster.name}",
                          style: GoogleFonts.prompt(fontSize: 20, color: Colors.black),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            child: Text(
                              "Base Uom : ",
                              style: GoogleFonts.prompt(fontWeight: FontWeight.bold, fontSize: 20, color: Color.fromARGB(255, 1, 57, 83)),
                            ),
                          ),
                          SizedBox(
                            child: Text(
                              "${_ItemMaster.uomCode == null ? "" : _ItemMaster.uomCode}",
                              style: GoogleFonts.prompt(fontSize: 20, color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Visibility(
                        visible: showAddBatch,
                        child: Column(
                          children: [
                            Container(
                              child: TextFormFieldContainerRegister(
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
                                                // widthFactor: 400,
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  //mainAxisSize: MainAxisSize.min,
                                                  children: <Widget>[
                                                    
                                                    /*SizedBox(
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
                                                        // locale: const Locale('th', 'TH'),
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
                                                    )*/
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
                                  onTap: () {
                                    //when click we have to show the datepicker
                                    // DateTime? pickedDate = await showDatePicker(
                                    //     initialEntryMode: DatePickerEntryMode.calendarOnly,
                                    //     context: context,
                                    //     initialDate: DateTime.now(), //get today's date
                                    //     firstDate: DateTime(2000), //DateTime.now() - not to allow to choose before today.
                                    //     lastDate: DateTime(2101));
                                    // setState(() {
                                    //   if (pickedDate != null) {
                                    //     String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
                                    //     String SendformattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                                    //     flagSaveDate = true;
                                    //     _currentDate = formattedDate;
                                    //     addBatch.epireDate = SendformattedDate;
                                    //   }
                                    // });
                                  },
                                ),
                              ),
                            ),
                          ],
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
                                  api.AddNewItem(widget.stockID ?? "", _currentItemValue!, addBatch).then((result) {
                                    if (result?.status == "success") {
                                      setState(() {
                                        res = result?.status;
                                        _ItemMaster.code = "";
                                        _ItemMaster.name = "";
                                        _ItemMaster.uomCode = "";
                                        flagSave = false;
                                        flagSaveDate = false;
                                        FocusManager.instance.primaryFocus?.unfocus();
                                      });
                                      showAddNewItem_AlertDialog(context);
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
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  void ConvertItem() async {
    _ItemMaster = await fItemMaster;
  }

  String _scanBarcode = 'Unknown';
  Future<void> barcodeScan() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode('#ff6666', 'Cancel', true, ScanMode.QR);
      //print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    if (!mounted) return;
    setState(() {
      if (barcodeScanRes != "-1") {
        _scanBarcode = barcodeScanRes;
        textController.text = barcodeScanRes;
        _currentItemValue = barcodeScanRes;
        if (textController.text != "") {
          // fItemMaster = api.GetItemMaster(_currentItemValue!);
          // if (fItemMaster != null) {
          //   ConvertItem();
          //   Future.delayed(const Duration(seconds: 1)) //Delay ให้ข้อมูล Future เป็น List ธรรมดา
          //       .then((val) {
          //     setState(() {
          //       if (_ItemMaster.name == "") {
          //         showAlertDialog(context, "No Items found.");
          //       }
          //     });
          //   });
          // }
          api.checktoken().then((result) {
            api.getAccessToken().then((value) {
              String test = '';
            });
            if (result == "success") {
              api.GetItemMaster(_currentItemValue!).then((value) {
                setState(() {
                  _ItemMaster = value;
                  if (_ItemMaster.name == "") {
                    showAlertDialog(context, "No Items found.");
                  }
                });
              });
            } else {
              showDisconnect_AlertDialog(context, result);
            }
          });
        } else {
          _ItemMaster.code = "";
          _ItemMaster.name = "";
          _ItemMaster.uomCode = "";
          _ItemMaster.location = "";
          showAlertDialog(context, "No Items found.");
        }
      }
    });
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
