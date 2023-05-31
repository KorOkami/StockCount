import 'dart:ffi';

import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stock_counting_app/model/bu_detail.dart';
import 'package:stock_counting_app/screen/login.dart';
import 'package:stock_counting_app/screen/scanItem.dart';

showAlertDialog(BuildContext context, String? errorMessage) {
  // set up the button
  Widget okButton = TextButton(
    child: Text("OK"),
    onPressed: () => Navigator.pop(context),
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Error"),
    content: Text(errorMessage ?? ""),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

showLogout_AlertDialog(BuildContext context) {
  // set up the buttons
  Widget OkButton = TextButton(
    child: Text(
      "Yes",
      style: GoogleFonts.prompt(fontSize: 20),
    ),
    onPressed: () {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return LoginScreen();
      }));
    },
  );
  Widget cancelButton = TextButton(
    child: Text(
      "No",
      style: GoogleFonts.prompt(fontSize: 20, fontWeight: FontWeight.bold),
    ),
    onPressed: () => Navigator.pop(context),
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(
      "Logout",
      style: GoogleFonts.prompt(fontSize: 20, fontWeight: FontWeight.bold),
    ),
    content: Text(
      "Are you sure you want to logout?",
      style: GoogleFonts.prompt(fontSize: 16),
    ),
    actions: [
      OkButton,
      cancelButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

showRegister_AlertDialog(BuildContext context) {
  // set up the buttons
  Widget OkButton = TextButton(
    child: Text(
      "OK",
      style: GoogleFonts.prompt(fontSize: 20),
    ),
    onPressed: () {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return LoginScreen();
      }));
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(
      "Resiter successfully",
      style: GoogleFonts.prompt(fontSize: 20, fontWeight: FontWeight.bold),
    ),
    actions: [
      OkButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

showAddBatch_AlertDialog(BuildContext context) {
  // set up the buttons
  Widget OkButton = TextButton(
    child: Text(
      "OK",
      style: GoogleFonts.prompt(fontSize: 20),
    ),
    onPressed: () => Navigator.pop(context),
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(
      "Add Batch successfully",
      style: GoogleFonts.prompt(fontSize: 20, fontWeight: FontWeight.bold),
    ),
    actions: [
      OkButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
