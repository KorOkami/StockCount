import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Token_Provider with ChangeNotifier {
  String token = "";

//ดึงข้อมูล Batch
  String getToken() {
    return token;
  }

  void addToken(String _token) {
    token = _token;
    //แจ้งเตือน consumer
    notifyListeners();
  }
}
