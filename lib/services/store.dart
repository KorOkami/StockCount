import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Store {
  const Store._();

  static const String _TokenKey = "TOKEN";

  static Future<void> setToken(String token) async {
    final preferense = await SharedPreferences.getInstance();

    await preferense.setString(_TokenKey, token);
  }

  static Future<String?> getToken() async {
    final preferense = await SharedPreferences.getInstance();

    return preferense.getString(_TokenKey);
  }

  static Future<void> clear() async {
    final preferense = await SharedPreferences.getInstance();
    await preferense.clear();
  }
}
