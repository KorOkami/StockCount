import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:form_field_validator/form_field_validator.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:stock_counting_app/screen/count_screen.dart';

import '../components/text_field_container.dart';

class AddItem extends StatefulWidget {
  const AddItem({
    super.key,
    required this.batchControl,
  });
  final String? batchControl;

  @override
  State<AddItem> createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  final TextEditingController textController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  bool showAddBatch = true;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.batchControl == "N") {
      showAddBatch = false;
    }
  }

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
                      Text("Item QR/Barcode",
                          style: GoogleFonts.prompt(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Color.fromARGB(255, 1, 57, 83))),
                      SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        controller: textController,
                        style: TextStyle(fontSize: 20),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Scan new item',
                            suffixIcon: IconButton(
                              //onPressed: () => barcodeScan(),
                              onPressed: () {},
                              icon: Icon(
                                Icons.qr_code_scanner,
                                color: Colors.grey,
                              ),
                              iconSize: 40,
                            )),
                        validator:
                            RequiredValidator(errorText: "Please Scan Item."),
                        onEditingComplete: () {},
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
                      // SizedBox(
                      //   child: Text(
                      //     "${itemMaster.name}",
                      //     style: GoogleFonts.prompt(
                      //         fontSize: 20, color: Colors.black),
                      //   ),
                      // ),
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
                              style: GoogleFonts.prompt(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Color.fromARGB(255, 1, 57, 83)),
                            ),
                          ),
                          // SizedBox(
                          //   child: Text(
                          //     "${itemMaster.uomCode}",
                          //     style: GoogleFonts.prompt(
                          //         fontSize: 20, color: Colors.black),
                          //   ),
                          // ),
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
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Color.fromARGB(255, 1, 103, 166)),
                                  decoration: InputDecoration(
                                    suffixIcon: Icon(
                                      Icons.keyboard,
                                      size: 30,
                                    ),
                                    border: InputBorder.none,
                                    labelText: 'Batch',
                                  ),
                                  validator: RequiredValidator(
                                      errorText: "Please Enter Batch"),
                                  onSaved: (batchNo) {
                                    //addBatch.batchNumber = batchNo ?? "";
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
                                  style: GoogleFonts.prompt(
                                      fontSize: 20,
                                      color: Color.fromARGB(255, 1, 57, 83)),
                                  controller:
                                      dateController, //editing controller of this TextField
                                  validator: MultiValidator([
                                    RequiredValidator(
                                        errorText: "Please select Date")
                                  ]),
                                  decoration: const InputDecoration(
                                    labelText: "Expire Date",
                                    //contentPadding: EdgeInsets.zero,
                                    border: InputBorder.none,
                                    suffixIcon: Icon(
                                      Icons.calendar_today,
                                      color: Colors.black,
                                    ), //icon of text field
                                    // labelText: "Select Date",
                                    //labelStyle: TextStyle(fontSize: 25)
                                  ),
                                  readOnly:
                                      true, // when true user cannot edit text
                                  onTap: () async {
                                    //when click we have to show the datepicker
                                    DateTime? pickedDate = await showDatePicker(
                                        context: context,
                                        initialDate:
                                            DateTime.now(), //get today's date
                                        firstDate: DateTime(
                                            2000), //DateTime.now() - not to allow to choose before today.
                                        lastDate: DateTime(2101));
                                    setState(() {
                                      if (pickedDate != null) {
                                        String formattedDate =
                                            DateFormat('dd-MM-yyyy')
                                                .format(pickedDate);
                                        String SendformattedDate =
                                            DateFormat('yyyy-MM-dd')
                                                .format(pickedDate);
                                        dateController.text = formattedDate;
                                        // addBatch.epireDate = SendformattedDate;
                                      }
                                    });
                                  },
                                  // onSaved: (newValue) {
                                  //   dateController.text = newValue!;
                                  // },
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
                            style: GoogleFonts.prompt(
                                fontSize: 20, color: Colors.white),
                          ),
                          icon: Icon(
                            Icons.save,
                            color: Colors.white,
                            size: 30,
                          ),
                          onPressed: () {
                            if (formKey.currentState?.validate() == true) {
                              formKey.currentState?.save();
                              // api.AddBatchExpire(stockOnhand, addBatch).then((result) {
                              //   if (result?.status == "success") {
                              //     setState(() {
                              //       res = result?.status;
                              //     });
                              //     showAddBatch_AlertDialog(context);
                              //     formKey.currentState?.reset();
                              //   } else if (result?.status == "fail") {
                              //     showAlertDialog(context, result?.ErrorM);
                              //   }
                              // }
                              // );
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
}
