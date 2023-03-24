import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class Counting_View extends StatefulWidget {
  const Counting_View({super.key, required this.Name});
  final String? Name;

  @override
  State<Counting_View> createState() => _Counting_ViewState();
}

class _Counting_ViewState extends State<Counting_View> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("${widget.Name}"),
    );
  }
}
