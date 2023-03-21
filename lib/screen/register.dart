import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Register_Screen extends StatefulWidget {
  const Register_Screen({super.key});

  @override
  State<Register_Screen> createState() => _Register_ScreenState();
}

class _Register_ScreenState extends State<Register_Screen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true; //ป้องการกดปุ่มยอนกลับบน mobile
      },
      child: Scaffold(
        appBar: AppBar(
            title: Text(
          "Register",
          style: GoogleFonts.prompt(fontSize: 25, color: Colors.white),
        )),
        body: Column(),
      ),
    );
  }
}
