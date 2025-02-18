import 'dart:async';
import 'dart:developer';
import 'package:coin_project/ApiConnection/Api.dart';
import 'package:coin_project/ApiConnection/network.dart';
import 'package:coin_project/Models/EmailOTPVerifyModel.dart';
import 'package:coin_project/Models/resendOTPModel.dart';
import 'package:coin_project/Screens/login_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../AppColors/appColors.dart';
import '../widgets/OTP_widget.dart';

class VerifyOTPScreen extends StatefulWidget {
  const VerifyOTPScreen({Key? key}) : super(key: key);

  @override
  State<VerifyOTPScreen> createState() => _VerifyOTPScreenState();
}

class _VerifyOTPScreenState extends State<VerifyOTPScreen> {

 TextEditingController pin1 = TextEditingController();
 TextEditingController pin2 = TextEditingController();
 TextEditingController pin3 = TextEditingController();
 TextEditingController pin4 = TextEditingController();

 String? Email;

 @override
 void initState() {
   super.initState();
   getUserData();
   startTimer();
 }

 bool clicked = false,first = false,last = false;
 Timer? _timer, _timer1;
 int _start = 36 , _start1 = 36;

 void startTimer() {
   const oneSec =  Duration(seconds: 1);
   _timer =  Timer.periodic(
     oneSec,
         (Timer timer) {
       if (_start == 0) {
         setState(() {
           timer.cancel();
         });
       } else {
         setState(() {
           _start--;
         });
       }
     },
   );
 }

 void startTimer1() {
   const oneSec =  Duration(seconds: 1);
   _timer1 =  Timer.periodic(
     oneSec,
         (Timer timer) {
       if (_start1 == 0) {
         setState(() {
           timer.cancel();
         });
       } else {
         setState(() {
           _start1--;
         });
       }
     },
   );
 }

 @override
 void dispose() {
   _timer?.cancel();
   super.dispose();
 }

 getUserData()async{
   SharedPreferences preferences = await SharedPreferences.getInstance();
   Email = preferences.getString('UserEmail');
   setState(() {});
 }

