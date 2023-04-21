// To parse this JSON data, do
//
//     final itemMaster = itemMasterFromJson(jsonString);

import 'dart:convert';

ItemMaster itemMasterFromJson(String str) =>
    ItemMaster.fromJson(json.decode(str));

String itemMasterToJson(ItemMaster data) => json.encode(data.toJson());

class ItemMaster {
  ItemMaster({
    this.code,
    this.name,
    this.uomCode,
  });

  String? code;
  String? name;
  String? uomCode;

  factory ItemMaster.fromJson(Map<String, dynamic> json) => ItemMaster(
        code: json["code"],
        name: json["name"],
        uomCode: json["uomCode"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "name": name,
        "uomCode": uomCode,
      };
}

class Batch {
  Batch({
    this.batchNumber,
    this.epireDate,
  });
  String? batchNumber;
  String? epireDate;
}
