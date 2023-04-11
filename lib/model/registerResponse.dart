import 'dart:convert';

RegisterResponse registerResponseFromJson(String str) =>
    RegisterResponse.fromJson(json.decode(str));

String registerResponseToJson(RegisterResponse data) =>
    json.encode(data.toJson());

class RegisterResponse {
  RegisterResponse({
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

  factory RegisterResponse.fromJson(Map<String, dynamic> json) =>
      RegisterResponse(
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
