import 'package:coin_project/Screens/HomePage.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../AppColors/appColors.dart';
import 'login_page.dart';
class VerificationScreen extends StatefulWidget {
  const VerificationScreen({Key? key}) : super(key: key);

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        body: Container(
          decoration:  BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomRight,
                  colors: [AppColors.mainColor, AppColors.mainColor1]
              )
          ),
          child: Column(
            children: [
              SizedBox(height: height * 0.07),
              Stack(
                children: [
                  Row(
                    children: [
                      SizedBox(width: 20),
                      InkWell(
                          onTap: (){
                            Navigator.pop(context);
                            },
                                child: Icon(Icons.arrow_back_ios_outlined,color: AppColors.black,size: 18)),
                    ],
                  ),
                  Center(
                    child: Container(
                      child: Text("registration_success".tr(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                fontFamily: 'Montserrat-Bold',
                              ),),
                          ),
                  )
                ],
              ),
              SizedBox(height: height * 0.05),
              Container(
                child: Text("verification_screen_text1".tr(),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: height * 0.018,
                      fontFamily: 'Montserrat'),
                ),
              ),
              SizedBox(height: height * 0.04),
              Container(
                child: Text("verification_screen_text2".tr(),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: height * 0.018,
                      fontFamily: 'Montserrat'),
                ),
              ),
              SizedBox(height: height * 0.04),
              Center(
                child: Container(
                  height: height * 0.075,
                  width: width * 0.82,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          primary: AppColors.black,
                          elevation: 0.0),
                      onPressed: ()async{
                        Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage(),));
                        },
                      child: Text("to_login".tr(),
                          style: TextStyle(color: AppColors.white, fontSize:  height * 0.022, fontWeight: FontWeight.w500)
                      )
                  ),
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}

