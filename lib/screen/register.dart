import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:stock_counting_app/components/text_field_container.dart';
import 'package:stock_counting_app/model/registerResponse.dart';
import 'package:stock_counting_app/model/register_detail.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as json;
import 'dart:io';
import 'dart:async';

import 'package:stock_counting_app/utility/alert.dart';

class Register_Screen extends StatefulWidget {
  const Register_Screen({super.key, required this.token});
  final String? token;
  @override
  State<Register_Screen> createState() => _Register_ScreenState();
}

class _Register_ScreenState extends State<Register_Screen> {
  final formKey = GlobalKey<FormState>();

  register_detail register = register_detail("", "", "", "", "", "");

  Future<String> ResgisterUser(register_detail resg_detail) async {
    late RegisterResponse _resRegister;
    String res = "";
    var headers = {
      'Content-Type': 'application/json',
    };
    var request = http.Request('POST',
        Uri.parse('https://stockcount.princhealth.com/api/account/register'));

    request.body = json.jsonEncode({
      "displayName": "${resg_detail.displayname}",
      "department": "${resg_detail.department}",
      "jobTitle": "${resg_detail.jobtitle}",
      "email": "${resg_detail.email}",
      "username": "${resg_detail.username}",
      "password": "${resg_detail.password}"
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    var Response = await http.Response.fromStream(response);
    if (response.statusCode == 200) {
      //_resRegister = registerResponseFromJson(Response.body);
      res = "Success";
    } else {
      String bodyError = Response.body;
      res = "Register Failed. : ${bodyError}";
    }
    return res;
  }

  var _isObscured;

  @override
  void initState() {
    super.initState();
    //_AppUrlString();
    _isObscured = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Register",
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
              SizedBox(
                height: 10,
              ),
              Text("Your infomation",
                  style: GoogleFonts.prompt(fontSize: 20, color: Colors.black)),
              SizedBox(
                height: 5,
              ),
              TextFormFieldContainerRegister(
                colors: Color.fromARGB(255, 217, 242, 253),
                child: TextFormField(
                  style: TextStyle(
                      fontSize: 18, color: Color.fromARGB(255, 1, 103, 166)),
                  decoration: InputDecoration(
                    icon: Icon(Icons.face),
                    border: InputBorder.none,
                    labelText: 'Full Name *',
                  ),
                  validator:
                      RequiredValidator(errorText: "Please Enter Full Name"),
                  onSaved: (displayname) {
                    register.displayname = displayname ?? "";
                  },
                ),
              ),
              //Text("Department",
              //style: GoogleFonts.prompt(fontSize: 20, color: Colors.black)),
              SizedBox(
                height: 5,
              ),
              TextFormFieldContainerRegister(
                colors: Color.fromARGB(255, 217, 242, 253),
                child: TextFormField(
                  style: TextStyle(
                      fontSize: 18, color: Color.fromARGB(255, 1, 103, 166)),
                  decoration: InputDecoration(
                    icon: Icon(Icons.badge),
                    border: InputBorder.none,
                    labelText: 'Department',
                  ),
                  // validator:
                  //     RequiredValidator(errorText: "Please Enter Department"),
                  onSaved: (department) {
                    register.department = department ?? "";
                  },
                ),
              ),
              SizedBox(
                height: 5,
              ),
              // Text("Job Title",
              //  style: GoogleFonts.prompt(fontSize: 20, color: Colors.black)),
              TextFormFieldContainerRegister(
                colors: Color.fromARGB(255, 217, 242, 253),
                child: TextFormField(
                  style: TextStyle(
                      fontSize: 18, color: Color.fromARGB(255, 1, 103, 166)),
                  decoration: InputDecoration(
                    icon: Icon(Icons.attribution),
                    border: InputBorder.none,
                    labelText: 'Job Title',
                  ),
                  // validator:
                  //     RequiredValidator(errorText: "Please Enter Job Title"),
                  onSaved: (jobtitle) {
                    register.jobtitle = jobtitle ?? "";
                  },
                ),
              ),
              SizedBox(
                height: 5,
              ),
              // Text("Login detail",
              //style: GoogleFonts.prompt(fontSize: 20, color: Colors.black)),
              TextFormFieldContainerRegister(
                colors: Color.fromARGB(255, 217, 242, 253),
                child: TextFormField(
                  style: TextStyle(
                      fontSize: 18, color: Color.fromARGB(255, 1, 103, 166)),
                  decoration: InputDecoration(
                    icon: Icon(Icons.email),
                    border: InputBorder.none,
                    labelText: 'E-mail *',
                  ),
                  validator: MultiValidator([
                    RequiredValidator(errorText: "Please Enter E-mail"),
                    EmailValidator(errorText: "Invalid E-mail Format")
                  ]),
                  keyboardType: TextInputType.emailAddress,
                  onSaved: (email) {
                    register.email = email ?? "";
                  },
                ),
              ),
              SizedBox(
                height: 5,
              ),
              //Text("User Name",
              //style: GoogleFonts.prompt(fontSize: 20, color: Colors.black)),
              TextFormFieldContainerRegister(
                colors: Color.fromARGB(255, 217, 242, 253),
                child: TextFormField(
                  style: TextStyle(
                      fontSize: 18, color: Color.fromARGB(255, 1, 103, 166)),
                  decoration: InputDecoration(
                    icon: Icon(Icons.person),
                    border: InputBorder.none,
                    labelText: 'User Name (ห้ามเว้นวรรค) *',
                  ),
                  validator:
                      RequiredValidator(errorText: "Please Enter User Name"),
                  onSaved: (userName) {
                    register.username = userName ?? "";
                  },
                ),
              ),
              SizedBox(
                height: 5,
              ),
              //Text("Password",
              // style: GoogleFonts.prompt(fontSize: 20, color: Colors.black)),
              TextFormFieldContainerRegister(
                colors: Color.fromARGB(255, 217, 242, 253),
                child: TextFormField(
                  style: TextStyle(fontSize: 18),
                  decoration: InputDecoration(
                      icon: Icon(Icons.lock),
                      border: InputBorder.none,
                      labelText: 'Password *',
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _isObscured = !_isObscured;
                            });
                          },
                          icon: _isObscured
                              ? const Icon(Icons.visibility)
                              : const Icon(Icons.visibility_off))),
                  validator:
                      RequiredValidator(errorText: "Please Enter Password"),
                  obscureText: _isObscured,
                  onSaved: (password) {
                    register.password = password ?? "";
                  },
                ),
              ),
              SizedBox(
                height: 30,
              ),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15))),
                  ),
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
                      ResgisterUser(register).then((result) {
                        if (result == "Success") {
                          showRegister_AlertDialog(context);
                          formKey.currentState?.reset();
                        } else {
                          showAlertDialog(context, result);
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
    );
  }
}
