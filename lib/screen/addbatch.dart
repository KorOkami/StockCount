import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:stock_counting_app/model/itemMaster.dart';
import 'package:stock_counting_app/model/registerResponse.dart';
import 'package:stock_counting_app/model/register_detail.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as json;
import 'dart:io';
import 'dart:async';

import 'package:stock_counting_app/utility/alert.dart';

class AddBatch extends StatefulWidget {
  const AddBatch({super.key});

  @override
  State<AddBatch> createState() => _AddBatchState();
}

class _AddBatchState extends State<AddBatch> {
  final formKey = GlobalKey<FormState>();
  Batch addBatch = Batch();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add Batch/Expire",
          style: GoogleFonts.prompt(fontSize: 25, color: Colors.white),
        ),
        //automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("Batch :",
                  style: GoogleFonts.prompt(fontSize: 20, color: Colors.black)),
              SizedBox(
                height: 5,
              ),
              TextFormField(
                style: TextStyle(
                    fontSize: 18, color: Color.fromARGB(255, 1, 103, 166)),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter Batch',
                ),
                validator: RequiredValidator(errorText: "Please Enter Batch"),
                onSaved: (batchNo) {
                  addBatch.batchNumber = batchNo ?? "";
                },
              ),
              SizedBox(
                height: 5,
              ),
              Text("Expire Date",
                  style: GoogleFonts.prompt(fontSize: 20, color: Colors.black)),
              SizedBox(
                height: 5,
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  label: Text(
                    "Save",
                    style:
                        GoogleFonts.prompt(fontSize: 20, color: Colors.white),
                  ),
                  icon: Icon(
                    Icons.save,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: () {
                    if (formKey.currentState?.validate() == true) {
                      formKey.currentState?.save();
                      /*ResgisterUser(register).then((result) {
                        if (result.token != "") {
                          showRegister_AlertDialog(context);
                        }
                      });*/
                      //formKey.currentState?.reset();
                    }
                  },
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
