import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:stock_counting_app/interceptors/dio_interceptor.dart';
import 'package:stock_counting_app/model/bu_detail.dart';
import 'package:stock_counting_app/model/profile.dart';
import 'package:stock_counting_app/model/stockOnhand.dart';
import 'package:stock_counting_app/model/successlogin.dart';
import 'package:stock_counting_app/services/store.dart';

class stockCountingAPI {
  late final Dio _dio;

  stockCountingAPI() {
    _dio = Dio();
    _dio.interceptors.add(DioInterceptor());
  }

  final String _loginUrl =
      'https://inventory-uat.princhealth.com/api/account/login';

  Future<void> _saveToken(Map<String, dynamic> data) async {
    final token = data['token'];
    await Store.setToken(token);
  }

  Future<ResponseLogin?> dioLogin(String user, String password) async {
    ResponseLogin res = new ResponseLogin("", "", "", "");
    Successlogin? _successData;
    Map<String, dynamic> _logindata = {
      "email": "$user",
      "password": "$password"
    };
    final response = await _dio.post(_loginUrl, data: _logindata);
    if (response.statusCode == 200) {
      await _saveToken(response.data);
      //successloginFromJson(response.data);
      res.status = "success";
      res.token = response.data['token'];
      res.username = response.data['userName'];
      return res;
    } else {
      return res;
    }
  }

  Future<List<StockOnhand>> GetBatchList(
      String bu_detail_Id, String itemCode) async {
    late List<StockOnhand> _StockOnhand = List.empty();
    String _BatchListUrl =
        'https://inventory-uat.princhealth.com/api/stockcounts/${bu_detail_Id}/item?ItemCode=${itemCode}';
    final response = await _dio.get(_BatchListUrl);

    if (response.statusCode == 200) {
      //_StockOnhand = stockOnhandFromJson(Response.body);
    } else {
      String test = "";
    }
    return _StockOnhand;
  }
}
