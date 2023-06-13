import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';
import 'package:stock_counting_app/model/bu_detail.dart';
import 'package:stock_counting_app/model/itemMaster.dart';
import 'package:stock_counting_app/model/stockOnhand.dart';
import 'package:stock_counting_app/providers/batch_provider.dart';
import 'package:stock_counting_app/screen/addbatch.dart';
import 'package:stock_counting_app/screen/bu_screen.dart';
import 'package:stock_counting_app/screen/counting_view.dart';
import 'package:stock_counting_app/screen/scanItem.dart';
import 'package:stock_counting_app/services/api.dart';

import 'package:stock_counting_app/utility/alert.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qrscan/qrscan.dart' as scanner;

import 'package:motion_tab_bar_v2/motion-badge.widget.dart';
import 'package:motion_tab_bar_v2/motion-tab-bar.dart';
import 'package:motion_tab_bar_v2/motion-tab-item.dart';
import 'package:intl/intl.dart';
import 'package:flutter_dynamic_calculator/flutter_dynamic_calculator.dart';

class CountScan extends StatefulWidget {
  const CountScan(
      {super.key,
      required this.token,
      required this.userName,
      required this.bu_detail,
      this.itemCode,
      required this.itemMaster});
  final String? token;
  final String? userName;
  final BU_Detail bu_detail;
  final String? itemCode;
  final ItemMaster itemMaster;

  @override
  State<CountScan> createState() => _CountScanState();
}

