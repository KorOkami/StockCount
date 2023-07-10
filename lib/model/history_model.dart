// To parse this JSON data, do
//
//     final stockOnhand = stockOnhandFromJson(jsonString);

import 'dart:convert';
import 'package:intl/intl.dart';

List<history> historyFromJson(String str) =>
    List<history>.from(json.decode(str).map((x) => history.fromJson(x)));

String historyToJson(List<history> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class history {
  history(
      {this.id,
      this.onhandId,
      this.itemCode,
      this.itemName,
      this.batchId,
      this.expiryDate,
      this.countQty,
      this.uomCode,
      this.uomName,
      this.userName,
      this.createDate});

  String? id;
  String? onhandId;
  String? itemCode;
  String? itemName;
  String? batchId;
  String? expiryDate;
  int? countQty;
  String? uomCode;
  String? uomName;
  String? userName;
  String? createDate;

  factory history.fromJson(Map<String, dynamic> json) => history(
      id: json["id"],
      onhandId: json["onhandId"],
      itemCode: json["itemCode"],
      itemName: json["itemName"],
      batchId: json["batchID"],
      expiryDate: json["expiryDate"],
      countQty: json["countQty"],
      uomCode: json["uomCode"],
      uomName: json["uomName"],
      userName: json["userName"],
      createDate: json["createDate"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "onhandId": onhandId,
        "itemCode": itemCode,
        "itemName": itemName,
        "batchID": batchId,
        "expiryDate": expiryDate,
        "countQty": countQty,
        "uomCode": uomCode,
        "uomName": uomName,
        "userName": userName,
        "createDate": createDate
      };
}
