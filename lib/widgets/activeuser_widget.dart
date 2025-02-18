import 'package:coin_project/AppColors/appColors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class activeUser_widget extends StatelessWidget {

  final String nameText;
  final Color activeColor;
  final Function btnOnClick;
  String image;
  String USerImage;


   activeUser_widget({Key? key,required this.nameText,required this.activeColor,required this.image,required this.USerImage, required this.btnOnClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
          margin: EdgeInsets.only(bottom: height * 0.003),
          color: AppColors.lightGray.withOpacity(0.2),
          height: height * 0.1,
          child: Row(
              children: [
                  Stack(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: width * 0.02),
                        height: height * 0.070,width: width * 0.15,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: AppColors.lightGray
                        ),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image.network(USerImage,fit: BoxFit.cover),
                        )
                      ),
                      // Container(
                      //   margin: EdgeInsets.only(left: width * 0.13,top: height * 0.053),
                      //   height: 12,width: 12,
                      //   decoration: BoxDecoration(borderRadius: BorderRadius.circular(100),color: activeColor),
                      // ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(left: width * 0.05),
                    width: width * 0.4,
                    child: Text(nameText,style: TextStyle(fontWeight: FontWeight.w500,fontSize: height * 0.019,fontFamily: 'Montserrat',),),
                  ),
                  InkWell(
                    onTap: (){
                      btnOnClick.call();
                    },
                    child: Container(
                      width: width * 0.3,height: height * 0.045,
                      decoration: BoxDecoration(
                        color: AppColors.black,
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                                SvgPicture.asset(image,color: AppColors.white,width: 12,height: 12),
                                SizedBox(width: width * 0.02,),
                                Text('start_chat'.tr(),style: TextStyle(fontSize: height * 0.011,color: AppColors.white,fontFamily: 'Montserrat',),)
                           ],
                      ),
                    ),
                  ),
              ],
          ),
    );
  }
}
