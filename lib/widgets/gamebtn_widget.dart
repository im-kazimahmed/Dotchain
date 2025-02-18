import 'package:flutter/material.dart';

class gameBtnWidget extends StatelessWidget {
  final String gamename;
  final String gamebalance;
  final Function ontap ;
  const gameBtnWidget({Key? key,required this.gamename,required this.gamebalance,required this.ontap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.03),
          width: MediaQuery.of(context).size.width * 0.45,
          child: InkWell(
            onTap: (){
              ontap();
            },
            child: Text(
              gamename,
              style: TextStyle(
                fontSize:MediaQuery.of(context).size. height * 0.02,
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat',
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: MediaQuery.of(context).size.width  *0.03, right:MediaQuery.of(context).size. width*  0.02),
          child: InkWell(
            onTap: (){
              ontap();
            },
            child: Text(
              gamebalance,
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.height * 0.02,
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat-Bold',
              ),
            ),
          ),
        ),
        Image.asset('assets/images/dashboard.png'),
      ],
    );
  }
}
