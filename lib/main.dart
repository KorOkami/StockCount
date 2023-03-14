import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:grpo_app/screen/home.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as json;
import 'dart:io';
import 'dart:async';

import 'package:stock_counting_app/screen/login.dart';

void main() {
  HttpOverrides.global = new MyHttpOverrides(); // for Https
  WidgetsFlutterBinding
      .ensureInitialized(); // block mobile portrait แนวตั้งแนว นอน
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "May App",
      home: LoginScreen(),
      theme: ThemeData(primarySwatch: Colors.lightBlue),
    );
  }
}
