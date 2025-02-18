import 'dart:async';
import 'dart:io';
import 'dart:developer';
import 'package:applovin_max/applovin_max.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';
import '../ApiConnection/Api.dart';
import '../ApiConnection/network.dart';
import '../AppColors/appColors.dart';
import '../IntegrationWidget/CounterMethods.dart';
import '../Models/SendReminderModel.dart';
import '../Models/Start_M_Model.dart';
import 'IncreaseM.dart';
import 'Profile.dart';

class M_Screen extends StatefulWidget {
  const M_Screen({Key? key}) : super(key: key);

  @override
  State<M_Screen> createState() => _M_ScreenState();
}

class _M_ScreenState extends State<M_Screen> {
  String subject = '';
  String? Email,
      referCode,
      currentBalance,
      storeBalance,
      m_Status = "",
      m_Time,
      profileImage,
      maximum_rate,
      counterTime;
  double? currentSpeed = 1.5;
  int? activeCount, inactiveCount, totalTeam;
  Timer? countdownTimer, timer;
  int speed1 = 0;
  final String _rewarded_ad_unit_id1 = Platform.isAndroid ? "40b342303794ffa4" : "IOS_REWARDED_AD_UNIT_ID";
  bool loading = false, btnChange = false;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  void loadApplovinRewordedAds() {
    setState(() {
      loading = true;
      log("::::::::::::::::::::::::::::::::::");
      log("part one");
      log("::::::::::::::::::::::::::::::::::");
    });
    Timer t = Timer(Duration(seconds: 10), () {
      setState(() {
        log("::::::::::::::::::::::::::::::::::");
        log("part two");
        log("::::::::::::::::::::::::::::::::::");
        loading = false;
      });
      start_m2();
    });
    AppLovinMAX.setRewardedAdListener(RewardedAdListener(
        onAdLoadedCallback: (ad) {
          t.cancel();
          AppLovinMAX.showRewardedAd(_rewarded_ad_unit_id1);
        },
        onAdLoadFailedCallback: (String adUnitId, error) {
          log("=====================================================");
          log("onAdLoadFailedCallback Message: ${error.message}");
          log("onAdLoadFailedCallback Code: ${error.code}");
          log("=====================================================");
          setState(() {
            loading = false;
            log("::::::::::::::::::::::::::::::::::");
            log("part three");
            log("::::::::::::::::::::::::::::::::::");
          });
        },
        onAdDisplayedCallback: (ad) {
          setState(() {
            loading = false;
            log("::::::::::::::::::::::::::::::::::");
            log("part four");
            log("::::::::::::::::::::::::::::::::::");
          });
        },
        onAdDisplayFailedCallback: (ad, error) {
          log("=====================================================");
          log("onAdLoadFailedCallback Message: ${error.message}");
          log("onAdLoadFailedCallback Code: ${error.code}");
          log("=====================================================");
          setState(() {
            loading = false;
            log("::::::::::::::::::::::::::::::::::");
            log("part five");
            log("::::::::::::::::::::::::::::::::::");
          });
        },
        onAdClickedCallback: (ad) {},
        onAdHiddenCallback: (ad) {
          start_m();
        },
        onAdReceivedRewardCallback: (ad, reward) {}));
    AppLovinMAX.loadRewardedAd(_rewarded_ad_unit_id1);
  }

  getUserData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    Email = preferences.getString('UserEamil');
    referCode = preferences.getString('Referalcode');
    currentBalance = preferences.getString('CurrentBalance');
    currentSpeed = preferences.getDouble('CurrentSpeed');
    activeCount = preferences.getInt('ActiveCount');
    inactiveCount = preferences.getInt('InactiveCount');
    m_Status = preferences.getString('m_Status');
    m_Time = preferences.getString('m_StartTime');

