import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stock_counting_app/model/stockOnhand.dart';

class Batch_Provider with ChangeNotifier {
  List<StockOnhand> bList = [
    new StockOnhand(itemCode: "", itemName: "", uomCode: "", uomName: "")
  ];

  List<StockOnhand> ClearBatchStockOnhand(
      String itmCode, String itmName, String uom) {
    bList = [
      new StockOnhand(
          itemCode: "${itmCode}", itemName: "${itmName}", uomName: "${uom}")
    ];
    return bList;
  }

//ดึงข้อมูล Batch
  List<StockOnhand> getBatchStockOnhand() {
    return bList;
  }

  void addBatchStockOnhand(List<StockOnhand> batchOnhand) {
    bList = batchOnhand;
    //แจ้งเตือน consumer
    notifyListeners();
  }
}
