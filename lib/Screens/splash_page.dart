import 'dart:developer';

import 'package:coin_project/ApiConnection/Api.dart';
import 'package:coin_project/ApiConnection/network.dart';
import 'package:coin_project/AppColors/appColors.dart';
import 'package:coin_project/Screens/HomePage.dart';
import 'package:coin_project/Screens/welcome_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Models/AppVersionModel.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String? version, appName, appVersion, buildNumber;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    getAppversion();
    _appVersion().then((value) => {
      checkVersion()
    });
    // Future.delayed(const Duration(seconds: 5), () {
    //   getDailyReward();
    // });
  }

  _chekuser() async {
    SharedPreferences pre = await SharedPreferences.getInstance();
    bool status = pre.getBool("seen") ?? false;
    if (status) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const WelcomePage()));
    }
  }

  void getAppversion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    appName = packageInfo.appName;
    version = packageInfo.version;
    buildNumber = packageInfo.buildNumber;
  }

  late Future<getAppVersionModel> version_obj;
  Future<bool> _appVersion() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      loading = true;
    });
    var zhLang = preferences.getString("zh");
    var filLang = preferences.getString("fil");
    var idLang = preferences.getString("id");
    var koLang = preferences.getString("ko");
    var viLang = preferences.getString("vi");
    var engLang = preferences.getString("en");
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
    String appVersionUrl = Api.base_url + Api.getAppVersion;
    Map res = {
      'api_username': Api.api_username,
      'api_password': Api.api_password,
    };
    Map<String, String> data = {"Accept-Language": language};
    log(":::::::::::::::::::::::::::::");
    log("splash screen time data $data");
    log(":::::::::::::::::::::::::::::");
    version_obj = ApiConnection().getAppVersion(appVersionUrl, res, data);
    await version_obj.then((value) {
      if (value.status == 1) {
        log("if part of data ::::::::::::::::::::::::::::::::::::::::");
        appVersion = value.result?.androidAppVersion;
        log("${appVersion}");
        return true;
      } else {
        Fluttertoast.showToast(msg: value.msg.toString());
        return false;
      }
    });
    return false;
  }

  checkVersion() {
    var str1 = version;
    var str2 = appVersion;
    var result = str2?.compareTo(str1!);
    log("version:${version} appVersion:${appVersion} buildNumber${buildNumber}");

    if (buildNumber != appVersion) {
      return UpdateAlertDialog(context);
    } else {
      return _chekuser();
    }

    // if ((result ?? 0) < 1) {
    //   log('if');
    //   return _chekuser();
    // } else {
    //   log('else');
    //   return UpdateAlertDialog(context);
    // }

  }

  UpdateAlertDialog(BuildContext context) {
    Widget yesButton = TextButton(
      child: Text("splash_screen_update_btn_text".tr(),
          style: TextStyle(
            fontFamily: 'Montserrat-Bold',
          )),
      onPressed: () async {
        var url = Uri.parse("https://dotchain.network/update.html");
        if (await canLaunchUrl(url)) {
          await launchUrl(url);
        } else {
          throw 'Could not launch $url';
        }
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text("splash_screen_update_req_text".tr(),
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.height * 0.016,
            fontFamily: 'Montserrat-Bold',
          )),
      content: Text("splash_screen_latest_version_text".tr(),
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.height * 0.016,
            fontFamily: 'Montserrat',
          )),
      actions: [
        yesButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  // UpdatesRewardAlertDialog(BuildContext context) {
  //   Widget yesButton = TextButton(
  //     child: Text("splash_screen_reward_btn".tr(),
  //         style: TextStyle(
  //           fontFamily: 'Montserrat-Bold',
  //         )),
  //     onPressed: () async {
  //       var url = Uri.parse("https://t.me/Dot_Blockchain");
  //       if (await canLaunchUrl(url)) {
  //         await launchUrl(url);
  //       } else {
  //         throw 'Could not launch $url';
  //       }
  //     },
  //   );
  //   AlertDialog alert = AlertDialog(
  //     title: Text("splash_screen_reward_title".tr(),
  //         style: TextStyle(
  //           fontSize: MediaQuery.of(context).size.height * 0.016,
  //           fontFamily: 'Montserrat-Bold',
  //         )),
  //     content: Text("splash_screen_reward_content".tr(),
  //         style: TextStyle(
  //           fontSize: MediaQuery.of(context).size.height * 0.016,
  //           fontFamily: 'Montserrat',
  //         )),
  //     actions: [
  //       yesButton,
  //     ],
  //   );
  //   // show the dialog
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (BuildContext context) {
  //       return alert;
  //     },
  //   );
  // }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.mainColor, AppColors.mainColor1])),
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                Center(
                  child: Image.asset(
                    'assets/images/SplashLogo.png',
                    height: MediaQuery.of(context).size.height * 0.22,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.37),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                    Text(
                      'splash_screen_dotting_text'.tr(),
                      style: TextStyle(fontSize: 9, fontFamily: 'Montserrat', fontWeight: FontWeight.w300),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.005),
                      child: const SizedBox(
                        width: 10,
                        height: 2,
                        child: LoadingIndicator(
                          indicatorType: Indicator.ballPulse,
                          colors: [AppColors.black, AppColors.white, AppColors.lightGray],
                          strokeWidth: 1,
                          pathBackgroundColor: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
