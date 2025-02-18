import 'package:flutter/material.dart';
class RadioButtonClass extends StatelessWidget {
  final Widget widget;
  const RadioButtonClass({Key? key, required this.widget}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Color(0xFFD3D3D3).withOpacity(0.1),
          borderRadius: BorderRadius.circular(12)),
      height: height * 0.080,
      width: width * 0.9,
      margin: EdgeInsets.only(
          top: height * 0.02, left: width * 0.04, right: width * 0.04),
      child: widget
    );
  }
}