    maximum_rate = preferences.getString('maximum_rate');
    if (activeCount == null) {
      activeCount = 0;
    }
    if (inactiveCount == null) {
      inactiveCount = 0;
    }
    totalTeam = activeCount! + inactiveCount!;
    setState(() {
      profileImage = preferences.getString('profileImage');
    });
  }

  Widget CurrentBalance() {
    return ValueListenableBuilder(
        valueListenable: incrementedBalance,
        builder: (context, balance, child) {
          return Row(
            children: [
              Text(
                m_Status == "0" ? currentBalance!.split('.').first : balance.toString().split('.').first,
                style: TextStyle(
                    color: AppColors.black,
                    fontSize: MediaQuery.of(context).size.height * 0.035,
                    fontFamily: 'Montserrat-Bold',
                    fontWeight: FontWeight.bold),
              ),
              Text('.',
                  style: TextStyle(
                      color: AppColors.black,
                      fontSize: MediaQuery.of(context).size.height * 0.031,
                      fontFamily: 'Montserrat-Bold',
                      fontWeight: FontWeight.bold)),
              Container(
                margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height * 0.01,
                ),
                child: Text(
                  m_Status == "0" ? currentBalance!.split('.').last : balance.toString().split('.').last,
                  style: TextStyle(
                      color: AppColors.black,
                      fontSize: MediaQuery.of(context).size.height * 0.022,
                      fontFamily: 'Montserrat-Bold',
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          );
        });
  }

  void _onShare(BuildContext context) async {
    final box = context.findRenderObject() as RenderBox?;
    Share.share(
        "${"mining_invite_text_one".tr()}"
        "${"mining_invite_text_two".tr()}"
        "${"mining_invite_text_three".tr()}"
        "${"https://dotchain.network/refer/$referCode "}"
        "${"mining_invite_text_five".tr()}"
        "${"($referCode)"}"
        "${"mining_invite_text_six".tr()}"
        "${"mining_inactive_100_live_stats".tr()}",
        subject: subject,
        sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
  }

  Widget buildCounterTime() {
    return ValueListenableBuilder(
        valueListenable: durationValue1,
        builder: (
          context,
          duration,
          child,
        ) {
          Duration myDuration1 = duration as Duration;
          if (myDuration1.isNegative) {
            myDuration1 = Duration.zero;
          }
          String twoDigits(int n) => n.toString().padLeft(2, '0');
          var hour, minutes, seconds;
          hour = twoDigits(myDuration1.inHours.remainder(24));
          minutes = twoDigits(myDuration1.inMinutes.remainder(60));
          seconds = twoDigits(myDuration1.inSeconds.remainder(60));
          String TotalTime = "$hour:$minutes:$seconds";
          return Text(
            m_Status == '1' ? TotalTime : '00:00:00',
            style: TextStyle(
                color: AppColors.black,
                fontFamily: 'Montserrat-Bold',
                fontWeight: FontWeight.bold,
                fontSize: MediaQuery.of(context).size.height * 0.02),
          );
        });
  }

  late Future<reminderModel> reminder_obj;

  _sendReminder() async {
    setState(() {
      btnChange = true;
    });
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var UserId = preferences.getString('UserID');
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
      preferences.remove('zh');
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
    String SendReminderUrl = Api.base_url + Api.sendReminder;
    debugPrint("Send Reminder Url :::::$SendReminderUrl");
    Map Request = {
      "id": UserId,
      "api_username": Api.api_username,
      "api_password": Api.api_password,
    };

    Map<String, String> data = {"Accept-Language": language};
    log("my lan $data");
    reminder_obj = ApiConnection().sendReminder(SendReminderUrl, Request, data);
    await reminder_obj.then((response) {
      if (response.status == 1) {
        Fluttertoast.showToast(msg: response.msg.toString());
      } else {
        Fluttertoast.showToast(msg: response.msg.toString());
      }
      setState(() {
        btnChange = false;
      });
    });
  }

  late Future<Start_M_Model> start_m_obj;

  start_m() async {
    setState(() {
      btnChange = true;
      log("::::::::::::::::::::::statrt minig:::::::");
    });
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var UserId = preferences.getString("UserID");
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
    Map res = {"id": UserId.toString(), "api_username": Api.api_username, "api_password": Api.api_password};
    Map<String, String> data = {"Accept-Language": language};
    String Start_M_url = Api.base_url + Api.startEarnCoin;
    log(Start_M_url);
    log("my lan $data");
    start_m_obj = ApiConnection().Start_m(Start_M_url, res, data);
    await start_m_obj.then((value) {
      if (value.status == 1) {
        Fluttertoast.showToast(
          msg: value.msg.toString(),
        );
        setState(() {
          m_Status = "1";
          setCurrentBalance(currentBalance ?? "");
          setDuration(const Duration(days: 1));
          setCurrentSpeed(currentSpeed ?? 0);
          startCounterTimer();
        });
      } else {
        Fluttertoast.showToast(msg: value.msg.toString());
      }
      setState(() {
        btnChange = false;
        log("::::::::::::::::::::::statrt minig:::::::");
      });
    });
  }

  start_m2() async {
    setState(() {
      loading = true;
      log("::::::::::::::::::::::statrt minig:::::::");
    });
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var UserId = preferences.getString("UserID");
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
    Map res = {"id": UserId.toString(), "api_username": Api.api_username, "api_password": Api.api_password};
    Map<String, String> data = {"Accept-Language": language};
    String Start_M_url = Api.base_url + Api.startEarnCoin;
    log(Start_M_url);
    log("my lan $data");
    start_m_obj = ApiConnection().Start_m(Start_M_url, res, data);
    await start_m_obj.then((value) {
      if (value.status == 1) {
        Fluttertoast.showToast(
          msg: value.msg.toString(),
        );
        setState(() {
          m_Status = "1";
          setCurrentBalance(currentBalance ?? "");
          setDuration(const Duration(days: 1));
          setCurrentSpeed(currentSpeed ?? 0);
          startCounterTimer();
        });
      } else {
        Fluttertoast.showToast(msg: value.msg.toString());
      }
      setState(() {
        loading = false;
        log("::::::::::::::::::::::statrt minig:::::::");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context, MaterialPageRoute(builder: (context) => const IncreaseM_Screen()));
                                },
                                child: Stack(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(top: height * 0.06, left: width * 0.03),
                                      height: height * 0.045,
                                      width: width * 0.21,
                                      decoration: BoxDecoration(
                                          color: const Color(0xFFFDF9CA), borderRadius: BorderRadius.circular(25)),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          //SizedBox(width: width * 0.01,),
                                          Text(
                                            currentSpeed == null ? "0.0" : currentSpeed.toString(),
                                            style: TextStyle(
                                                color: Color(0xFF2C2C2C),
                                                fontWeight: FontWeight.w700,
                                                fontFamily: 'Montserrat-Bold',
                                                fontSize: height * 0.021),
                                          ),
                                          SizedBox(
                                            width: width * 0.01,
                                          ),
                                          Image.asset(
                                            'assets/images/CHECK.png',
                                            height: 22,
                                            width: 22,
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: width * 0.2, top: height * 0.05),
                                      height: 20,
                                      width: 20,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(100),
                                        color: Color(0xFFFF7E2F),
                                      ),
                                      child: Container(
                                          margin: EdgeInsets.only(bottom: height * 0.02, top: height * 0.003),
                                          child: Icon(
                                            Icons.add,
                                            color: AppColors.black,
                                            size: 15,
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: height * 0.06, left: width * 0.03),
                                height: height * 0.045,
                                width: width * 0.35,
                                decoration: BoxDecoration(
                                    color: Color(0xFF424242).withOpacity(0.2), borderRadius: BorderRadius.circular(25)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.access_time, size: 20),
                                    SizedBox(
                                      width: width * 0.02,
                                    ),
                                    buildCounterTime()
                                  ],
                                ),
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: () async {
                              final data = await Navigator.push(
                                  context, MaterialPageRoute(builder: (context) => const Profile()));
                              getUserData();
                            },
                            child: Container(
                                margin: EdgeInsets.only(top: height * 0.06, right: width * 0.05),
                                height: height * 0.055,
                                width: width * 0.12,
                                decoration: BoxDecoration(
                                  color: AppColors.lightGray.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: profileImage == null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(100),
                                        child: Image.asset(
                                          'assets/images/profileimage.jpg',
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : ClipRRect(
                                        borderRadius: BorderRadius.circular(100),
                                        child: profileImage != null
                                            ? ClipRRect(
                                                borderRadius: BorderRadius.circular(100),
                                                child: Image.network(profileImage!.toString(), fit: BoxFit.cover))
                                            : Image.asset(
                                                'assets/images/profileimage.jpg',
                                                fit: BoxFit.cover,
                                              ))),
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(top: height * 0.04),
                        height: height * 0.2,
                        width: width * 0.9,
                        decoration: BoxDecoration(
                          color: AppColors.lightGray.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Container(
                          margin: EdgeInsets.only(top: height * 0.040, left: width * 0.04),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  margin: EdgeInsets.only(left: width * 0.025),
                                  child: Text(
                                    'mining_curr_bal'.tr(),
                                    style: TextStyle(
                                        fontSize: height * 0.019,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Montserrat-Bold'),
                                  )),
                              SizedBox(height: height * 0.01),
                              Row(
                                children: [
                                  Image.asset(
                                    'assets/images/balance.png',
                                    width: width * 0.1,
                                    color: AppColors.black,
                                  ),
                                  Stack(
                                    children: [CurrentBalance()],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: height * 0.03),
                      Container(
                        margin: EdgeInsets.only(
                          left: width * 0.04,
                          right: width * 0.04,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              height: height * 0.07,
                              width: width * 0.43,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: const Color(0xFFEFF1FF),
                              ),
                              child: Center(
                                  child: Text(
                                '${"mining_curr_ret".tr()} : ${currentSpeed ?? '1.5'}/hr '.tr(),
                                style: TextStyle(
                                    letterSpacing: 0.2,
                                    fontSize: height * 0.016,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Montserrat-Bold'),
                              )),
                            ),
                            Container(
                              height: height * 0.07,
                              width: width * 0.43,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: const Color(0xFFFDFBC9).withOpacity(0.5),
                              ),
                              child: Center(
                                  child: Text(
                                maximum_rate == null
                                    ? 'mining_maxi_ret : 0/hr'.tr()
                                    : '${"mining_maxi_ret".tr()} : ${maximum_rate.toString()}/hr',
                                style: TextStyle(
                                    letterSpacing: 0.2,
                                    fontSize: height * 0.016,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Montserrat-Bold'),
                              )),
                            ),
                          ],
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.only(top: height * 0.02),
                          height: height * 0.16,
                          width: width * 0.9,
                          decoration: BoxDecoration(
                              color: AppColors.lightGray.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            children: [
                              SizedBox(height: height * 0.01),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 8,
                                    width: 8,
                                    decoration:
                                        BoxDecoration(borderRadius: BorderRadius.circular(100), color: AppColors.green),
                                  ),
                                  SizedBox(
                                    width: width * 0.01,
                                  ),
                                  Text(
                                    'mining_active'.tr(),
                                    style: TextStyle(
                                        color: AppColors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: height * 0.015,
                                        fontFamily: 'Montserrat'),
                                  ),
                                  SizedBox(
                                    width: width * 0.02,
                                  ),
                                  Container(
                                    height: height * 0.025,
                                    width: width * 0.1,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: AppColors.green.withOpacity(0.2)),
                                    child: Center(
                                      child: Text(
                                        activeCount == null ? '0' : activeCount.toString(),
                                        style: TextStyle(
                                            fontSize: height * 0.012,
                                            color: AppColors.green,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Montserrat'),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: width * 0.03,
                                  ),
                                  Container(
                                    height: 8,
                                    width: 8,
                                    decoration:
                                        BoxDecoration(borderRadius: BorderRadius.circular(100), color: Colors.red),
                                  ),
                                  SizedBox(
                                    width: width * 0.01,
                                  ),
                                  Text(
                                    'mining_inactive'.tr(),
                                    style: TextStyle(
                                        color: AppColors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: height * 0.015,
                                        fontFamily: 'Montserrat'),
                                  ),
                                  SizedBox(
                                    width: width * 0.02,
                                  ),
                                  Container(
                                    height: height * 0.025,
                                    width: width * 0.1,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20), color: Colors.red.withOpacity(0.2)),
                                    child: Center(
                                      child: Text(
                                        inactiveCount == null ? '0' : inactiveCount.toString(),
                                        style: TextStyle(
                                            fontSize: height * 0.012,
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Montserrat'),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: height * 0.02),
                              Container(
                                child: Text(
                                  '${activeCount == null ? '0' : activeCount.toString()} ${"mining_out_of".tr()} ${totalTeam == null ? '0' : totalTeam.toString()} ${"mining_are_mining_now".tr()}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500, fontSize: height * 0.012, fontFamily: 'Montserrat'),
                                ),
                              ),
                              SizedBox(height: height * 0.015),
                              Stack(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      _sendReminder();
                                    },
                                    child: Container(
                                      height: height * 0.060,
                                      width: width * 0.8,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomRight,
                                            colors: [Color(0xFFF3A800), Colors.yellow.shade600]),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      alignment: Alignment.center,
                                      child: Container(
                                          height: height * 0.02,
                                          alignment: Alignment.center,
                                          child: Text('mining_are_send_reminder'.tr(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontFamily: 'Montserrat-Bold',
                                                  fontSize: height * 0.017))),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: height * 0.02, left: width * 0.04),
                                    child: SvgPicture.asset('assets/svg_images/reminder.svg'),
                                  ),
                                ],
                              ),
                              // SizedBox(height: 20),
                            ],
                          )),
                      Container(
                        margin: EdgeInsets.only(top: height * 0.02),
                        height: height * 0.11,
                        width: width * 0.9,
                        decoration: BoxDecoration(
                            color: AppColors.lightGray.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              width: width * 0.45,
                              child: Text(
                                'mining_increase_mining_rate_by'.tr(),
                                style: TextStyle(
                                    fontSize: height * 0.013,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.2,
                                    fontFamily: 'Montserrat-Bold'),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                _onShare(context);
                              },
                              child: Stack(
                                children: [
                                  Container(
                                      alignment: Alignment.center,
                                      height: height * 0.050,
                                      width: width * 0.4,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomRight,
                                            colors: [Color(0xFFF3A800), Colors.yellow.shade600]),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Container(
                                        height: height * 0.02,
                                        child: Text('mining_invite'.tr(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontFamily: 'Montserrat-Bold',
                                                fontSize: height * 0.016)),
                                      )),
                                  Container(
                                    margin: EdgeInsets.only(top: height * 0.015, left: width * 0.04),
                                    child: SvgPicture.asset('assets/svg_images/people.svg', width: 20, height: 16),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          if (m_Status == "0") {
                            Vibration.vibrate();
                            //start_m();
                            loadApplovinRewordedAds();
                          } else {
                            return null;
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: height * 0.06),
                          width: width * 0.9,
                          height: height * 0.055,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: m_Status == "1" ? AppColors.gray : AppColors.black),
                          child: Center(
                              child: Image.asset('assets/images/balance.png',
                                  width: width * 0.12, color: m_Status == "1" ? AppColors.black : AppColors.mainColor)),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    child: loading
                        ? Center(
                            child: Stack(
                            children: [
                              Container(
                                //margin: EdgeInsets.only(top: height * 0.25),
                                height: height, width: width,
                                decoration:
                                    BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(12)),
                              ),
                              Center(
                                child: Container(
                                  margin: EdgeInsets.only(top: height * 0.4),
                                  height: 100,
                                  width: 200,
                                  decoration:
                                      BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                                ),
                              ),
                              Column(
                                children: [
                                  Container(
                                    height: 33,
                                    width: 33,
                                    margin: EdgeInsets.only(top: height * 0.44, left: width * 0.2),
                                    child: LoadingIndicator(
                                      indicatorType: Indicator.ballBeat,
                                      colors: [AppColors.orange, AppColors.black, AppColors.gray],
                                      strokeWidth: 1,
                                      pathBackgroundColor: Colors.black,
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: width * 0.22),
                                    width: width * 0.55,
                                    child: Text(
                                      'start_mining_20_second'.tr(),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: height * 0.01,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 0.2,
                                          fontFamily: 'Montserrat-Bold'),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ))
                        : null,
                  ),
                  Container(
                    child: btnChange
                        ? Center(
                            child: Stack(
                            children: [
                              Center(
                                child: Container(
                                  margin: EdgeInsets.only(top: height * 0.4),
                                  height: 100,
                                  width: 100,
                                  decoration:
                                      BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(12)),
                                ),
                              ),
                              Center(
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  margin: EdgeInsets.only(top: height * 0.435),
                                  child: LoadingIndicator(
                                    indicatorType: Indicator.ballBeat,
                                    colors: [AppColors.orange, AppColors.black, AppColors.gray],
                                    strokeWidth: 1,
                                    pathBackgroundColor: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ))
                        : null,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
