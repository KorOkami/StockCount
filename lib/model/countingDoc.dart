// To parse this JSON data, do
//
//     final countingDoc = countingDocFromJson(jsonString);

import 'dart:convert';

List<CountingDoc> countingDocFromJson(String str) => List<CountingDoc>.from(
    json.decode(str).map((x) => CountingDoc.fromJson(x)));

String countingDocToJson(List<CountingDoc> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CountingDoc {
  CountingDoc({
    this.id,
    this.docNum,
    this.docDate,
    this.buCode,
    this.buName,
    this.whsCode,
    this.whsName,
    this.controlLot,
    this.remarks,
    this.status,
  });

  String? id;
  String? docNum;
  DateTime? docDate;
  String? buCode;
  String? buName;
  String? whsCode;
  String? whsName;
  String? controlLot;
  String? remarks;
  String? status;

  factory CountingDoc.fromJson(Map<String, dynamic> json) => CountingDoc(
        id: json["id"],
        docNum: json["docNum"],
        docDate:
            json["docDate"] == null ? null : DateTime.parse(json["docDate"]),
        buCode: json["buCode"],
        buName: json["buName"],
        whsCode: json["whsCode"],
        whsName: json["whsName"],
        controlLot: json["controlLot"],
        remarks: json["remarks"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "docNum": docNum,
        "docDate": docDate?.toIso8601String(),
        "buCode": buCode,
        "buName": buName,
        "whsCode": whsCode,
        "whsName": whsName,
        "controlLot": controlLot,
        "remarks": remarks,
        "status": status,
      };

  String userAsString() {
    // String BUName = "";
    // if (buName!.length >= 18) {
    //   BUName = buName!.substring(0, 18) + "...";
    // } else {
    //   BUName = buName!;
    // }
    return '${this.buCode}(${buName}) \n- ${this.whsCode}(${whsName})';
  }
}