 bool loading = false,btnChange = false;
  Future<VerifyOTPModel> ? verifyObj;
 _verifyOTP() async {
      setState(() {
        loading = true;
      });
      SharedPreferences preferences = await SharedPreferences.getInstance();
      var UserID = preferences.getString('UserID');
      var  viLang = preferences.getString("vi");
      var  engLang = preferences.getString("en");
      var  zhLang = preferences.getString("zh");
      var  filLang = preferences.getString("fil");
      var  idLang = preferences.getString("id");
      var  koLang = preferences.getString("ko");
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
      String OTPUrl = Api.base_url + Api.verifyOTP;
      Map res = {
          'user_id' : UserID.toString(),
          'email_otp' : pin1.text+pin2.text+pin3.text+pin4.text,
          'api_username' : Api.api_username,
          'api_password' : Api.api_password,
      };
      Map<String,String> data = {
        "Accept-Language":language
      };
      log("my lan $data");
      verifyObj = ApiConnection().verifyOTP(OTPUrl, res,data);
    await verifyObj!.then((value){
        setState(() {
          loading = false;
        });
        if(value.status == 1){
          Fluttertoast.showToast(msg: "Register Successfully");
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>const LoginPage()));
        }
        else{
          Fluttertoast.showToast(msg: "Invalid OTP");
        }
      });
  }
  late Future<ResendOTPModel> resendOTP_obj;
 _resendOTP() async {
   setState(() {
     btnChange = true;
   });

   SharedPreferences preferences = await SharedPreferences.getInstance();
   var UserId = preferences.getString('UserID');
   var  viLang = preferences.getString("vi");
   var  engLang = preferences.getString("en");
   var  zhLang = preferences.getString("zh");
   var  filLang = preferences.getString("fil");
   var  idLang = preferences.getString("id");
   var  koLang = preferences.getString("ko");
   String ResendOTPUrl = Api.base_url + Api.resendOTP;
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
   Map Request = {
     "id" : UserId,
     "api_username" : Api.api_username,
     "api_password" : Api.api_password,
   };
   Map<String,String> data = {
     "Accept-Language":language
   };
   log("my lan $data");
   resendOTP_obj = ApiConnection().resendOTP(ResendOTPUrl, Request,data);
   await resendOTP_obj.then((response) {
     setState(() {
       btnChange = false;
     });
     if(response.status == 1)
     {
       startTimer1();
       Fluttertoast.showToast(msg: response.msg.toString());
     }
     else
     {
       Fluttertoast.showToast(msg: response.msg.toString());
     }
   });


 }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.mainColor, AppColors.mainColor1])),
        child: GestureDetector(
          onTap: () {FocusManager.instance.primaryFocus?.unfocus();},
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: height * 0.08),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                              left: width * 0.05, bottom: height * 0.03),
                          child: const Icon(Icons.arrow_back_ios_outlined,
                              color: AppColors.black, size: 18),
                        ),
                      ),
                      SizedBox(width:width * 0.1),
                      Container(
                          child:  Text(
                        'we_need_verify_your_email'.tr(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: height * 0.025,
                          fontFamily: 'Montserrat-Bold',
                        ),
                      )),
                    ],
                  ),
                  Center(
                    child: Container(
                      margin: EdgeInsets.only(
                        top: height * 0.04,
                      ),
                      child: Column(
                        children: [
                          Text(
                            'register_page_four_digit_code'.tr(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: AppColors.black,
                                fontSize: height * 0.018,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Montserrat',
                                height: 1.3),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'register_page_registered_email'.tr(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: AppColors.black,
                                    fontSize: height * 0.018,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Montserrat',
                                    height: 1.3),
                              ),
                              Text(
                                Email ?? '',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: 'Montserrat-Bold',
                                    color: AppColors.black,
                                    fontSize: height * 0.018,
                                    fontWeight: FontWeight.bold,
                                    height: 1.3),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: height * 0.05, left: width * 0.09, right: width * 0.09),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children:  [
                        OtpController(controller: pin1, last:last , first: first,),
                        OtpController(controller:pin2, last: last, first: first,),
                        OtpController(controller: pin3, last: last, first: first,),
                        OtpController(controller : pin4, last: last, first: first,),
                      ],
                    ),
                  ),
                  SizedBox(height: height * 0.03),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      btnChange
                          ?SizedBox(
                        width: width * 0.07,
                        child: LoadingIndicator(
                          indicatorType: Indicator.ballBeat,
                          colors: [
                            AppColors.black,
                            AppColors.black,
                            AppColors.black
                          ],
                          strokeWidth: 1,
                          pathBackgroundColor: Colors.black,
                        ),
                      )
                          :Text(
                        clicked
                            ? '00:$_start1'
                            : '00:$_start',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: AppColors.orange,
                            fontSize: height * 0.015,
                            fontWeight: FontWeight.bold,
                            height: 1.3),
                      ),
                      Text(
                        '\t\tseconds'.tr(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'Montserrat-Bold',
                            color: AppColors.black,
                            fontSize: height * 0.015,
                            fontWeight: FontWeight.bold,
                            height: 1.3),
                      ),
                    ],
                  ),
                  SizedBox(height: height * 0.08),
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
                          onPressed: ()async{
                            if(pin1.text.isEmpty == true||pin2.text.isEmpty == true||pin3.text.isEmpty == true||pin4.text.isEmpty == true){
                              Fluttertoast.showToast(msg: "please enter 4 digit code");
                            }else{
                              _verifyOTP();
                            }
                            },
                          child:loading? SizedBox(
                            width: width * 0.1,
                            child: LoadingIndicator(
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
                              fontWeight: FontWeight.w500))
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.03),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                       Text("not_receive_otp".tr(),
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w300, fontSize: height * 0.017,)),
                      SizedBox(width: width * 0.015),
                      InkWell(
                          onTap: () {
                            setState(() {
                              clicked =! clicked;
                            });
                            _resendOTP();
                          },
                          child:  Text(
                            'resend'.tr(),
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                fontSize: height * 0.017,
                                color: Colors.orange),
                          )),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
