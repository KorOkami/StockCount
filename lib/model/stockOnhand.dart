// To parse this JSON data, do
//
//     final stockOnhand = stockOnhandFromJson(jsonString);

import 'dart:convert';

List<StockOnhand> stockOnhandFromJson(String str) => List<StockOnhand>.from(
    json.decode(str).map((x) => StockOnhand.fromJson(x)));

String stockOnhandToJson(List<StockOnhand> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class StockOnhand {
  StockOnhand({
    this.id,
    this.lineNum,
    this.itemCode,
    this.itemName,
    this.binLoc,
    this.batchId,
    this.expiryDate,
    this.qty,
    this.uomCode,
    this.uomName,
    this.cost,
    this.total,
    this.countQty,
    this.diffQty,
    this.diffTotal,
  });

  String? id;
  int? lineNum;
  String? itemCode;
  String? itemName;
  String? binLoc;
  String? batchId;
  String? expiryDate;
  int? qty;
  String? uomCode;
  String? uomName;
  double? cost;
  double? total;
  int? countQty;
  int? diffQty;
  double? diffTotal;

  factory StockOnhand.fromJson(Map<String, dynamic> json) => StockOnhand(
        id: json["id"],
        lineNum: json["lineNum"],
        itemCode: json["itemCode"],
        itemName: json["itemName"],
        binLoc: json["binLoc"],
        batchId: json["batchID"],
        expiryDate: json["expiryDate"],
        qty: json["qty"],
        uomCode: json["uomCode"],
        uomName: json["uomName"],
        cost: json["cost"],
        total: json["total"]?.toDouble(),
        countQty: json["countQty"],
        diffQty: json["diffQty"],
        diffTotal: json["diffTotal"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "lineNum": lineNum,
        "itemCode": itemCode,
        "itemName": itemName,
        "binLoc": binLoc,
        "batchID": batchId,
        "expiryDate": expiryDate,
        "qty": qty,
        "uomCode": uomCode,
        "uomName": uomName,
        "cost": cost,
        "total": total,
        "countQty": countQty,
        "diffQty": diffQty,
        "diffTotal": diffTotal,
      };
}
