import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';
import 'package:stock_counting_app/components/text_field_container.dart';
import 'package:stock_counting_app/model/faillogin.dart';
import 'package:stock_counting_app/model/profile.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as json;
import 'dart:io';
import 'dart:async';
import 'package:stock_counting_app/model/successlogin.dart';
import 'package:stock_counting_app/providers/token_provider.dart';
import 'package:stock_counting_app/screen/bu_screen.dart';
import 'package:stock_counting_app/screen/register.dart';
import 'package:stock_counting_app/services/api.dart';
//import 'package:stock_counting_app/screen/poScreen.dart';
import 'package:stock_counting_app/utility/Alert.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final formKeySetting = GlobalKey<FormState>();
  Profile profile = Profile("", "");
  Successlogin? _successData;
  Faillogin? _faillogin;
  TextEditingController _textUserController = TextEditingController();
  /* String? urlNew;

  late Future<String> _url;
  final Future<SharedPreferences> _prefsURL = SharedPreferences.getInstance();
  Future<void> _AppUrlString() async {
    final SharedPreferences prefs = await _prefsURL;
    final String? counter =
        prefs.getString("AppUrl"); //"http://172.24.9.24:5000";

    setState(() {
      _url = prefs.setString('AppUrl', counter!).then((bool success) {
        return counter;
      });
    });
  }*/

  /*Future<ResponseLogin?> AppLogin(String _email, String _password) async {
    ResponseLogin res = new ResponseLogin("", "", "", "");

    var headers = {
      'Content-Type': 'application/json',
      'Cookie': 'refreshToken=l9lbOu2%2BQ08KTAKEUHqYe9fwywz6Rz5TKeXP7yQV2p0%3D'
    };
    var request = http.Request('POST',
        Uri.parse('https://inventory-uat.princhealth.com/api/account/login'));
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
      Token_Provider provider =
          Provider.of<Token_Provider>(context, listen: false);
      provider.addToken(res.token);
    } else {
      //_faillogin = failloginFromJson(Response.body);
      res.status = "fail";
      res.ErrorM = Response.body;
      //"Login Failed";
      //_faillogin?.title ?? "";
      // for (String? dd in _faillogin!.errors!.loginFail!) {
      //res.ErrorM = dd ?? "";
      //}
      //res.ErrorM = _faillogin!.errors!.loginFail!.first();
    }
    return res;
  }*/
  var _isObscured;

  @override
  void initState() {
    super.initState();
    //_AppUrlString();
    _isObscured = true;
  }

  TextEditingController? _textEditingController;

  final api = stockCountingAPI();

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
            /*leading: IconButton(
                //elevation: 0,
                color: Color.fromARGB(255, 1, 68, 122),
                //shadowColor: Colors.black,
                icon: Icon(
                  Icons.settings,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) => SimpleDialog(
                            children: [
                              Form(
                                  key: formKeySetting,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("URL",
                                            style: GoogleFonts.prompt(
                                                fontSize: 18,
                                                color: Colors.black)),
                                        TextFormField(
                                          controller: _textEditingController,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            labelText: 'url:port',
                                          ),
                                          style: GoogleFonts.prompt(
                                              fontSize: 18,
                                              color: Colors.black),
                                          onChanged: (value) {
                                            setState(() {
                                              //urlNew = value;
                                            });
                                          },
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return "Please url:port";
                                            }
                                          },
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        SizedBox(
                                          width: double.infinity,
                                          height: 50,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              if (formKeySetting.currentState
                                                      ?.validate() ==
                                                  true) {
                                                formKeySetting.currentState
                                                    ?.save();
                                                //_AppUrlString();
                                                // Navigator.pop(context);
                                              }
                                            },
                                            child: Text("Save",
                                                style: GoogleFonts.prompt(
                                                    fontSize: 18,
                                                    color: Colors.white)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ))
                            ],
                          ));
                },
              )*/
          ),
          body: Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
                image: DecorationImage(
                    opacity: 0.2,
                    alignment: Alignment.bottomCenter,
                    image: AssetImage("asset/images/AppBG.png"),
                    fit: BoxFit.none)),
            child: Column(
              children: [
                Image.asset("asset/images/PrincLogo.png"),
                SingleChildScrollView(
                  child: Container(
                    //margin: EdgeInsets.symmetric(vertical: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Form(
                        key: formKey,
                        child: SingleChildScrollView(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                /*Text(
                                  "User Name",
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Color.fromARGB(255, 9, 1, 87)),
                                ),*/

                                TextFormFieldContainer(
                                  child: TextFormField(
                                    //controller: _textUserController,
                                    style: TextStyle(fontSize: 20),
                                    decoration: InputDecoration(
                                      // suffixIcon: IconButton(
                                      //   onPressed: _textUserController.clear,
                                      //   icon: Icon(Icons.clear),
                                      // ),
                                      border: InputBorder.none,
                                      icon: Icon(
                                        Icons.person,
                                      ),
                                      labelText: "UserName or E-mail",
                                    ),
                                    validator: MultiValidator([
                                      RequiredValidator(
                                          errorText:
                                              "Please enter User Name or E-mail"),
                                    ]),
                                    onSaved: (email) {
                                      profile.email = email ?? "";
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                TextFormFieldContainer(
                                  child: TextFormField(
                                    style: TextStyle(fontSize: 20),
                                    decoration: InputDecoration(
                                        hintText: "Password",
                                        border: InputBorder.none,
                                        icon: Icon(
                                          Icons.lock,
                                        ),
                                        suffixIcon: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                _isObscured = !_isObscured;
                                              });
                                            },
                                            icon: _isObscured
                                                ? const Icon(Icons.visibility)
                                                : const Icon(
                                                    Icons.visibility_off))),
                                    validator: RequiredValidator(
                                        errorText: "Please enter password."),
                                    obscureText: _isObscured,
                                    onSaved: (password) {
                                      profile.password = password ?? "";
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: 25,
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: ElevatedButton.icon(
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15))),
                                    ),
                                    label: Text(
                                      "Login",
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
                                        api
                                            .dioLogin(
                                                profile.email, profile.password)
                                            .then((result) {
                                          // AppLogin(profile.email, profile.password)
                                          //.then((result) {
                                          if (result?.status == "success") {
                                            Token_Provider provider =
                                                Provider.of<Token_Provider>(
                                                    context,
                                                    listen: false);
                                            provider.addToken(result!.token);
                                            Navigator.pushReplacement(context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return BU_Screen(
                                                  token: result.token,
                                                  userName: result.username);
                                            }));
                                          } else {
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
                                // Container(
                                //     width: double.infinity,
                                //     height: 50,
                                //     color: Colors.white,
                                //     child: ElevatedButton.icon(
                                //         style: ButtonStyle(
                                //           shape: MaterialStateProperty.all<
                                //                   RoundedRectangleBorder>(
                                //               RoundedRectangleBorder(
                                //                   borderRadius:
                                //                       BorderRadius.circular(
                                //                           15))),
                                //           backgroundColor:
                                //               MaterialStateProperty.all(
                                //                   Color.fromARGB(
                                //                       255, 1, 103, 166)),
                                //         ),
                                //         label: Text(
                                //           "Register",
                                //           style: GoogleFonts.prompt(
                                //               fontSize: 20,
                                //               color: Colors.white),
                                //         ),
                                //         icon: Icon(
                                //           Icons.person_add_alt_1,
                                //           color: Colors.white,
                                //           size: 30,
                                //         ),
                                //         onPressed: () {
                                //           Navigator.push(context,
                                //               MaterialPageRoute(
                                //                   builder: (context) {
                                //             return Register_Screen(
                                //                 token: _successData?.token);
                                //           }));
                                //         }))
                              ]),
                        ),
                      ),
                    ),
                  ),
                ),
                /*Container(
                  height: double.infinity,
                  child: Opacity(
                      opacity: 0.8, child: Image.asset("asset/images/AppBG.png")),
                ),*/
              ],
            ),
          )),
    );
  }
}
