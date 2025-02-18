import 'dart:developer';

import 'package:coin_project/ApiConnection/Api.dart';
import 'package:coin_project/ApiConnection/network.dart';
import 'package:coin_project/Screens/HomePage.dart';
import 'package:coin_project/Screens/login_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../AppColors/appColors.dart';
import '../Models/socialLoginModel.dart';
import '../widgets/txtfield.dart';

class ReferScreen extends StatefulWidget {
  const ReferScreen({Key? key}) : super(key: key);

  @override
  State<ReferScreen> createState() => _ReferScreenState();
}

class _ReferScreenState extends State<ReferScreen> {

   bool btnChange = false;
  TextEditingController username = TextEditingController();
  TextEditingController referCode = TextEditingController();
   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
   bool loading = true;
   String? userId , profileImage;
   late Future<Social_loginModel>socailLogin_obj;
   _socialLogin() async {
      setState(() {
        btnChange = true;
      });
      String? token = await FirebaseMessaging.instance.getToken();
      SharedPreferences preferences = await SharedPreferences.getInstance();
      var SUserID = preferences.getString('userId');
      var SUserEmail = preferences.getString('UserEmail');
      var  viLang = preferences.getString("vi");
      var  engLang = preferences.getString("en");
      var  zhLang = preferences.getString("zh");
      var  filLang = preferences.getString("fil");
      var  idLang = preferences.getString("id");
      var  koLang = preferences.getString("ko");
      String socailLoginUrl = Api.base_url + Api.social_login;
      debugPrint(" Socail Login :::::$socailLoginUrl");
      var language;
      if(zhLang == "zh"){
        language = zhLang;
        preferences.remove('en');
        preferences.remove('id');
        preferences.remove('fil');
        preferences.remove('ko');
        preferences.remove('vi');
        log("if part lnag${language}");
        setState(() {});
      }
      else if(filLang == "fil"){
        language = filLang;
        preferences.remove('id');
        preferences.remove('en');
        preferences.remove('ko');
        preferences.remove('vi');
        preferences.remove('zh');
        log("if part lnag${language}");
        setState(() {});
      }
      else if(idLang == "id"){
        language = idLang;
        preferences.remove('en');
        preferences.remove('ko');
        preferences.remove('vi');
        preferences.remove('zh');
        preferences.remove('fil');
        log("if part lnag${language}");
        setState(() {});
      }
      else if(koLang == "ko"){
        language = koLang;
        preferences.remove('en');
        preferences.remove('vi');
        preferences.remove('zh');
        preferences.remove('fil');
        preferences.remove('id');
        log("if part lnag${language}");
        setState(() {});
      }
      else if(viLang == "vi"){
        language = viLang;
        preferences.remove('en');
        preferences.remove('zh');
        preferences.remove('fil');
        preferences.remove('id');
        preferences.remove('ko');
        log("if part lnag${language}");
        setState(() {});
      }
      else if(engLang == "en"){
        language = engLang;
        preferences.remove('zh');
        preferences.remove('fil');
        preferences.remove('id');
        preferences.remove('ko');
        preferences.remove('vi');
        log("else part lnag${language}");
        setState(() {});
      }
      Map request = {
        "social_id" : SUserID.toString(),
        "social_type" : "google",
        "username" : username.text,
        "email" : SUserEmail,
        "app_token" : token,
        "api_username" : Api.api_username,
        "api_password" : Api.api_password,
        "referal_code":referCode.text
      };
      Map<String,String> data = {
        "Accept-Language":language
      };
      debugPrint("..................................................");
      debugPrint(" Socail Login map request:::::$request");
      log("my lan $data");
      debugPrint("..................................................");

      socailLogin_obj = ApiConnection().socailLogin(socailLoginUrl, request,data);
      await socailLogin_obj.then((value) {
        setState(() {
          btnChange = false;
        });
          if(value.status == 1)
            {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>const HomePage()));
                userId = value.result?.id.toString();
                profileImage = value.result?.profilePic;
                preferences.setString('UserID', userId!);
                preferences.setString('profileImage', profileImage!);
                log('user ID is :::::${value.result?.id}');
            }
          else
            {
              log('.......Not......Done.................${value.msg}');
              Fluttertoast.showToast(msg: value.msg.toString());
            }
      });
   }
   final GoogleSignIn _googleSignIn = new GoogleSignIn();
   final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Container(
        decoration:   const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.mainColor, AppColors.mainColor1])),
        child: GestureDetector(
          onTap: (){
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: height * 0.08),
                    Row(
                      children: [
                        InkWell(
                          onTap: (){
                            Navigator.pop(context,true);
                            _googleSignIn.signOut();
                            _auth.signOut();
                         //   Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: width * 0.05),
                            child:const Icon(Icons.arrow_back_ios_outlined,color: AppColors.black,size: 18),
                          ),
                        ),
                        SizedBox(width: width * 0.1),
                        Container(
                            child: Text('refer_screen_enter_username'.tr(),
                              style: TextStyle(color: AppColors.black,fontWeight: FontWeight.bold,fontSize: height * 0.025,fontFamily: 'Montserrat-Bold'),)
                        ),
                      ],
                    ),
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(top: height * 0.04,),
                        child: Text('refer_screen_unique_value'.tr(),textAlign: TextAlign.center,
                          style: TextStyle(color: AppColors.black,fontSize: height * 0.018,fontWeight: FontWeight.w400,height: 1.3,fontFamily: 'Montserrat'),),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: width * 0.08,right: width * 0.08,top: height * 0.05),
                      child: TextFormField(
                        inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'\s')),],
                        obscureText: false,
                        textAlign: TextAlign.justify,
                        validator: (value){
                          if (value == null || value.isEmpty) {
                            return 'username_required'.tr();
                          } else {
                            return null;
                          }
                        },
                        style: TextStyle(fontFamily: 'Montserrat',fontSize: height * 0.019),
                        controller: username,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            suffixIcon: Icon(Icons.person_outline_outlined,color: AppColors.black,),
                            hintStyle: TextStyle(fontFamily: 'Montserrat',fontSize:  height * 0.019),
                            enabledBorder:  OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(color: Colors.black, width: 1),
                            ),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15),
                                borderSide: const BorderSide(color: AppColors.black) ),
                            focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: AppColors.black,),
                                borderRadius: BorderRadius.circular(15)),
                            hintText: 'username'.tr()),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: width * 0.08,right: width * 0.08,top: height * 0.02),
                      child: txtField_widget(
                          obscureText: false,
                          validator: (value){
                            if (value == null || value.isEmpty) {
                              return 'refer_code_required'.tr();
                            } else {
                              return null;
                            }
                          },
                          textEditingController: referCode,
                          icon: Icon(Icons.people_outline,color: AppColors.black,),
                          text: 'refer_code'.tr(),inputType: TextInputType.emailAddress),
                    ),
                    SizedBox(height: height * 0.06),
                    Center(
                      child: Container(
                        height: height * 0.075,
                        width: width * 0.82,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                primary: AppColors.black,
                                elevation: 0.0
                            ),
                            onPressed: (){
                              if(_formKey.currentState!.validate()){
                                _socialLogin();
                              }

                            },
                            child: btnChange ?
                            SizedBox(
                              width: width * 0.1,
                              child: const LoadingIndicator(
                                indicatorType: Indicator.ballBeat,
                                colors: [
                                  AppColors.mainColor,
                                  AppColors.mainColor,
                                  AppColors.mainColor
                                ],
                                strokeWidth: 1,
                                pathBackgroundColor: Colors.black,
                              ),
                            )
                                : Text("register_page_create_account".tr(),style: TextStyle(
                                color: AppColors.white,
                                fontSize:  height * 0.022,
                                fontWeight: FontWeight.w500),)
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
