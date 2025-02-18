import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class NavBar_Widget extends StatelessWidget {

  final String text;
  final Color color;
  final Color imagecolor;
  final String assetName;
  const NavBar_Widget({Key? key,required this.text,required this.color,required this.assetName,required this.imagecolor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Container(
      margin:const EdgeInsets.only(top: 10),
      child: Column(
        children: [
          SizedBox(
              child:Container(
                margin: EdgeInsets.only(top:8,bottom:8),
                child: SvgPicture.asset(assetName,fit: BoxFit.contain,color: imagecolor,),
              )),
          Text(text,style: TextStyle(color: color,fontWeight: FontWeight.bold,fontSize: height * 0.012,fontFamily: 'Montserrat-Bold'),)
        ],
      ),
    );
  }
}