class _CountScanState extends State<CountScan> with TickerProviderStateMixin {
  final TextEditingController textController = TextEditingController();
  //late TextEditingController textCountController;
  TabController? _tabController;
  final formKey = GlobalKey<FormState>();
  late Future<List<StockOnhand>> Batch_List;
  late StockOnhand batch_detail = StockOnhand();
  late List<StockOnhand> List_StockOnhand = [];
  late ItemMaster itemMaster = new ItemMaster();
  late int? countItem = 0;
  late StockOnhand? _selectedItem = StockOnhand();
  late StockOnhand? _clearSelectedItem = StockOnhand();
  late int DropdownIndex = -1;
  ItemMaster? itm_detail;
  bool showAddBatchButton = true;
  bool DisableDropdowmBatch = false;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      initialIndex: 0,
      length: 2,
      vsync: this,
    );

    if (widget.bu_detail.controlLot == "N") {
      DropdownIndex = 0;
      showAddBatchButton = false;
      DisableDropdowmBatch = true;
    }
    if (widget.itemCode != "") {
      textController.text = widget.itemCode ?? "";
      itemMaster = widget.itemMaster;
      Batch_List = api.GetBatchList(widget.bu_detail.id, widget.itemCode ?? "");
    } else {
      Batch_List = api.GetBatchList(widget.bu_detail.id, "");
      itemMaster.code = "";
      itemMaster.name = "";
      itemMaster.uomCode = "";
      itemMaster.location = "";
      batch_detail.qty = 0;
      batch_detail.binLoc = "";
      batch_detail.countQty = 0;
    }

    ConvertList(); // แปลงจาก Future List เป็น List
    Future.delayed(const Duration(
            seconds: 1)) //Delay ให้ข้อมูล Future เป็น List ธรรมดา
        .then((val) {
      Batch_Provider provider =
          Provider.of<Batch_Provider>(context, listen: false);
      provider.addBatchStockOnhand(List_StockOnhand);
      if (List_StockOnhand.length != 0) {
        batch_detail.id = List_StockOnhand[0].id;
        itemMaster.code = List_StockOnhand[0].itemCode;
        itemMaster.name = List_StockOnhand[0].itemName;
        itemMaster.uomCode = List_StockOnhand[0].uomName;
        itemMaster.location = List_StockOnhand[0].binLoc;
      }
    });
  }

  final api = stockCountingAPI();
  @override
  void dispose() {
    super.dispose();
    _tabController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userStore = Provider.of<Batch_Provider>(context, listen: true);
    return Consumer<Batch_Provider>(
        builder: (context, Batch_Provider provider, Widget? child) {
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
                              Text("${widget.userName}",
                                  style: GoogleFonts.prompt(
                                      fontSize: 20, color: Colors.white)),
                            ],
                          ),
                        ),
                        PopupMenuItem<int>(
                          value: 1,
                          child: Row(
                            children: [
                              Icon(
                                Icons.home,
                                color: Colors.white,
                                size: 25,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text("Home",
                                  style: GoogleFonts.prompt(
                                      fontSize: 20, color: Colors.white)),
                            ],
                          ),
                        ),
                        PopupMenuItem<int>(
                          value: 2,
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
                      if (value == 1) {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return BU_Screen(
                            token: widget.token,
                            userName: widget.userName,
                          );
                        }));
                        setState(() {
                          DropdownIndex = -1;
                          Batch_List =
                              api.GetBatchList(widget.bu_detail.id, "");
                          ConvertList(); // แปลงจาก Future List เป็น List
                          Future.delayed(const Duration(
                                  seconds:
                                      1)) //Delay ให้ข้อมูล Future เป็น List ธรรมดา
                              .then((val) {
                            Batch_Provider provider =
                                Provider.of<Batch_Provider>(context,
                                    listen: false);
                            provider.addBatchStockOnhand(List_StockOnhand);
                          });
                        });
                      } else if (value == 2) {
                        showLogout_AlertDialog(context);
                      }
                    })),
            bottomNavigationBar: MotionTabBar(
              initialSelectedTab: "Count",
              useSafeArea: true, // default: true, apply safe area wrapper
              labels: const ["Count", "View"],
              icons: const [
                Icons.library_add_rounded,
                Icons.format_list_bulleted_rounded,
              ],
              tabIconColor: Colors.white,
              tabIconSize: 28.0,
              tabIconSelectedSize: 26.0,
              tabSelectedColor: Colors.black,
              tabIconSelectedColor: Colors.white,
              tabBarColor: Color.fromARGB(255, 5, 169, 239),
              onTabItemSelected: (int value) {
                setState(() {
                  _tabController!.index = value;
                });
              },
            ),
            body: TabBarView(
                physics:
                    NeverScrollableScrollPhysics(), // swipe navigation handling is not supported
                controller: _tabController,
                children: <Widget>[
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Form(
                        key: formKey,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                alignment: Alignment.center,
                                child: Text(
                                    "${widget.bu_detail.whsCode} - ${widget.bu_detail.buCode}",
                                    style: GoogleFonts.prompt(
                                        fontSize: 40,
                                        color:
                                            Color.fromARGB(255, 1, 68, 122))),
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
                                        suffixIcon: IconButton(
                                          onPressed: startScan,
                                          icon: Icon(
                                            Icons.qr_code_scanner,
                                            color: Colors.grey,
                                          ),
                                          iconSize: 40,
                                        )),
                                    validator: RequiredValidator(
                                        errorText: "Please Scan Item."),
                                    onEditingComplete: () {
                                      if (textController.text != "") {
                                        Batch_List = api.GetBatchList(
                                            widget.bu_detail.id,
                                            textController.text);
                                        if (Batch_List != null) {
                                          ConvertList(); // แปลงจาก Future List เป็น List
                                          Future.delayed(const Duration(
                                                  milliseconds:
                                                      500)) //Delay ให้ข้อมูล Future เป็น List ธรรมดา
                                              .then((val) {
                                            setState(() {
                                              if (widget.bu_detail.controlLot ==
                                                  "N") {
                                                DropdownIndex = 0;
                                              } else {
                                                DropdownIndex = -1;
                                              }

                                              if (List_StockOnhand.length !=
                                                  0) {
                                                batch_detail.id =
                                                    List_StockOnhand[0].id;
                                                itemMaster.code =
                                                    List_StockOnhand[0]
                                                        .itemCode;
                                                itemMaster.name =
                                                    List_StockOnhand[0]
                                                        .itemName;
                                                itemMaster.uomCode =
                                                    List_StockOnhand[0].uomName;
                                                itemMaster.location =
                                                    List_StockOnhand[0].binLoc;
                                                Batch_Provider provider =
                                                    Provider.of<Batch_Provider>(
                                                        context,
                                                        listen: false);
                                                provider.addBatchStockOnhand(
                                                    List_StockOnhand);
                                              } else {
                                                itemMaster.code = "";
                                                itemMaster.name = "";
                                                itemMaster.uomCode = "";
                                                itemMaster.location = "";
                                                batch_detail.qty = 0;
                                                countItem = 0;
                                                Batch_List = api.GetBatchList(
                                                    widget.bu_detail.id, "");
                                                ConvertList();
                                                Batch_Provider provider =
                                                    Provider.of<Batch_Provider>(
                                                        context,
                                                        listen: false);
                                                provider.addBatchStockOnhand(
                                                    List_StockOnhand);
                                                showAlertDialog(
                                                    context, "No Items found.");
                                              }
                                            });
                                          });
                                        }
                                      } else {
                                        setState(() {
                                          itemMaster.code = "";
                                          itemMaster.name = "";
                                          itemMaster.uomCode = "";
                                          itemMaster.location = "";
                                        });
                                      }
                                    },
                                  )),
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
                                  style: GoogleFonts.prompt(
                                      fontSize: 20, color: Colors.black),
                                ),
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    child: Text(
                                      "Location : ",
                                      style: GoogleFonts.prompt(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color:
                                              Color.fromARGB(255, 1, 57, 83)),
                                    ),
                                  ),
                                  SizedBox(
                                    child: Text(
                                      "${itemMaster.location}",
                                      style: GoogleFonts.prompt(
                                          fontSize: 20, color: Colors.black),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    child: Text(
                                      "Base Uom : ",
                                      style: GoogleFonts.prompt(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color:
                                              Color.fromARGB(255, 1, 57, 83)),
                                    ),
                                  ),
                                  SizedBox(
                                    child: Text(
                                      "${itemMaster.uomCode}",
                                      style: GoogleFonts.prompt(
                                          fontSize: 20, color: Colors.black),
                                    ),
                                  ),
                                ],
                              ),
                              /*SizedBox(
                              child: Text(
                                "Batch",
                                style: GoogleFonts.prompt(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Color.fromARGB(255, 1, 57, 83)),
                              ),
                            ),*/
                              SizedBox(
                                height: 10,
                              ),
                              Visibility(
                                visible: showAddBatchButton,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: IgnorePointer(
                                        ignoring: DisableDropdowmBatch,
                                        child: DropdownSearch<StockOnhand>(
                                          // autoValidateMode: AutovalidateMode
                                          //     .onUserInteraction,
                                          popupProps: PopupProps.dialog(
                                            showSearchBox: true,
                                            searchFieldProps: TextFieldProps(
                                                decoration: InputDecoration(
                                                    labelText: "Search...")),
                                          ), // Popup search

                                          asyncItems: (filter) => Batch_List,

                                          itemAsString: (StockOnhand? u) =>
                                              u?.batchId ??
                                              "", //กำหนดฟิลล์ที่ต้องการให้เลือก
                                          selectedItem: DropdownIndex != -1
                                              ? _selectedItem
                                              : _clearSelectedItem,

                                          onChanged: (value) {
                                            setState(() {
                                              DropdownIndex =
                                                  List_StockOnhand.indexOf(
                                                      value!);
                                              _selectedItem = value;
                                              batch_detail.id = value.id;
                                              batch_detail.qty = value.qty;
                                              batch_detail.countQty =
                                                  value.countQty;
                                              countItem = batch_detail.countQty;
                                            });
                                          },

                                          dropdownDecoratorProps:
                                              DropDownDecoratorProps(
                                                  dropdownSearchDecoration:
                                                      InputDecoration(
                                                          border:
                                                              OutlineInputBorder(),
                                                          labelText: "Batch",
                                                          hintText: "Batch"),
                                                  baseStyle: GoogleFonts.prompt(
                                                      fontSize: 18)),
                                          validator: (value) {
                                            if (value!.batchId == null) {
                                              // if (batch_detail.id == "") {
                                              return 'Please select Batch.';
                                              //}
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 0, 8, 18),
                                      child: Visibility(
                                        visible: showAddBatchButton,
                                        child: IconButton(
                                          alignment: Alignment.topCenter,
                                          onPressed: () {
                                            if (itemMaster.code != "" &&
                                                widget.bu_detail.controlLot ==
                                                    "Y") {
                                              Navigator.push(context,
                                                  MaterialPageRoute(
                                                      builder: (context) {
                                                return AddBatch(
                                                  token: widget.token,
                                                  userName: widget.userName,
                                                  itemCode: itemMaster.code,
                                                  stockID: widget.bu_detail.id,
                                                  bu_detail: widget.bu_detail,
                                                  itemMaster: itemMaster,
                                                );
                                                String rr = "";
                                              }));
                                            } else {
                                              if (itemMaster.code == "") {
                                                showAlertDialog(context,
                                                    "Item Code is not null");
                                              } else if (widget
                                                      .bu_detail.controlLot ==
                                                  "N") {
                                                showAlertDialog(context,
                                                    "This document is not Control Lot");
                                              }
                                            }
                                          },
                                          icon: Icon(
                                            Icons.add_box_rounded,
                                            color: Color.fromARGB(
                                                255, 242, 233, 58),
                                            size: 50,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
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
                                          color:
                                              Color.fromARGB(255, 1, 57, 83)),
                                    ),
                                  ),
                                  SizedBox(
                                    child: provider.bList.length != 0 &&
                                            DropdownIndex != -1 &&
                                            provider.bList[0].itemCode != ""
                                        ? Text(
                                            "${provider.bList[DropdownIndex].qty}", //"${batch_detail.qty}",
                                            style: GoogleFonts.prompt(
                                                fontSize: 20,
                                                color: Colors.black),
                                          )
                                        : Text(
                                            "",
                                            style: GoogleFonts.prompt(
                                                fontSize: 20,
                                                color: Colors.black),
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
                                          color:
                                              Color.fromARGB(255, 1, 57, 83)),
                                    ),
                                  ),
                                  SizedBox(
                                    child: provider.bList.length != 0 &&
                                            DropdownIndex != -1 &&
                                            provider.bList[0].itemCode != ""
                                        ? Text(
                                            "${provider.bList[DropdownIndex].countQty}", //"${countItem}",
                                            style: GoogleFonts.prompt(
                                                fontSize: 20,
                                                color: Colors.black),
                                          )
                                        : Text(
                                            "",
                                            style: GoogleFonts.prompt(
                                                fontSize: 20,
                                                color: Colors.black),
                                          ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              SizedBox(
                                // height: 50,
                                child: TextFormField(
                                  // controller: textCountController,
                                  style: TextStyle(fontSize: 20),
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Count Item',
                                      suffixIcon: Icon(Icons.keyboard, size: 40)
                                      /*suffixIcon: IconButton(
                                        icon: Icon(Icons.calculate, size: 40),
                                        onPressed: () {
                                          showModalBottomSheet(
                                              isScrollControlled: true,
                                              backgroundColor:
                                                  Colors.transparent,
                                              barrierColor: Colors.transparent,
                                              context: context,
                                              builder: (BuildContext context) {
                                                return Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey.shade200,
                                                  ),
                                                  child: SizedBox(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.6,
                                                      child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 8.0,
                                                                  bottom: 8.0,
                                                                  left: 26.0,
                                                                  right: 26.0),
                                                          child:
                                                              DynamicCalculator(
                                                            value: 0,
                                                            hideExpression:
                                                                false,
                                                            hideSurroundingBorder:
                                                                true,
                                                            showCalculatorDisplay:
                                                                true,
                                                            //autofocus: false,
                                                            onChanged: (key,
                                                                value,
                                                                expression) {
                                                              // setState(() {
                                                              //   textCountController
                                                              //           .text =
                                                              //       value!
                                                              //           .round()
                                                              //           .toString();
                                                              //   //print('$value');
                                                              // });
                                                            },
                                                            theme:
                                                                const CalculatorTheme(
                                                              borderColor: Colors
                                                                  .transparent,
                                                              borderWidth: 0.0,
                                                              displayCalculatorRadius:
                                                                  10.0,
                                                              displayBackgroundColor:
                                                                  Colors.white,
                                                              displayStyle:
                                                                  TextStyle(
                                                                      fontSize:
                                                                          30,
                                                                      color: Colors
                                                                          .green),
                                                              expressionBackgroundColor:
                                                                  Colors
                                                                      .black12,
                                                              expressionStyle:
                                                                  TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      color: Colors
                                                                          .black45),
                                                              operatorColor:
                                                                  Colors.green,
                                                              operatorStyle:
                                                                  TextStyle(
                                                                      fontSize:
                                                                          24,
                                                                      color: Colors
                                                                          .white),
                                                              commandColor:
                                                                  Colors.white,
                                                              commandStyle:
                                                                  TextStyle(
                                                                      fontSize:
                                                                          24,
                                                                      color: Colors
                                                                          .green),
                                                              numColor:
                                                                  Colors.white,
                                                              numStyle: TextStyle(
                                                                  fontSize: 24,
                                                                  color: Colors
                                                                      .black87),
                                                            ),
                                                          ))),
                                                );
                                              });
                                        },
                                      )*/
                                      ),
                                  //validator:
                                  //RequiredValidator(errorText: "Please Enter Count Qty."),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Please Enter Count.";
                                    } else if (double.parse(value).toInt() <
                                        0) {
                                      return "Count should be greater than 0";
                                    }
                                  },
                                  keyboardType: TextInputType.number,
                                  onSaved: (countItem1) {
                                    setState(() {
                                      countItem =
                                          countItem! + int.parse(countItem1!);
                                    });

                                    batch_detail.countQty =
                                        int.parse(countItem1!);
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton.icon(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Color.fromARGB(255, 5, 201, 13))),
                                  label: Text(
                                    "Save",
                                    style: GoogleFonts.prompt(
                                        fontSize: 20, color: Colors.white),
                                  ),
                                  icon: Icon(
                                    Icons.save,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    if (formKey.currentState?.validate() ==
                                        true) {
                                      formKey.currentState?.save();
                                      if (widget.bu_detail.controlLot == "Y") {
                                        if (batch_detail.id != null) {
                                          api.AddStockActual(batch_detail)
                                              .then((result) {
                                            if (result == "success") {
                                              refreshDataBatch(
                                                  textController.text);
                                              // setState(() {
                                              //   textCountController.clear;
                                              //   textCountController.text = "";
                                              //   String rr = "";
                                              // });

                                              formKey.currentState?.reset();
                                            } else if (result == "fail") {
                                              showAlertDialog(context,
                                                  "Add Stock Actual fail.");
                                            }
                                          });
                                        } else {
                                          showAlertDialog(
                                              context, "Please select batch.");
                                        }
                                      } else {
                                        api.AddStockActual(batch_detail)
                                            .then((result) {
                                          if (result == "success") {
                                            refreshDataBatch(
                                                textController.text);
                                            formKey.currentState?.reset();
                                          } else if (result == "fail") {
                                            showAlertDialog(context,
                                                "Add Stock Actual fail.");
                                          }
                                        });
                                      }

                                      //formKey.currentState?.reset();
                                    }
                                  },
                                ),
                              )
                            ]),
                      ),
                    ),
                  ),
                  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                  Counting_View(
                    bu_detail: widget.bu_detail,
                    itemMaster: itemMaster,
                  )
                ])),
      );
    });
  }

  startScan() async {
    String ttt = scanner.CameraAccessDenied;
    String? cameraScanResult = await scanner.scan();
    textController.text = cameraScanResult ?? "";
    setState(() {
      if (widget.bu_detail.controlLot == "N") {
        DropdownIndex = 0;
      } else {
        DropdownIndex = -1;
      }
      //textController.text = cameraScanResult ?? "";
      //GetItemDetail(textController!.text);
      Batch_List = api.GetBatchList(widget.bu_detail.id, textController.text);
      if (Batch_List != null) {
        ConvertList(); // แปลงจาก Future List เป็น List
        Future.delayed(const Duration(
                milliseconds: 800)) //Delay ให้ข้อมูล Future เป็น List ธรรมดา
            .then((val) {
          setState(() {
            if (List_StockOnhand.length != 0) {
              itemMaster.code = List_StockOnhand[0].itemCode;
              itemMaster.name = List_StockOnhand[0].itemName;
              itemMaster.uomCode = List_StockOnhand[0].uomName;
              itemMaster.location = List_StockOnhand[0].binLoc;
              Batch_Provider provider =
                  Provider.of<Batch_Provider>(context, listen: false);
              provider.addBatchStockOnhand(List_StockOnhand);
            } else {
              itemMaster.code = "";
              itemMaster.name = "";
              itemMaster.uomCode = "";
              itemMaster.location = "";
              batch_detail.qty = 0;
              countItem = 0;
              Batch_List = api.GetBatchList(widget.bu_detail.id, "");
              ConvertList();
              Batch_Provider provider =
                  Provider.of<Batch_Provider>(context, listen: false);
              provider.addBatchStockOnhand(List_StockOnhand);
              showAlertDialog(context, "No Items found.");
            }
          });
        });
      }
    });
  }

  void ConvertList() async {
    List_StockOnhand = await Batch_List;
  }

  void refreshDataBatch(String itemcode) {
    Batch_List = api.GetBatchList(widget.bu_detail.id, itemcode);
    ConvertList(); // แปลงจาก Future List เป็น List
    Future.delayed(const Duration(
            milliseconds: 600)) //Delay ให้ข้อมูล Future เป็น List ธรรมดา
        .then((val) {
      Batch_Provider provider =
          Provider.of<Batch_Provider>(context, listen: false);
      provider.addBatchStockOnhand(List_StockOnhand);
    });
  }
}
