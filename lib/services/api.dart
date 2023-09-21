import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:stock_counting_app/interceptors/dio_interceptor.dart';
import 'package:stock_counting_app/model/bu_detail.dart';
import 'package:stock_counting_app/model/countingDetail.dart';
import 'package:stock_counting_app/model/countingDoc.dart';
import 'package:stock_counting_app/model/history_model.dart';
import 'package:stock_counting_app/model/itemMaster.dart';
import 'package:stock_counting_app/model/profile.dart';
import 'package:stock_counting_app/model/stockOnhand.dart';
import 'package:stock_counting_app/model/successlogin.dart';
import 'package:stock_counting_app/providers/batch_provider.dart';
import 'package:stock_counting_app/services/store.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert' as json;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:uuid/uuid.dart';

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
        String DeCodeToken = res.token;
        //Duration tokenTime = JwtDecoder.getTokenTime(DeCodeToken);
        DateTime expirationDate = JwtDecoder.getExpirationDate(DeCodeToken);
        Duration diff = expirationDate.difference(DateTime.now());
        //print(diff.inMinutes);

        Timer mytimer =
            Timer.periodic(Duration(minutes: diff.inMinutes - 2), (timer) {
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
    try {
      final response = await _dio.post(
          'https://inventory-uat.princhealth.com/api/account/refreshToken');
      if (response.statusCode == 200) {
        await _saveToken(response.data);
      }
    } on DioError catch (e) {
      print(e.response?.data);
    }
  }

  Future<List<StockOnhand>> GetBatchList(
      String bu_detail_Id, String itemCode) async {
    late List<StockOnhand> _StockOnhand = [];
    String _BatchListUrl =
        'https://inventory-uat.princhealth.com/api/stockcounts/${bu_detail_Id}/item?ItemCode=${itemCode}';
    try {
      final response = await _dio.get(_BatchListUrl);

      if (response.statusCode == 200) {
        response.data.forEach((e) {
          _StockOnhand.add(StockOnhand.fromJson(e));
        });
      }
    } on DioError catch (e) {
      print(e.response?.data);
    }

    return _StockOnhand;
  }

  Future<List<CountingDoc>> GetBU() async {
    late List<CountingDoc> _DocumentCounting = [];

    String _BuListUrl =
        'https://inventory-uat.princhealth.com/api/stockcounts/mobile';
    try {
      final response = await _dio.get(_BuListUrl);
      if (response.statusCode == 200) {
        //_DocumentCounting = countingDocFromJson(response.data);
        response.data.forEach((e) {
          _DocumentCounting.add(CountingDoc.fromJson(e));
        });
      }
    } on DioError catch (e) {
      print(e.response?.data);
    }

    return _DocumentCounting;
  }

  Future<String> AddStockActual(
      StockOnhand _stockOnhand, String _comments) async {
    ItemMaster _ItemMaster = ItemMaster();
    String result = "";
    var uuid = Uuid();
    String _AddActualUrl =
        'https://inventory-uat.princhealth.com/api/stockcounts/createactual';
    Map<String, dynamic> _actualdata = {
      "id": "${uuid.v4()}",
      "onhandId": "${_stockOnhand.id}",
      "countQty": _stockOnhand.countQty,
      "comments": _comments,
    };
    try {
      final response = await _dio.post(_AddActualUrl, data: _actualdata);
      if (response.statusCode == 200) {
        result = "success";
      }
    } on DioError catch (e) {
      result = "fail";
    }
    return result;
  }

  Future<String> updateComments(String _batchID, String _comments) async {
    String result = "";
    String _AddcommentsUrl =
        'https://inventory-uat.princhealth.com/api/StockCounts/editOnhandComments/${_batchID}';
    Map<String, dynamic> _commentsdata = {"comments": "${_comments}"};
    try {
      final response = await _dio.put(_AddcommentsUrl, data: _commentsdata);
      if (response.statusCode == 200) {
        result = "success";
      }
    } on DioError catch (e) {
      result = "fail";
    }
    return result;
  }

  Future<ResponseBatch?> AddBatchExpire(
      StockOnhand _stockOnhand, Batch batch) async {
    ResponseBatch res = new ResponseBatch("", "");
    ItemMaster _ItemMaster = ItemMaster();
    String result = "";
    var uuid = Uuid();
    String _AddBatchUrl =
        'https://inventory-uat.princhealth.com/api/stockcounts/createonhand';
    Map<String, dynamic> _AddBatchdata = {
      "id": "${uuid.v4()}",
      "stockCountId": "${_stockOnhand.stockcountid}",
      "lineNum": 0,
      "itemCode": "${_stockOnhand.itemCode}",
      "batchID": "${batch.batchNumber}",
      "expiryDate": "${batch.epireDate}",
      "qty": 0,
      "uomCode": "",
      "binLoc": ""
    };
    try {
      final response = await _dio.post(_AddBatchUrl, data: _AddBatchdata);
      if (response.statusCode == 200) {
        result = "success";
        res.status = "success";
      }
    } on DioError catch (e) {
      result = "fail";
      res.status = "fail";
      Map<String, dynamic> error_res = e.response?.data["errors"];
      res.ErrorM = error_res['error'][0];
      //print(e.response?.data);
    }
    return res;
  }

  Future<List<CountingDetail>> GetCountingDetail(String onHandID) async {
    List<CountingDetail> _countingDetail = [];
    String result = "";
    String _countingDetailhUrl =
        'https://inventory-uat.princhealth.com/api/stockcounts/onhands/${onHandID}/actuals';
    try {
      final response = await _dio.get(_countingDetailhUrl);
      if (response.statusCode == 200) {
        response.data.forEach((e) {
          _countingDetail.add(CountingDetail.fromJson(e));
        });
      }
    } on DioError catch (e) {
      print(e.response?.data);
    }

    return _countingDetail;
  }

  Future<String> EditCountingDetail(
      String actualID, String countedQty, String _comments) async {
    String result = "";
    String _editCountingUrl =
        'https://inventory-uat.princhealth.com/api/stockcounts/editactual/${actualID}?countQty=${countedQty}&comments=${_comments}';
    try {
      final response = await _dio.put(_editCountingUrl);
      if (response.statusCode == 200) {
        result = "success";
      }
    } on DioError catch (e) {
      result = "fail";
      print(e.response?.data);
    }
    return result;
  }

  Future<String> EditCountingDetail_comments(
      String actualID, String comments) async {
    String result = "";
    String _editCountingUrl =
        'https://inventory-uat.princhealth.com/api/stockcounts/editactualcomments/${actualID}?comments=${comments}';
    try {
      final response = await _dio.put(_editCountingUrl);
      if (response.statusCode == 200) {
        result = "success";
      }
    } on DioError catch (e) {
      result = "fail";
      print(e.response?.data);
    }
    return result;
  }

  /*Future<String> DeleteCountingDetail(String actualID) async {
    String result = "";
    String _deleteCountingUrl =
        'https://inventory-uat.princhealth.com/api/stockcounts/deleteactual/${actualID}';

    try {
      final response = await _dio.delete(_deleteCountingUrl);
      if (response.statusCode == 200) {
        result = "success";
      }
    } on DioError catch (e) {
      result = "fail";
      print(e.response?.data);
    }
    return result;
  }*/

  Future<List<history>> GetHistory(String bu_detail_Id, String username) async {
    late List<history> _history = [];
    String _historyListUrl =
        'https://inventory-uat.princhealth.com/api/stockcounts/${bu_detail_Id}/history?username=${username}';
    try {
      final response = await _dio.get(_historyListUrl);

      if (response.statusCode == 200) {
        response.data.forEach((e) {
          _history.add(history.fromJson(e));
        });
      }
    } on DioError catch (e) {
      print(e.response?.data);
    }

    return _history;
  }

  Future<ItemMaster> GetItemMaster(String _itemCode) async {
    String result = "";
    ItemMaster _ItemMaster = ItemMaster();
    String _GetItemMasterUrl =
        'https://inventory-uat.princhealth.com/api/itemmasters/${_itemCode}';
    try {
      final response = await _dio.get(_GetItemMasterUrl);
      if (response.statusCode == 200) {
        _ItemMaster.code = response.data['code'];
        _ItemMaster.name = response.data['name'];
        _ItemMaster.uomCode = response.data['uomCode'];
        _ItemMaster.uomName = response.data['uomName'];
      }
    } on DioError catch (e) {
      // print(e.response?.data);
      _ItemMaster.code = "";
      _ItemMaster.name = "";
      _ItemMaster.uomCode = "";
      _ItemMaster.uomName = "";
    }
    return _ItemMaster;
  }

  Future<ResponseBatch?> AddNewItem(
      String stockcountid, String itemCode, Batch batch) async {
    ResponseBatch res = new ResponseBatch("", "");
    ItemMaster _ItemMaster = ItemMaster();
    String result = "";
    var uuid = Uuid();
    String _AddNewItemUrl =
        'https://inventory-uat.princhealth.com/api/stockcounts/createonhand';
    Map<String, dynamic> _AddItemdata;
    if (batch.epireDate != null) {
      _AddItemdata = {
        "id": "${uuid.v4()}",
        "stockCountId": "${stockcountid}",
        "lineNum": 0,
        "itemCode": "${itemCode}",
        "batchID": "${batch.batchNumber}",
        "expiryDate": "${batch.epireDate}",
        "qty": 0,
        "uomCode": "",
        "binLoc": ""
      };
    } else {
      _AddItemdata = {
        "id": "${uuid.v4()}",
        "stockCountId": "${stockcountid}",
        "lineNum": 0,
        "itemCode": "${itemCode}",
        "qty": 0,
        "uomCode": "",
        "binLoc": ""
      };
    }

    try {
      final response = await _dio.post(_AddNewItemUrl, data: _AddItemdata);
      if (response.statusCode == 200) {
        result = "success";
        res.status = "success";
      }
    } on DioError catch (e) {
      result = "fail";
      res.status = "fail";
      Map<String, dynamic> error_res = e.response?.data["errors"];
      res.ErrorM = error_res['error'][0];
      //print(e.response?.data);
    }
    return res;
  }
}
