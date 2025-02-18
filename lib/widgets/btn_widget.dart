import 'package:flutter/material.dart';

class btn_widget extends StatelessWidget {

  final String btntext;
  final Color color;
  final Function onTap;
  final TextStyle textStyle;
  final RoundedRectangleBorder roundedRectangleBorder;

  const btn_widget({Key? key,required this.btntext,required this.color,required this.onTap,required this.textStyle,required this.roundedRectangleBorder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Center(
      child: Container(
          height: height * 0.075,
          width: width * 0.82,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: color,
              elevation: 0.0,
              shape: roundedRectangleBorder,
            ),
            onPressed: (){
                onTap();
              },
              child: Text(btntext,style: textStyle),
          ),
      ),
    );
  }
}
