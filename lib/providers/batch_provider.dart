import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stock_counting_app/model/stockOnhand.dart';

class Batch_Provider with ChangeNotifier {
  List<StockOnhand> bList = [];

//ดึงข้อมูล Batch
  List<StockOnhand> getBatchStockOnhand() {
    return bList;
  }

  void addBatchStockOnhand(StockOnhand batchOnhand) {
    bList.add(batchOnhand);
  }
}
