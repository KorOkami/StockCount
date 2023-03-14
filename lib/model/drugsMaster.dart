// To parse this JSON data, do
//
//     final drugs = drugsFromJson(jsonString);

import 'dart:convert';

List<Drugs> drugsFromJson(String str) =>
    List<Drugs>.from(json.decode(str).map((x) => Drugs.fromJson(x)));

String drugsToJson(List<Drugs> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Drugs {
  Drugs({
    this.id,
    this.code,
    this.genericName,
    //this.purchasingUom,
    //this.inventoryUom,
  });

  String? id;
  String? code;
  String? genericName;
  // String? purchasingUom;
  //String? inventoryUom;

  factory Drugs.fromJson(Map<String, dynamic> json) => Drugs(
        id: json["id"],
        code: json["code"],
        genericName: json["genericName"],
        //purchasingUom: json["purchasingUom"],
        //inventoryUom: json["inventoryUom"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "genericName": genericName,
        //"purchasingUom": purchasingUom,
        //"inventoryUom": inventoryUom,
      };
}
