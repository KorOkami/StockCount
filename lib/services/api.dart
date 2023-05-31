import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:stock_counting_app/interceptors/dio_interceptor.dart';
import 'package:stock_counting_app/model/bu_detail.dart';
import 'package:stock_counting_app/model/countingDoc.dart';
import 'package:stock_counting_app/model/profile.dart';
import 'package:stock_counting_app/model/stockOnhand.dart';
import 'package:stock_counting_app/model/successlogin.dart';
import 'package:stock_counting_app/services/store.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert' as json;

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
    try {
      final response = await _dio.post(_loginUrl, data: _logindata);
      if (response.statusCode == 200) {
        await _saveToken(response.data);
        //successloginFromJson(response.data);
        res.status = "success";
        res.token = response.data['token'];
        res.username = response.data['userName'];
        Timer mytimer = Timer.periodic(Duration(minutes: 1), (timer) {
          refershtoken();
          //mytimer.cancel() //to terminate this timer
        });
        return res;
      }
    } on DioError catch (e) {
      res.status = "fail";
      res.ErrorM = e.response?.data;
      return res;
    }
  }

  Future<void> refershtoken() async {
    /*var headers = {
      'Content-Type': 'application/json',
      'Cookie': 'refreshToken=l9lbOu2%2BQ08KTAKEUHqYe9fwywz6Rz5TKeXP7yQV2p0%3D'
    };*/

    final response = await _dio
        .post('https://inventory-uat.princhealth.com/api/account/refreshToken');
    if (response.statusCode == 200) {
      await _saveToken(response.data);
    } else {}
  }

  Future<List<StockOnhand>> GetBatchList(
      String bu_detail_Id, String itemCode) async {
    late List<StockOnhand> _StockOnhand = [];
    String _BatchListUrl =
        'https://inventory-uat.princhealth.com/api/stockcounts/${bu_detail_Id}/item?ItemCode=${itemCode}';
    final response = await _dio.get(_BatchListUrl);

    if (response.statusCode == 200) {
      response.data.forEach((e) {
        _StockOnhand.add(StockOnhand.fromJson(e));
      });
      //_StockOnhand = stockOnhandFromJson(Response.body);
    } else {
      String test = "";
    }
    return _StockOnhand;
  }

  Future<List<CountingDoc>> GetBU() async {
    late List<CountingDoc> _DocumentCounting = [];

    String _BuListUrl =
        'https://inventory-uat.princhealth.com/api/stockcounts/mobile';
    final response = await _dio.get(_BuListUrl);
    if (response.statusCode == 200) {
      //_DocumentCounting = countingDocFromJson(response.data);
      response.data.forEach((e) {
        _DocumentCounting.add(CountingDoc.fromJson(e));
      });
    } else {}
    return _DocumentCounting;
  }
}
