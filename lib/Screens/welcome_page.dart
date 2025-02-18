import 'package:coin_project/Screens/register_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../AppColors/appColors.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    //  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomRight,
                colors: [AppColors.mainColor, AppColors.mainColor1])),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: height * 0.055),
                Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: height * 0.055, left: width * 0.08),
                      child: Image.asset('assets/images/welcome.png'),
                    ),
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: height * 0.013, left: width * 0.04),
                      child: Image.asset('assets/images/welcome_logo.png', height: height * 0.16, width: width * 0.4),
                    ),
                    Center(
                      child: Container(
                          margin: EdgeInsets.only(top: height * 0.16, right: width * 0.07),
                          child: Text(
                            'welcome_page_fastest_launching_blockchain'.tr(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: AppColors.black,
                                fontFamily: 'Montserrat-Bold',
                                fontSize: height * 0.026,
                                letterSpacing: 0.2,
                                fontStyle: FontStyle.normal),
                          )),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: height * 0.05, left: width * 0.8),
                      child: Image.asset('assets/images/welcome1.png', width: 134, height: 134),
                    ),
                  ],
                ),
                SizedBox(
                  height: height * 0.05,
                ),
                Center(
                  child: Container(
                    margin: EdgeInsets.only(
                        //  top: height * 0.043,
                        left: width * 0.09,
                        right: width * 0.09),
                    child: Text(
                      "${"welcome_page_50x_to_90x_launching".tr()}",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.w400, fontSize: height * 0.015, fontFamily: 'Montserrat'),
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.1,
                ),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: height * 0.042,
                          width: width * 0.095,
                          decoration: BoxDecoration(color: AppColors.black, borderRadius: BorderRadius.circular(100)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('welcome_page_dot'.tr(),
                                  style: TextStyle(
                                      color: AppColors.mainColor,
                                      fontSize: height * 0.02,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Montserrat'),
                                  textAlign: TextAlign.center),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: width * 0.004,
                        ),
                        Text(
                          'welcome_page_is_more_crypto'.tr(),
                          style: TextStyle(
                              color: AppColors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: height * 0.02,
                              fontFamily: 'Montserrat'),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(width: width * 0.0477),
                        Text(
                          "welcome_page_it_s".tr(),
                          style: TextStyle(
                              color: AppColors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: height * 0.02,
                              fontFamily: 'Montserrat'),
                        ),
                        SizedBox(
                          width: width * 0.01,
                        ),
                        Container(
                          height: height * 0.03,
                          width: width * 0.27,
                          decoration: BoxDecoration(color: AppColors.black, borderRadius: BorderRadius.circular(100)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('welcome_page_community'.tr(),
                                  style: TextStyle(
                                      color: AppColors.mainColor,
                                      fontSize: width / 25,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Montserrat'),
                                  textAlign: TextAlign.center),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: height * 0.017),
                  child: Image.asset('assets/images/welcome2.png'),
                ),
                Center(
                  child: Container(
                    margin: EdgeInsets.only(top: height * 0.139),
                    width: width * 0.85,
                    height: height * 0.07,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        primary: AppColors.black,
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                            context, MaterialPageRoute(builder: (context) => const RegisterPage()));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'welcome_page_go_dot'.tr(),
                            style: TextStyle(
                                color: AppColors.white,
                                fontSize: width / 22,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Montserrat'),
                          ),
                          SizedBox(width: width * 0.03),
                          const Icon(
                            Icons.arrow_forward,
                            color: AppColors.white,
                            size: 20,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'welcome_page_by_continuing'.tr(),
                      style: TextStyle(
                        fontSize: width / 36,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: height * 0.001,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: ((context) => Terms_Conditions())));
                      },
                      child: Text(
                        "${'terms_conditions'.tr()}\t",
                        style: TextStyle(
                            fontFamily: 'Montserrat-Bold',
                            fontSize: width / 36,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline),
                      ),
                    ),
                    Text(
                      'well_comePage_and'.tr(),
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: width / 36,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: ((context) => PrivacyPolicy())));
                      },
                      child: Text(
                        'privacy_policy'.tr(),
                        style: TextStyle(
                            fontFamily: 'Montserrat-Bold',
                            fontSize: width / 36,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline),
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
