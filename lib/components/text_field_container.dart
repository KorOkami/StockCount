import 'package:flutter/material.dart';

class TextFormFieldContainer extends StatelessWidget {
  final Widget child;
  const TextFormFieldContainer({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 35, vertical: 4),
      width: size.width,
      decoration: BoxDecoration(
          color: Color.fromARGB(255, 183, 231, 253),
          borderRadius: BorderRadius.circular(20)),
      child: child,
    );
  }
}

class TextFormFieldContainerRegister extends StatelessWidget {
  final Color colors;
  final Widget child;
  const TextFormFieldContainerRegister({
    super.key,
    required this.child,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 4),
      width: size.width,
      decoration:
          BoxDecoration(color: colors, borderRadius: BorderRadius.circular(20)),
      child: child,
    );
  }
}

//Color.fromARGB(255, 217, 242, 253),
