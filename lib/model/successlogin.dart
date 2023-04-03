// To parse this JSON data, do
//
//     final successlogin = successloginFromJson(jsonString);

import 'dart:convert';

Successlogin successloginFromJson(String str) =>
    Successlogin.fromJson(json.decode(str));

String successloginToJson(Successlogin data) => json.encode(data.toJson());

class Successlogin {
  Successlogin({
    this.displayName,
    this.userName,
    this.department,
    this.jobTitle,
    this.token,
  });

  String? displayName;
  String? userName;
  String? department;
  String? jobTitle;
  String? token;

  factory Successlogin.fromJson(Map<String, dynamic> json) => Successlogin(
        displayName: json["displayName"],
        userName: json["userName"],
        department: json["department"],
        jobTitle: json["jobTitle"],
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "displayName": displayName,
        "userName": userName,
        "department": department,
        "jobTitle": jobTitle,
        "token": token,
      };
}
