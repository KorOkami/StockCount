import 'dart:convert';

Successlogin successloginFromJson(String str) =>
    Successlogin.fromJson(json.decode(str));

String successloginToJson(Successlogin data) => json.encode(data.toJson());

class Successlogin {
  Successlogin({
    this.displayName,
    this.token,
    this.userName,
    this.isVendor,
    this.vendorId,
    this.isApproved,
  });

  String? displayName;
  String? token;
  String? userName;
  bool? isVendor;
  String? vendorId;
  bool? isApproved;

  factory Successlogin.fromJson(Map<String, dynamic> json) => Successlogin(
        displayName: json["displayName"],
        token: json["token"],
        userName: json["userName"],
        isVendor: json["isVendor"],
        vendorId: json["vendorId"],
        isApproved: json["isApproved"],
      );

  Map<String, dynamic> toJson() => {
        "displayName": displayName,
        "token": token,
        "userName": userName,
        "isVendor": isVendor,
        "vendorId": vendorId,
        "isApproved": isApproved,
      };
}
