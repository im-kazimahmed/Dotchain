import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../AppColors/appColors.dart';

class gameRewardWidget  extends StatelessWidget {
  final String btnText;
  final Function btnOnClick;
  const gameRewardWidget ({Key? key,required this.btnText,required this.btnOnClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.03,),
        width:  MediaQuery.of(context).size.width * 0.65,height:  MediaQuery.of(context).size.height * 0.050,
        child: ElevatedButton(
         style: ElevatedButton.styleFrom(
           primary: AppColors.mainColor1,
           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
         ),
          onPressed: (){
           btnOnClick();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('claim_rewards_text'.tr(),style: TextStyle(color: AppColors.black,fontSize:  MediaQuery.of(context).size.height * 0.015, fontWeight: FontWeight.bold, fontFamily: 'Montserrat',),),
              SizedBox(width: MediaQuery.of(context).size. width * 0.03),
              Image.asset('assets/images/dashboard.png'),
              SizedBox(width:  MediaQuery.of(context).size.width * 0.03),
              Text(
                btnText,
                style: TextStyle(
                  color: AppColors.black,
                  fontSize:  MediaQuery.of(context).size.height * 0.02,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Montserrat-Bold',
                ),
              ),
            ],
          ),
        )
    );
  }
}


