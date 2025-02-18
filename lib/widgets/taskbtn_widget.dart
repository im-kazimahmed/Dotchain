import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class taskBtnWidget extends StatelessWidget {
  final String gamebalance;
  final isCompleted;
  const taskBtnWidget({Key? key,required this.gamebalance, required this.isCompleted}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          margin: EdgeInsets.only(left: MediaQuery.of(context).size.width  *0.03, right:MediaQuery.of(context).size. width*  0.02),
          child: Text(
            !isCompleted ? gamebalance: '',
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.height * 0.02,
              fontWeight: FontWeight.bold,
              fontFamily: 'Montserrat-Bold',
            ),
          ),
        ),
        if(isCompleted)
          Text('task_screen_completed'.tr())
        else
          Image.asset('assets/images/dashboard.png'),
      ],
    );
  }
}
