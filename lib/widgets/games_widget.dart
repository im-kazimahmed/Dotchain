import 'package:flutter/material.dart';

class gamesWidget extends StatelessWidget {

  final Function btnOnClick;
  final String image;
  final Widget widget;

  const gamesWidget({Key? key,required this.btnOnClick,required this.image,required this.widget}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  InkWell(
        onTap: () { btnOnClick();},
        child: Container(
          margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05, right: MediaQuery.of(context).size.width * 0.05,top: MediaQuery.of(context).size.height* 0.01),
          child: Row(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.080,
                width: MediaQuery.of(context).size.width * 0.2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Image.asset(image, fit: BoxFit.contain),
              ),
              widget
            ],
          ),
        )
    );
  }
}
