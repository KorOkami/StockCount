import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import 'package:http/http.dart' as http;
import 'package:stock_counting_app/model/bu_detail.dart';
import 'dart:convert' as json;
import 'dart:io';
import 'dart:async';

import 'package:stock_counting_app/model/countingDetail.dart';

class Counting_Detail extends StatefulWidget {
  const Counting_Detail(
      {super.key, required this.token, required this.onHandId});
  final String? token;
  final String? onHandId;
  @override
  State<Counting_Detail> createState() => _Counting_DetailState();
}

class _Counting_DetailState extends State<Counting_Detail> {
  late List<CountingDetail> countingDetailList;

  Future<String> GetCountingDetail(String OnhandID) async {
    List<CountingDetail> _countingDetail;
    String result = "";
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${widget.token}',
      'Cookie':
          'refreshToken=p%2BBKUP28N7C%2BrTHUlBMM%2FUPeHg55hQD7KmLkNLZrduo%3D'
    };
    var request = http.Request(
        'GET',
        Uri.parse(
            'http://172.24.9.24:5000/api/stockcounts/actuals/${OnhandID}'));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    var Response = await http.Response.fromStream(response);
    if (response.statusCode == 200) {
      _countingDetail = countingDetailFromJson(Response.body);
      setState(() {
        countingDetailList = _countingDetail;
      });
    } else {
      //showAlertDialog(context, "Item not found.");
      setState(() {});
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
