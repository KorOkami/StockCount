import 'dart:convert';

Faillogin failloginFromJson(String str) => Faillogin.fromJson(json.decode(str));

String failloginToJson(Faillogin data) => json.encode(data.toJson());

class Faillogin {
  Faillogin({
    this.type,
    this.title,
    this.status,
    this.traceId,
    this.errors,
  });

  String? type;
  String? title;
  int? status;
  String? traceId;
  Errors? errors;

  factory Faillogin.fromJson(Map<String, dynamic> json) => Faillogin(
        type: json["type"],
        title: json["title"],
        status: json["status"],
        traceId: json["traceId"],
        errors: json["errors"] == null ? null : Errors.fromJson(json["errors"]),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "title": title,
        "status": status,
        "traceId": traceId,
        "errors": errors?.toJson(),
      };
}

class Errors {
  Errors({
    this.loginFail,
  });

  List<String>? loginFail;

  factory Errors.fromJson(Map<String, dynamic> json) => Errors(
        loginFail: json["Login fail"] == null
            ? []
            : List<String>.from(json["Login fail"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "Login fail": loginFail == null
            ? []
            : List<dynamic>.from(loginFail!.map((x) => x)),
      };
}
