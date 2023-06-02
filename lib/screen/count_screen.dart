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

class CountScan extends StatefulWidget {
  const CountScan(
      {super.key,
      required this.token,
      required this.userName,
      required this.bu_detail});
  final String? token;
  final String? userName;
  final BU_Detail bu_detail;

  @override
  State<CountScan> createState() => _CountScanState();
}

class _CountScanState extends State<CountScan> with TickerProviderStateMixin {
  final TextEditingController textController = TextEditingController();
  TabController? _tabController;
  final formKey = GlobalKey<FormState>();
  late Future<List<StockOnhand>> Batch_List;
  late StockOnhand batch_detail = StockOnhand();
  late List<StockOnhand> List_StockOnhand = [];
  final ItemMaster itemMaster = new ItemMaster();
  late int? countItem = 0;

  ItemMaster? itm_detail;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      initialIndex: 0,
      length: 2,
      vsync: this,
    );
    itemMaster.code = "";
    itemMaster.name = "";
    itemMaster.uomCode = "";
    itemMaster.location = "";
    batch_detail.qty = 0;
    batch_detail.binLoc = "";
    batch_detail.countQty = 0;
    Batch_List = api.GetBatchList(widget.bu_detail.id, "");
    ConvertList(); // แปลงจาก Future List เป็น List
    Future.delayed(const Duration(
            seconds: 1)) //Delay ให้ข้อมูล Future เป็น List ธรรมดา
        .then((val) {
      Batch_Provider provider =
          Provider.of<Batch_Provider>(context, listen: false);
      provider.addBatchStockOnhand(List_StockOnhand);
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
                ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                //Scan_Item(
                //bu_detail: widget.bu_detail,
                //token: widget.token,
                //),
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
                                  "${widget.bu_detail.buCode} - ${widget.bu_detail.whsCode}",
                                  style: GoogleFonts.prompt(
                                      fontSize: 40,
                                      color: Color.fromARGB(255, 1, 68, 122))),
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
                                  validator: RequiredValidator(
                                      errorText: "Please Scan Item."),
                                  onEditingComplete: () {
                                    if (textController.text != "") {
                                      //Batch_List = GetBatchList(textController.text);
                                      Batch_List = api.GetBatchList(
                                          widget.bu_detail.id,
                                          textController.text);
                                      if (Batch_List != null) {
                                        ConvertList(); // แปลงจาก Future List เป็น List
                                        Future.delayed(const Duration(
                                                seconds:
                                                    1)) //Delay ให้ข้อมูล Future เป็น List ธรรมดา
                                            .then((val) {
                                          setState(() {
                                            if (List_StockOnhand.length != 0) {
                                              itemMaster.code =
                                                  List_StockOnhand[0].itemCode;
                                              itemMaster.name =
                                                  List_StockOnhand[0].itemName;
                                              itemMaster.uomCode =
                                                  List_StockOnhand[0].uomCode;
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
                                              showAlertDialog(context,
                                                  "Item not found in this Document.");
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
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 8, 18),
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
                                        color: Color.fromARGB(255, 1, 57, 83)),
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
                                        color: Color.fromARGB(255, 1, 57, 83)),
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
                                    autoValidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    popupProps: PopupProps.dialog(
                                      showSearchBox: true,
                                      searchFieldProps: TextFieldProps(
                                          decoration: InputDecoration(
                                              labelText: "Search...")),
                                    ), // Popup search

                                    asyncItems: (filter) =>
                                        Batch_List, //GetBU(filter),

                                    itemAsString: (StockOnhand? u) =>
                                        u?.batchId ??
                                        "", //กำหนดฟิลล์ที่ต้องการให้เลือก

                                    onChanged: (value) {
                                      setState(() {
                                        batch_detail.id = value!.id;
                                        batch_detail.qty = value.qty;
                                        batch_detail.countQty = value.countQty;
                                        countItem = batch_detail.countQty;
                                      });
                                    },

                                    dropdownDecoratorProps:
                                        DropDownDecoratorProps(
                                            dropdownSearchDecoration:
                                                InputDecoration(
                                                    labelText: "Batch"),
                                            baseStyle: GoogleFonts.prompt(
                                                fontSize: 18)),
                                    validator: (value) {
                                      if (value == null) {
                                        return 'Please select Batch.';
                                      }
                                    },
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 8, 18),
                                  child: IconButton(
                                    alignment: Alignment.topCenter,
                                    onPressed: () {
                                      if (itemMaster.code != "") {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return AddBatch(
                                            //token: widget.token,
                                            itemCode: itemMaster.code,
                                            stockID: widget.bu_detail.id,
                                            bu_detail: widget.bu_detail,
                                          );
                                          String rr = "";
                                        }));
                                      } else {
                                        if (itemMaster.code == "") {
                                          showAlertDialog(
                                              context, "Item Code is not null");
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
                                    style: GoogleFonts.prompt(
                                        fontSize: 20, color: Colors.black),
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
                                    style: GoogleFonts.prompt(
                                        fontSize: 20, color: Colors.black),
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
                                      } else if (double.parse(value).toInt() <=
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
                                    api.AddStockActual(batch_detail)
                                        .then((result) {
                                      if (result == "success") {
                                        print(result);
                                        api.GetBatchList(widget.bu_detail.id,
                                            textController.text);
                                        setState(() {
                                          //batch_detail.countQty =
                                          //batch_detail.countQty! + countItem!;
                                        });
                                        formKey.currentState?.reset();
                                      } else if (result == "fail") {
                                        showAlertDialog(
                                            context, "Add Stock Actual fail.");
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
                ),
                ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                Counting_View(
                  bu_detail: widget.bu_detail,
                  itemMaster: itemMaster,
                )
              ])),
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
      if (Batch_List != null) {
        ConvertList(); // แปลงจาก Future List เป็น List
        Future.delayed(const Duration(
                seconds: 1)) //Delay ให้ข้อมูล Future เป็น List ธรรมดา
            .then((val) {
          setState(() {
            if (List_StockOnhand.length != 0) {
              itemMaster.code = List_StockOnhand[0].itemCode;
              itemMaster.name = List_StockOnhand[0].itemName;
              itemMaster.uomCode = List_StockOnhand[0].uomCode;
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
              showAlertDialog(context, "Item not found in this Document.");
            }
          });
        });
      }
    });
  }

  void ConvertList() async {
    List_StockOnhand = await Batch_List;
  }
}
