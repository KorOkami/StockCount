import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';
import 'package:stock_counting_app/model/faillogin.dart';
import 'package:stock_counting_app/model/profile.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as json;
import 'dart:io';
import 'dart:async';
import 'package:stock_counting_app/model/successlogin.dart';
import 'package:stock_counting_app/screen/bu_screen.dart';
import 'package:stock_counting_app/screen/register.dart';
//import 'package:stock_counting_app/screen/poScreen.dart';
import 'package:stock_counting_app/utility/Alert.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  Profile profile = Profile("", "");
  Successlogin? _successData;
  Faillogin? _faillogin;
  //ResponseLogin res = new ResponseLogin("", "", "");

  Future<ResponseLogin?> AppLogin(String _email, String _password) async {
    ResponseLogin res = new ResponseLogin("", "", "", "");
    var headers = {
      'Content-Type': 'application/json',
      'Cookie': 'refreshToken=l9lbOu2%2BQ08KTAKEUHqYe9fwywz6Rz5TKeXP7yQV2p0%3D'
    };
    var request = http.Request(
        'POST', Uri.parse('http://172.24.9.24:5000/api/account/login'));
    request.body =
        json.jsonEncode({"email": "$_email", "password": "$_password"});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    var Response = await http.Response.fromStream(response);
    if (response.statusCode == 200) {
      _successData = successloginFromJson(Response.body);
      res.status = "success";
      res.token = _successData?.token ?? "";
      res.username = _successData?.userName ?? "";
    } else {
      _faillogin = failloginFromJson(Response.body);
      res.status = "fail";
      for (String? dd in _faillogin!.errors!.loginFail!) {
        res.ErrorM = dd ?? "";
      }
      //res.ErrorM = _faillogin!.errors!.loginFail!.first();
    }
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false; //ป้องการกดปุ่มยอนกลับบน mobile
      },
      child: Scaffold(
          resizeToAvoidBottomInset:
              false, //ป้องกัน Error : Bottom overflowed by pixels
          appBar: AppBar(
            title: Text(
              "Stock Counting",
              style: GoogleFonts.prompt(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            automaticallyImplyLeading: false,
            //backgroundColor: Colors.white,
          ),
          body: Column(
            children: [
              Image.asset("asset/images/PrincLogo.png"),
              SingleChildScrollView(
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Form(
                      key: formKey,
                      child: SingleChildScrollView(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "User Name",
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Color.fromARGB(255, 9, 1, 87)),
                              ),
                              TextFormField(
                                decoration:
                                    InputDecoration(labelText: "E-mail"),
                                validator: MultiValidator([
                                  RequiredValidator(
                                      errorText: "กรุณาระบุอีเมล"),
                                  EmailValidator(
                                      errorText: "รูปแบบอีเมลไม่ถูกต้อง")
                                ]),
                                keyboardType: TextInputType.emailAddress,
                                onSaved: (email) {
                                  profile.email = email ?? "";
                                },
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Password",
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Color.fromARGB(255, 9, 1, 87)),
                              ),
                              TextFormField(
                                validator: RequiredValidator(
                                    errorText: "กรุณาระบุรหัสผ่าน"),
                                obscureText: true,
                                onSaved: (password) {
                                  profile.password = password ?? "";
                                },
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton.icon(
                                  label: Text(
                                    "ลงชื่อเข้าใช้",
                                    style: GoogleFonts.prompt(
                                        fontSize: 20, color: Colors.white),
                                  ),
                                  icon: Icon(
                                    Icons.login,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                  onPressed: () {
                                    if (formKey.currentState?.validate() ==
                                        true) {
                                      formKey.currentState?.save();

                                      AppLogin(profile.email, profile.password)
                                          .then((result) {
                                        if (result?.token != "") {
                                          Navigator.pushReplacement(context,
                                              MaterialPageRoute(
                                                  builder: (context) {
                                            return BU_Screen(
                                                token: result?.token,
                                                userName: result?.username);
                                          }));
                                        } else {
                                          print(result?.ErrorM);
                                          showAlertDialog(
                                              context, result?.ErrorM);
                                        }
                                      });
                                      //formKey.currentState?.reset();
                                    }
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                  width: double.infinity,
                                  height: 50,
                                  color: Colors.white,
                                  child: ElevatedButton.icon(
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Color.fromARGB(
                                                    255, 1, 103, 166)),
                                      ),
                                      label: Text(
                                        "Register",
                                        style: GoogleFonts.prompt(
                                            fontSize: 20, color: Colors.white),
                                      ),
                                      icon: Icon(
                                        Icons.person_add_alt_1,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                      onPressed: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return Register_Screen();
                                        }));
                                      }))
                            ]),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
