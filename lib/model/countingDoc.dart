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
    this.businessUnit,
    this.warehouse,
    this.controlLot,
    this.remarks,
    this.status,
  });

  String? id;
  String? docNum;
  DateTime? docDate;
  String? businessUnit;
  String? warehouse;
  String? controlLot;
  String? remarks;
  String? status;

  factory CountingDoc.fromJson(Map<String, dynamic> json) => CountingDoc(
        id: json["id"],
        docNum: json["docNum"],
        docDate:
            json["docDate"] == null ? null : DateTime.parse(json["docDate"]),
        businessUnit: json["businessUnit"],
        warehouse: json["warehouse"],
        controlLot: json["controlLot"],
        remarks: json["remarks"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "docNum": docNum,
        "docDate": docDate?.toIso8601String(),
        "businessUnit": businessUnit,
        "warehouse": warehouse,
        "controlLot": controlLot,
        "remarks": remarks,
        "status": status,
      };
}
