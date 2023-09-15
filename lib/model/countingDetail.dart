// To parse this JSON data, do
//
//     final countingDetail = countingDetailFromJson(jsonString);

import 'dart:convert';

List<CountingDetail> countingDetailFromJson(String str) =>
    List<CountingDetail>.from(
        json.decode(str).map((x) => CountingDetail.fromJson(x)));

String countingDetailToJson(List<CountingDetail> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CountingDetail {
  CountingDetail({
    this.id,
    this.itemCode,
    this.batchId,
    this.expiryDate,
    this.countQty,
    this.userName,
    //this.comments,
  });

  String? id;
  String? itemCode;
  String? batchId;
  String? expiryDate;
  int? countQty;
  String? userName;
  //String? comments;

  factory CountingDetail.fromJson(Map<String, dynamic> json) => CountingDetail(
        id: json["id"],
        itemCode: json["itemCode"],
        batchId: json["batchID"],
        expiryDate: json["expiryDate"],
        countQty: json["countQty"],
        userName: json["userName"],
        //userName: json["userName"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "itemCode": itemCode,
        "batchID": batchId,
        "expiryDate": expiryDate,
        "countQty": countQty,
        "userName": userName,
      };
}
