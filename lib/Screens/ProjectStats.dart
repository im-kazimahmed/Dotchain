import 'dart:developer';
import 'dart:io';

import 'package:applovin_max/applovin_max.dart';
import 'package:clever_ads_solutions/public/AdPosition.dart';
import 'package:clever_ads_solutions/public/AdSize.dart';
import 'package:clever_ads_solutions/public/AdTypes.dart';
import 'package:clever_ads_solutions/public/BannerView.dart';
import 'package:clever_ads_solutions/public/CASBannerView.dart';
import 'package:clever_ads_solutions/public/MediationManager.dart';
import 'package:coin_project/Screens/settingPage.dart';
import 'package:coin_project/services/applovin_ad_service.dart';
import 'package:coin_project/services/cas_ad_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../AppColors/appColors.dart';

class ProjectStats extends StatefulWidget {
  const ProjectStats({Key? key}) : super(key: key);
  @override
  State<ProjectStats> createState() => _ProjectStatsState();
}

class _ProjectStatsState extends State<ProjectStats> {
  // GlobalKey<BannerViewState> _bannerViewKey = GlobalKey();

  // CleverAdsSolutionsService casService = CleverAdsSolutionsService();

  // CASBannerView? view;

  // bool _isReady = false;

  @override
  void initState() {
    super.initState();
    // initialiseCAS();
    _getTotalUsers();
  }

  // initialiseCAS() async {
  //   casService.initialize();
  //   await createAdaptiveBanner();
  // }

  // Future<void> createAdaptiveBanner() async {
  //   view = casService.manager?.getAdView(AdSize.Banner);
  //   await view?.showBanner();
  //   await view?.setBannerPositionWithOffset(25, 100);
  //   setState(() {
  //     _isReady = true;
  //   });
  // }

  String? totalUser, activeUser;
  double? totalUsersPercentage, activeUserPercentage;

