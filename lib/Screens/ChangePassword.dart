import 'dart:developer';

import 'package:coin_project/ApiConnection/Api.dart';
import 'package:coin_project/ApiConnection/network.dart';
import 'package:coin_project/Models/changePasswordModel.dart';
import 'package:coin_project/Screens/login_page.dart';
import 'package:connectivity/connectivity.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../AppColors/appColors.dart';
import '../NotificationHelper.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  TextEditingController password = TextEditingController();
  TextEditingController rePassword = TextEditingController();

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool pwdHide = true, pwdHide1 = true, loading = false, btnChange = false, _autoValidate = false;

  Future<ChangePasswordModel>? passwordObj;

  _changePassword() async {
    setState(() {
      btnChange = true;
    });
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var userId = preferences.getString("User_ID");
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
    String changePasswordUrl = Api.base_url + Api.changePassword;
    log('change PasswordUrl Url ::::::::$changePasswordUrl');
    Map res = {
      "password": password.text,
      "confirm_password": rePassword.text,
      "api_username": Api.api_username,
      "api_password": Api.api_password,
      "id": userId.toString(),
    };
    Map<String, String> data = {"Accept-Language": language};
    log("my lan $data");
    passwordObj = ApiConnection().changePassword(changePasswordUrl, res, data);
    await passwordObj!.then((value) {
      setState(() {
        btnChange = false;
      });
      if (value.status == 1) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
        Fluttertoast.showToast(msg: value.msg.toString());
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
    // TODO: implement initState
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
              key: _scaffoldKey,
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
                              margin: EdgeInsets.only(left: width * 0.05, bottom: height * 0.0),
                              child: const Icon(Icons.arrow_back_ios_outlined, color: AppColors.black, size: 18),
                            ),
                          ),
                          SizedBox(width: width * 0.13),
                          Container(
                              child: Text(
                            'Enter_new_password'.tr(),
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
                      Container(
                        margin: EdgeInsets.only(top: height * 0.04, left: width * 0.09),
                        child: Text(
                          'Enter_reset_password'.tr(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.black,
                            fontSize: height * 0.016,
                            fontWeight: FontWeight.w400,
                            height: 1.3,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          left: width * 0.08,
                          right: width * 0.08,
                          top: height * 0.05,
                        ),
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'required_password'.tr();
                            } else {
                              return null;
                            }
                          },
                          controller: password,
                          obscureText: pwdHide,
                          style: const TextStyle(color: AppColors.black),
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              hintText: 'New_Password_Enter_password'.tr(),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: AppColors.black),
                                  borderRadius: BorderRadius.circular(10)),
                              suffixIcon: InkWell(
                                  onTap: () {
                                    pwdHide = !pwdHide;
                                    setState(() {});
                                  },
                                  child: pwdHide
                                      ? const Icon(
                                          Icons.visibility_off,
                                          color: AppColors.black,
                                        )
                                      : const Icon(
                                          Icons.visibility,
                                          color: AppColors.lightGray,
                                        ))),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: width * 0.08, right: width * 0.08, top: height * 0.03),
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'required_re_enter_password'.tr();
                            } else {
                              return null;
                            }
                          },
                          controller: rePassword,
                          obscureText: pwdHide1,
                          style: const TextStyle(color: AppColors.black),
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintText: 'New_Password_Re_Enter_password'.tr(),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: AppColors.black),
                                borderRadius: BorderRadius.circular(10)),
                            suffixIcon: InkWell(
                                onTap: () {
                                  pwdHide1 = !pwdHide1;
                                  setState(() {});
                                },
                                child: pwdHide1
                                    ? const Icon(
                                        Icons.visibility_off,
                                        color: AppColors.black,
                                      )
                                    : const Icon(
                                        Icons.visibility,
                                        color: AppColors.lightGray,
                                      )),
                          ),
                        ),
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
                                  elevation: 0.0),
                              onPressed: () async {
                                FocusScope.of(context).unfocus();
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                  var result = await (Connectivity().checkConnectivity());
                                  if (result == ConnectivityResult.mobile || result == ConnectivityResult.wifi) {
                                    _changePassword();
                                  }
                                } else {
                                  setState(() {
                                    _autoValidate = true;
                                  });
                                }
                              },
                              child: btnChange
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
                                      "Continue".tr(),
                                      style: TextStyle(
                                          color: AppColors.white,
                                          fontSize: height * 0.022,
                                          fontWeight: FontWeight.w500),
                                    )),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
