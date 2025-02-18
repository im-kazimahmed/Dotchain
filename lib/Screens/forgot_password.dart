import 'dart:developer';

import 'package:coin_project/ApiConnection/network.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../ApiConnection/Api.dart';
import '../AppColors/appColors.dart';
import '../Models/ForgotPasswordModel.dart';
import '../NotificationHelper.dart';
import '../widgets/txtfield.dart';
import 'forgotPasswordOTP.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({
    Key? key,
  }) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController email = TextEditingController();
  bool btnChange = false, loading = false;
  String? user_Id, Email;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late Future<ForgotPasswordModel> forgot_obj;
  _forgotPassword() async {
    setState(() {
      loading = true;
    });
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var viLang = preferences.getString("vi");
    var engLang = preferences.getString("en");
    var zhLang = preferences.getString("zh");
    var filLang = preferences.getString("fil");
    var idLang = preferences.getString("id");
    var koLang = preferences.getString("ko");

    var language;

    if (zhLang == "zh") {
      language = zhLang;
      preferences.remove('en');
      preferences.remove('id');
      preferences.remove('fil');
      preferences.remove('ko');
      preferences.remove('vi');
      log("if part lnag${language}");
      setState(() {});
    } else if (filLang == "fil") {
      language = filLang;
      preferences.remove('id');
      preferences.remove('en');
      preferences.remove('ko');
      preferences.remove('vi');
      preferences.remove('zh');
      log("if part lnag${language}");
      setState(() {});
    } else if (idLang == "id") {
      language = idLang;
      preferences.remove('en');
      preferences.remove('ko');
      preferences.remove('vi');
      preferences.remove('zh');
      preferences.remove('fil');
      log("if part lnag${language}");
      setState(() {});
    } else if (koLang == "ko") {
      language = koLang;
      preferences.remove('en');
      preferences.remove('vi');
      preferences.remove('zh');
      preferences.remove('fil');
      preferences.remove('id');
      log("if part lnag${language}");
      setState(() {});
    } else if (viLang == "vi") {
      language = viLang;
      preferences.remove('en');
      preferences.remove('zh');
      preferences.remove('fil');
      preferences.remove('id');
      preferences.remove('ko');
      log("if part lnag${language}");
      setState(() {});
    } else if (engLang == "en") {
      language = engLang;
      preferences.remove('zh');
      preferences.remove('fil');
      preferences.remove('id');
      preferences.remove('ko');
      preferences.remove('vi');
      log("else part lnag${language}");
      setState(() {});
    }
    String forgotPasswordUrl = Api.base_url + Api.forgotPassword;
    log('forgot password url :::::$forgotPasswordUrl');

    Map forgotPasswordBody = {"api_username": Api.api_username, "api_password": Api.api_password, "email": email.text};
    Map<String, String> data = {"Accept-Language": language};
    log("my lan $data");
    forgot_obj = ApiConnection().forgotPassword(forgotPasswordUrl, forgotPasswordBody, data);
    await forgot_obj.then((value) {
      setState(() {
        loading = false;
      });
      if (value.status == 1) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const ForgotVerifyOTPScreen()));
        user_Id = value.result?.id;
        Email = value.result?.email;
        preferences.setString('User_ID', user_Id!);
        preferences.setString('Email_ID', Email!);
      } else {
        Fluttertoast.showToast(msg: value.msg.toString());
      }
    });
  }

  @override
  void initState() {
    // LocalService.initialize(context);
    // GetData().onMessageOpenedAppMethod(context);
    // GetData().onMessage(context);
    //   // TODO: implement initState
    super.initState();
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
          onTap: () {
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
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: width * 0.05),
                            child: const Icon(Icons.arrow_back_ios_outlined, color: AppColors.black, size: 18),
                          ),
                        ),
                        SizedBox(width: width * 0.15),
                        Text(
                          'forgot_password'.tr(),
                          style: TextStyle(
                            fontFamily: 'Montserrat-Bold',
                            color: AppColors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: height * 0.025,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: height * 0.04),
                      child: Text(
                        'forgot_password_need_email_acc'.tr(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            color: AppColors.black,
                            fontSize: height * 0.018,
                            fontWeight: FontWeight.w500,
                            height: 1.3),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: width * 0.08, right: width * 0.08, top: height * 0.02),
                      child: txtField_widget(
                          obscureText: false,
                          validator: (email) =>
                              email != null && !EmailValidator.validate(email) ? 'enter_valid_email'.tr() : null,
                          textEditingController: email,
                          icon: const Icon(
                            Icons.email_outlined,
                            color: Colors.transparent,
                          ),
                          text: 'email'.tr(),
                          inputType: TextInputType.emailAddress),
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
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _forgotPassword();
                              }
                            },
                            child: loading
                                ? SizedBox(
                                    width: width * 0.1,
                                    child: LoadingIndicator(
                                      indicatorType: Indicator.ballBeat,
                                      colors: [AppColors.mainColor, AppColors.mainColor, AppColors.mainColor],
                                      strokeWidth: 1,
                                      pathBackgroundColor: Colors.black,
                                    ),
                                  )
                                : Text(
                                    "continue".tr(),
                                    style: TextStyle(
                                        color: AppColors.white, fontSize: height * 0.022, fontWeight: FontWeight.w500),
                                  )),
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
