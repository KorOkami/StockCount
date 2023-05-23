// To parse this JSON data, do
//
//     final refrashToken = refrashTokenFromJson(jsonString);

import 'dart:convert';

RefrashToken refrashTokenFromJson(String str) =>
    RefrashToken.fromJson(json.decode(str));

String refrashTokenToJson(RefrashToken data) => json.encode(data.toJson());

class RefrashToken {
  String? displayName;
  String? userName;
  String? role;
  String? token;

  RefrashToken({
    this.displayName,
    this.userName,
    this.role,
    this.token,
  });

  factory RefrashToken.fromJson(Map<String, dynamic> json) => RefrashToken(
        displayName: json["displayName"],
        userName: json["userName"],
        role: json["role"],
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "displayName": displayName,
        "userName": userName,
        "role": role,
        "token": token,
      };
}
