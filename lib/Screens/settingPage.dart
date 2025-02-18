import 'dart:async';
import 'dart:developer';

import 'package:coin_project/AppColors/appColors.dart';
import 'package:coin_project/Models/deleteAccountModel.dart';
import 'package:coin_project/Models/logoutModel.dart';
import 'package:coin_project/Screens/HomePage.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../ApiConnection/Api.dart';
import '../ApiConnection/network.dart';
import '../IntegrationWidget/CounterMethods.dart';
import 'deleteAccountOTP.dart';
import 'login_page.dart';
import 'multipleLanguage.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  Timer? timer;
  bool loading = false;
  bool btnChange = false;
  Future<LogoutModel>? log_obj;

  logout() async {
    setState(() {
      btnChange = true;
    });
    final GoogleSignIn _googleSignIn = new GoogleSignIn();
    final _auth = FirebaseAuth.instance;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var id = preferences.getString('UserID');
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
    log('.....Id is....${id}..');
    String logoutUrl = Api.base_url + Api.logout;
    Map logoutBody = {
      "id": id.toString(),
      "api_username": Api.api_username,
      "api_password": Api.api_password,
    };
    Map<String, String> data = {"Accept-Language": language};
    log('request....${logoutBody}..');
    log('request....${data}..');

    log_obj = ApiConnection().logout(logoutUrl, logoutBody, data);
    await log_obj!.then((value) {
      setState(() {
        btnChange = false;
      });
      if (value.status == 1) {
        StopTimer();
        isTimerSet = false;
        totalTime = "";
        resetTimer();
        preferences.remove("btn1");
        _googleSignIn.signOut();
        _auth.signOut();
        preferences.setBool("seen", false);
        // preferences.clear();
        Navigator.pop(context, true);
        Navigator.of(context)
            .pushAndRemoveUntil(MaterialPageRoute(builder: (context) => LoginPage()), (Route<dynamic> route) => false);
      } else {
        Fluttertoast.showToast(msg: value.msg.toString());
      }
    });
  }

  Future<deleteAccountModel>? account_obj;

  _deleteAccount() async {
    setState(() {
      btnChange = true;
    });
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var userId = preferences.getString("UserID");
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
    Map res = {
      "api_username": Api.api_username,
      "api_password": Api.api_password,
      "user_id": userId,
    };
    Map<String, String> data = {"Accept-Language": language};
    String deleteAccountUrl = Api.base_url + Api.deleteAccount;
    account_obj = ApiConnection().deleteAccount(deleteAccountUrl, res, data);
    log("my lan $data");
    await account_obj?.then((value) {
      setState(() {
        log("btn value false");
        btnChange = false;
      });
      if (value.status == 1) {
        Fluttertoast.showToast(msg: value.msg.toString());
        Navigator.push(context, MaterialPageRoute(builder: (context) => DeleteAccountOTPScreen()));
      } else {
        Fluttertoast.showToast(msg: value.msg.toString());
      }
    });
  }

  ShowLoadingIndicator() {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Stack(
            children: [
              Container(
                child: btnChange
                    ? Center(
                        child: Stack(
                        children: [
                          Container(
                            //margin: EdgeInsets.only(top: height * 0.25),
                            height: height, width: width,
                            decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(12)),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: height * 0.4, left: width * 0.35),
                            height: 100,
                            width: 100,
                            decoration:
                                BoxDecoration(color: Color(0xFFFDF2D6), borderRadius: BorderRadius.circular(12)),
                          ),
                          Container(
                            height: 40,
                            width: 40,
                            margin: EdgeInsets.only(left: width * 0.43, top: height * 0.435),
                            child: LoadingIndicator(
                              indicatorType: Indicator.ballBeat,
                              colors: [AppColors.orange, AppColors.black, AppColors.gray],
                              strokeWidth: 1,
                              pathBackgroundColor: Colors.black,
                            ),
                          ),
                        ],
                      ))
                    : null,
              ),
            ],
          );
        });
  }

  showAlertDialog(BuildContext context) {
    Widget yesButton = TextButton(
        child: Text("yes".tr(),
            style: TextStyle(
              fontFamily: 'Montserrat-Bold',
            )),
        onPressed: () async {
          ShowLoadingIndicator();
          logout();
        });
    Widget NoButton = TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text(
          "no".tr(),
          style: const TextStyle(
            fontFamily: 'Montserrat-Bold',
          ),
        ));
    AlertDialog alert = AlertDialog(
      title: Text("setting_screen_delete_alert".tr(),
          style: TextStyle(
            fontFamily: 'Montserrat',
          )),
      content: Stack(
        children: [
          Text("setting_screen_logout_acc_dialog_box_text".tr(),
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.height * 0.017,
                fontFamily: 'Montserrat',
              )),
        ],
      ),
      actions: [
        NoButton,
        yesButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  DeleteshowAlertDialog(BuildContext context) {
    Widget yesButton = TextButton(
      child: Text("yes".tr(),
          style: TextStyle(
            fontFamily: 'Montserrat-Bold',
          )),
      onPressed: () async {
        ShowLoadingIndicator();
        _deleteAccount();
      },
    );
    Widget NoButton = TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text(
          "no".tr(),
          style: const TextStyle(
            fontFamily: 'Montserrat-Bold',
          ),
        ));
    AlertDialog alert = AlertDialog(
      title: Text("setting_screen_delete_alert".tr(),
          style: TextStyle(
            fontFamily: 'Montserrat',
          )),
      content: Stack(
        children: [
          Text("setting_screen_delete_acc_dialog_box_text".tr(),
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.height * 0.017,
                fontFamily: 'Montserrat',
              )),
        ],
      ),
      actions: [
        NoButton,
        yesButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.white,
      body: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: height * 0.06, left: width * 0.06),
                    child: Row(
                      children: [
                        InkWell(
                            onTap: () async {
                              var data = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HomePage(),
                                  ));
                              setState(() {});
                            },
                            child: Icon(Icons.arrow_back)),
                        SizedBox(
                          width: width * 0.03,
                        ),
                        Text(
                          'setting_text'.tr(),
                          style: TextStyle(
                              color: AppColors.black,
                              fontSize: height * 0.022,
                              fontFamily: 'Montserrat-Bold',
                              fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      var url = Uri.parse("mailto:support@dotchain.network");
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: const Color(0xFFD3D3D3).withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                      height: height * 0.080,
                      width: width * 0.9,
                      margin: EdgeInsets.only(top: height * 0.04, left: width * 0.04, right: width * 0.04),
                      child: ListTile(
                        leading: Icon(
                          Icons.person,
                          color: Color(0xFF030D45),
                        ),
                        title: Text(
                          'setting_screen_support'.tr(),
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Montserrat',
                            fontSize: height * 0.018,
                          ),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          color: AppColors.black,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: ((context) => PrivacyPolicy())));
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Color(0xFFD3D3D3).withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                      height: height * 0.080,
                      width: width * 0.9,
                      margin: EdgeInsets.only(top: height * 0.02, left: width * 0.04, right: width * 0.04),
                      child: ListTile(
                        leading: Icon(
                          Icons.lock,
                          color: Color(0xFF030D45),
                        ),
                        title: Text(
                          'privacy_policy'.tr(),
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Montserrat',
                            fontSize: height * 0.018,
                          ),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      var data =
                          await Navigator.push(context, MaterialPageRoute(builder: ((context) => MultiPleLanguage())));
                      setState(() {});
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Color(0xFFD3D3D3).withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                      height: height * 0.080,
                      width: width * 0.9,
                      margin: EdgeInsets.only(top: height * 0.02, left: width * 0.04, right: width * 0.04),
                      child: ListTile(
                        leading: Icon(
                          Icons.language,
                          color: Color(0xFF030D45),
                        ),
                        title: Text(
                          'language'.tr(),
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Montserrat',
                            fontSize: height * 0.018,
                          ),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: ((context) => Terms_Conditions())));
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: const Color(0xFFD3D3D3).withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                      height: height * 0.080,
                      width: width * 0.9,
                      margin: EdgeInsets.only(top: height * 0.02, left: width * 0.04, right: width * 0.04),
                      child: ListTile(
                        leading: Icon(
                          Icons.insert_drive_file_rounded,
                          color: Color(0xFF030D45),
                        ),
                        title: Text(
                          'terms_conditions'.tr(),
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Montserrat',
                            fontSize: height * 0.018,
                          ),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      DeleteshowAlertDialog(context);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: const Color(0xFFD3D3D3).withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                      height: height * 0.080,
                      width: width * 0.9,
                      margin: EdgeInsets.only(top: height * 0.02, left: width * 0.04, right: width * 0.04),
                      child: ListTile(
                        leading: const Icon(
                          Icons.delete,
                          color: Color(0xFF030D45),
                        ),
                        title: Text(
                          'delete_acc'.tr(),
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Montserrat',
                            fontSize: height * 0.018,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Color(0xFFD3D3D3).withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                    height: height * 0.080,
                    width: width * 0.9,
                    margin: EdgeInsets.only(top: height * 0.02, left: width * 0.04, right: width * 0.04),
                    child: ListTile(
                      onTap: () async {
                        showAlertDialog(context);
                      },
                      leading: SvgPicture.asset(
                        'assets/svg_images/logout.svg',
                        color: const Color(0xFF030D45),
                      ),
                      title: Text(
                        'setting_screen_logout'.tr(),
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Montserrat',
                          fontSize: height * 0.018,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.05),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'setting_screen_find_us_on'.tr(),
                        style: TextStyle(
                          color: AppColors.gray,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat-Bold',
                          fontSize: height * 0.018,
                        ),
                      )
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: height * 0.030),
                    height: height * 0.14,
                    width: width * 0.9,
                    decoration: BoxDecoration(
                        color: Colors.pinkAccent.withOpacity(0.04), borderRadius: BorderRadius.circular(15)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: () async {
                            var url = Uri.parse("https://m.facebook.com/108434705336300/");
                            if (await canLaunchUrl(url)) {
                              await launchUrl(url);
                            } else {
                              throw 'Could not launch $url';
                            }
                          },
                          //  Navigator.push(context, MaterialPageRoute(builder: ((context) => facebook())));

                          child: Image.asset(
                            'assets/images/Facebook.png',
                            width: width * 0.12,
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            var url = Uri.parse("https://instagram.com/Dot.blockchain");
                            if (await canLaunchUrl(url)) {
                              await launchUrl(url);
                            } else {
                              throw 'Could not launch $url';
                            }
                          },
                          child: Image.asset('assets/images/Instagram.png', width: width * 0.12),
                        ),
                        InkWell(
                          onTap: () async {
                            var url = Uri.parse("https://twitter.com/Dot_Blockchain");
                            if (await canLaunchUrl(url)) {
                              await launchUrl(url);
                            } else {
                              throw 'Could not launch $url';
                            }
                          },
                          child: Image.asset('assets/images/Twitter.png', width: width * 0.12),
                        ),
                        InkWell(
                          onTap: () async {
                            canLaunchUrl(Uri.parse("https://telegram.me/Dot_Blockchain")).then((bool result) {
                              launchUrl(
                                Uri.parse("https://telegram.me/Dot_Blockchain"),
                                mode: LaunchMode.externalApplication,
                              );
                            });
                          },
                          child: Image.asset('assets/images/Telegram (1).png', width: width * 0.12),
                        ),
                        InkWell(
                          onTap: () async {
                            var url = Uri.parse("https://github.com/Dot-Blockchain");
                            if (await canLaunchUrl(url)) {
                              await launchUrl(url);
                            } else {
                              throw 'Could not launch $url';
                            }
                          },
                          child: Image.asset('assets/images/Github.png', width: width * 0.12),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: height * 0.07,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget Terms_Conditions() {
    final WebViewController controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
        ),
      )
      ..loadRequest(Uri.parse('https://dotchain.network/termsandconditions.html'));

    return WebViewWidget(controller: controller);
  }

  Widget PrivacyPolicy() {
    final WebViewController controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
        ),
      )
      ..loadRequest(Uri.parse('https://dotchain.network/privacypolicy.html'));

    return WebViewWidget(controller: controller);
  }
}
