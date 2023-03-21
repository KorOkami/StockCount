import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:stock_counting_app/model/register_detail.dart';

class Register_Screen extends StatefulWidget {
  const Register_Screen({super.key});

  @override
  State<Register_Screen> createState() => _Register_ScreenState();
}

class _Register_ScreenState extends State<Register_Screen> {
  final formKey = GlobalKey<FormState>();
  register_detail register = register_detail("", "", "", "", "", "");
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
              Text("Display Name",
                  style: GoogleFonts.prompt(fontSize: 20, color: Colors.black)),
              TextFormField(
                style: TextStyle(
                    fontSize: 18, color: Color.fromARGB(255, 1, 103, 166)),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter Display Name',
                ),
                validator:
                    RequiredValidator(errorText: "Please Enter Display Name"),
              ),
              SizedBox(
                height: 5,
              ),
              Text("Department",
                  style: GoogleFonts.prompt(fontSize: 20, color: Colors.black)),
              TextFormField(
                style: TextStyle(
                    fontSize: 18, color: Color.fromARGB(255, 1, 103, 166)),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter Department',
                ),
                validator:
                    RequiredValidator(errorText: "Please Enter Department"),
              ),
              SizedBox(
                height: 5,
              ),
              Text("Job Title",
                  style: GoogleFonts.prompt(fontSize: 20, color: Colors.black)),
              TextFormField(
                style: TextStyle(
                    fontSize: 18, color: Color.fromARGB(255, 1, 103, 166)),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter Job Title',
                ),
                validator:
                    RequiredValidator(errorText: "Please Enter Job Title"),
              ),
              SizedBox(
                height: 5,
              ),
              Text("E-mail",
                  style: GoogleFonts.prompt(fontSize: 20, color: Colors.black)),
              TextFormField(
                style: TextStyle(
                    fontSize: 18, color: Color.fromARGB(255, 1, 103, 166)),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter E-mail',
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
              SizedBox(
                height: 5,
              ),
              Text("User Name",
                  style: GoogleFonts.prompt(fontSize: 20, color: Colors.black)),
              TextFormField(
                style: TextStyle(
                    fontSize: 18, color: Color.fromARGB(255, 1, 103, 166)),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter User Name',
                ),
                validator:
                    RequiredValidator(errorText: "Please Enter User Name"),
              ),
              SizedBox(
                height: 5,
              ),
              Text("Password",
                  style: GoogleFonts.prompt(fontSize: 20, color: Colors.black)),
              TextFormField(
                style: TextStyle(fontSize: 18),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter Password',
                ),
                validator:
                    RequiredValidator(errorText: "Please Enter Password"),
                obscureText: true,
                onSaved: (password) {
                  register.password = password ?? "";
                },
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