  _getTotalUsers() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    totalUser = preferences.getString('TotalUser');
    activeUser = preferences.getString('ActiveUser');
    totalUsersPercentage = preferences.getDouble('totalUsersPercentage');
    activeUserPercentage = preferences.getDouble('activeUserPercentage');
    setState(() {});
  }

  double getPercentage(String userCount) {
    bool isThousands = false;
    bool isMillions = false;
    if (userCount.contains('K')) {
      isThousands = true;
    }
    if (userCount.contains('M')) {
      isMillions = true;
    }
    double parsedCount = (double.parse((userCount).replaceAll('K', '').replaceAll('M', '')));
    if (isThousands) {
      parsedCount *= 1000;
    }
    if (isMillions) {
      parsedCount *= 1000000;
    }
    log('###' + userCount.toString());
    log('###' + parsedCount.toString());
    final percentage = (parsedCount / 500000);
    return percentage;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Center(
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: height * 0.06, left: width * 0.03),
                    child: Text(
                      'project_stats_screen_project_stats'.tr(),
                      style: TextStyle(
                          color: AppColors.black,
                          fontSize: height * 0.022,
                          fontFamily: 'Montserrat-Bold',
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: height * 0.03),
                    width: width * 0.94,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10), color: const Color(0xFFFFB001).withOpacity(0.09)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'mainnet_will_be_live'.tr(),
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF545454),
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat-Bold',
                          ),
                          textAlign: TextAlign.center,
                        ),
                        // SizedBox(height: 15),
                        // Text(
                        //   'january_date'.tr(),
                        //   style: TextStyle(
                        //     fontSize: 16,
                        //     color: Colors.black,
                        //     fontWeight: FontWeight.bold,
                        //     fontFamily: 'Montserrat-Bold',
                        //   ),
                        //   textAlign: TextAlign.center,
                        // ),
                      ],
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.all(20),
                      child: MaxAdView(
                          adUnitId: ApplovinAdService.banner_ad_unit_ID,
                          adFormat: AdFormat.banner,
                          listener: AdViewAdListener(
                              onAdLoadedCallback: (ad) {},
                              onAdLoadFailedCallback: (adUnitId, error) {},
                              onAdClickedCallback: (ad) {},
                              onAdExpandedCallback: (ad) {},
                              onAdCollapsedCallback: (ad) {}))),
                  // Container(
                  //   margin: EdgeInsets.only(top: height * 0.03),
                  //   width: width * 0.9,
                  //   padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  //   decoration: BoxDecoration(
                  //     color: AppColors.black,
                  //     borderRadius: BorderRadius.circular(12),
                  //   ),
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       Row(
                  //         children: [
                  //           Text(
                  //             "${'first_milestone_completed'.tr()}  ",
                  //             style: TextStyle(
                  //                 fontFamily: 'Montserrat-Bold',
                  //                 color: AppColors.white,
                  //                 fontSize: height * 0.018,
                  //                 fontWeight: FontWeight.bold),
                  //           ),
                  //           Icon(
                  //             Icons.check,
                  //             color: Colors.green,
                  //           )
                  //         ],
                  //       ),
                  //       const SizedBox(
                  //         height: 15,
                  //       ),
                  //       Text("${'dotchain_achieved'.tr()}",
                  //           style: TextStyle(
                  //               fontFamily: 'Montserrat',
                  //               color: AppColors.white,
                  //               fontSize: height * 0.012,
                  //               fontWeight: FontWeight.w400)),
                  //     ],
                  //   ),
                  // ),
                  // Container(
                  //   margin: EdgeInsets.only(top: height * 0.015),
                  //   width: width * 0.9,
                  //   height: height * 0.21,
                  //   decoration: BoxDecoration(
                  //     color: AppColors.black,
                  //     borderRadius: BorderRadius.circular(12),
                  //   ),
                  //   child: Column(
                  //     children: [
                  //       Container(
                  //         margin: EdgeInsets.only(left: width * 0.04, top: height * 0.02, right: width * 0.04),
                  //         child: Column(
                  //           crossAxisAlignment: CrossAxisAlignment.start,
                  //           children: [
                  //             Row(
                  //               children: [
                  //                 SizedBox(width: width * 0.012),
                  //                 Text(
                  //                   "${'project_stats_screen_active_remote'.tr()}",
                  //                   style: TextStyle(
                  //                       fontFamily: 'Montserrat-Bold',
                  //                       color: AppColors.white,
                  //                       fontSize: height * 0.018,
                  //                       fontWeight: FontWeight.bold),
                  //                 ),
                  //               ],
                  //             ),
                  //             SizedBox(height: height * 0.01),
                  //             Row(
                  //               children: [
                  //                 SizedBox(width: width * 0.012),
                  //                 Text('project_stats_screen_daily_Up'.tr(),
                  //                     style: TextStyle(
                  //                         fontFamily: 'Montserrat',
                  //                         color: AppColors.white,
                  //                         fontSize: height * 0.012,
                  //                         fontWeight: FontWeight.w400)),
                  //               ],
                  //             ),
                  //             SizedBox(height: height * 0.03),
                  //             Row(
                  //               children: [
                  //                 SizedBox(width: width * 0.012),
                  //                 Text(activeUser == null ? "0" : activeUser.toString(),
                  //                     style: TextStyle(
                  //                         fontFamily: 'Montserrat-Bold',
                  //                         color: AppColors.white,
                  //                         fontWeight: FontWeight.w700)),
                  //                 Text(
                  //                   "\t${'project_stats_screen_out_of_500k'.tr()}",
                  //                   style: TextStyle(
                  //                       fontFamily: 'Montserrat-Bold',
                  //                       color: AppColors.white,
                  //                       fontWeight: FontWeight.w700),
                  //                 ),
                  //               ],
                  //             ),
                  //             Center(
                  //               child: Container(
                  //                 margin: EdgeInsets.only(
                  //                   top: height * 0.01,
                  //                 ),
                  //                 child: LinearPercentIndicator(
                  //                   restartAnimation: true,
                  //                   width: width * 0.8,
                  //                   animation: true,
                  //                   lineHeight: height * 0.007,
                  //                   animationDuration: 2500,
                  //                   percent: getPercentage(activeUser ?? '0'),
                  //                   // center: const Text("50.0%"),
                  //                   linearStrokeCap: LinearStrokeCap.roundAll,
                  //                   backgroundColor: Color.fromARGB(255, 36, 22, 22),
                  //                   progressColor: Color(0xFFFFEA29),
                  //                 ),
                  //               ),
                  //             ),
                  //             SizedBox(height: height * 0.017),
                  //             Row(
                  //               children: [
                  //                 SizedBox(width: width * 0.015),
                  //                 Expanded(
                  //                   child: Text(
                  //                     'project_stats_screen_rate_of_2M'.tr(),
                  //                     style: TextStyle(
                  //                         fontFamily: 'Montserrat',
                  //                         color: AppColors.white,
                  //                         fontWeight: FontWeight.w400,
                  //                         fontSize: height * 0.01),
                  //                   ),
                  //                 ),
                  //               ],
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  SizedBox(height: height * 0.025),
                  InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: ((context) => OpenWhitePaperUrl())));
                    },
                    child: Container(
                      width: width * 0.94,
                      height: height * 0.080,
                      decoration: BoxDecoration(
                        color: Color(0xFFFDF2D6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Container(
                        margin: EdgeInsets.only(left: width * 0.02, right: width * 0.04),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SizedBox(width: width * 0.03),
                                SvgPicture.asset(
                                  'assets/svg_images/project.svg',
                                  color: Color(0xFF030D45),
                                ),
                                SizedBox(width: width * 0.03),
                                Text(
                                  'project_stats_screen_white_paper'.tr(),
                                  style: TextStyle(
                                      fontSize: height * 0.018,
                                      fontFamily: 'Montserrat',
                                      color: AppColors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.025),
                  InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: ((context) => OpenWithFaq())));
                    },
                    child: Container(
                      width: width * 0.94,
                      height: height * 0.080,
                      decoration: BoxDecoration(color: Color(0xFFFDF2D6), borderRadius: BorderRadius.circular(12)),
                      child: Container(
                        margin: EdgeInsets.only(left: width * 0.02, right: width * 0.04),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SizedBox(width: width * 0.03),
                                const Icon(Icons.help, color: Color(0xFF030D45)),
                                SizedBox(width: width * 0.03),
                                Text(
                                  'project_stats_screen_faq'.tr(),
                                  style: TextStyle(
                                      fontSize: height * 0.018,
                                      fontFamily: 'Montserrat',
                                      color: AppColors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.025),
                  InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: ((context) => whyAds())));
                    },
                    child: Container(
                      width: width * 0.94,
                      height: height * 0.080,
                      decoration: BoxDecoration(color: Color(0xFFFDF2D6), borderRadius: BorderRadius.circular(12)),
                      child: Container(
                        margin: EdgeInsets.only(left: width * 0.02, right: width * 0.04),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SizedBox(width: width * 0.03),
                                const Icon(Icons.volume_down_sharp, color: Color(0xFF030D45)),
                                SizedBox(width: width * 0.03),
                                Text(
                                  'project_stats_screen_why_ads'.tr(),
                                  style: TextStyle(
                                      fontSize: height * 0.018,
                                      fontFamily: 'Montserrat',
                                      color: AppColors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.025),
                  InkWell(
                    onTap: () async {
                      var data =
                          await Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingPage()));
                      setState(() {});
                    },
                    child: Container(
                      width: width * 0.94,
                      height: height * 0.080,
                      decoration: BoxDecoration(
                        color: Color(0xFFD3D3D3).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Container(
                        margin: EdgeInsets.only(left: width * 0.02, right: width * 0.04),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SizedBox(width: width * 0.03),
                                const Icon(Icons.settings, color: Color(0xFF030D45)),
                                SizedBox(width: width * 0.03),
                                Text(
                                  'setting_text'.tr(),
                                  style: TextStyle(
                                      fontSize: height * 0.018,
                                      fontFamily: 'Montserrat',
                                      color: AppColors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.03),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget OpenWhitePaperUrl() {
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
      ..loadRequest(Uri.parse('https://dotchain.network/doc.html'));
    return WebViewWidget(controller: controller);
  }

  Widget OpenWithFaq() {
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
      ..loadRequest(Uri.parse('https://dotchain.network/faq.html'));

    return WebViewWidget(controller: controller);
  }

  Widget whyAds() {
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
      ..loadRequest(Uri.parse('https://dotchain.network/ads.html'));

    return WebViewWidget(controller: controller);
  }
}
