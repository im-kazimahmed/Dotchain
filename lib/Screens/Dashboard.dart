import 'dart:async';
import 'dart:developer';
import 'package:coin_project/AppColors/appColors.dart';
import 'package:coin_project/Screens/IncreaseM.dart';
import 'package:coin_project/Screens/Profile.dart';
import 'package:coin_project/Screens/ProjectStats.dart';
import 'package:coin_project/Screens/m_screen.dart';
import 'package:coin_project/Screens/tasksPage.dart';
import 'package:coin_project/widgets/btn_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../ApiConnection/Api.dart';
import '../ApiConnection/network.dart';
import '../IntegrationWidget/CounterMethods.dart';
import '../Models/Speed_CurrentBalanceModel.dart';
import '../Models/totalUser_count_Model.dart';
import '../Models/usergameBalanceModel.dart';
import 'ViewTeam.dart';
import 'earnDotGold.dart';
import 'gamePage.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool loading = false;
  int? activeCount = 0, inactiveCount = 0;
  double? CurrentSpeed, totalUsersPercentage, activeUserPercentage;
  String? currentBalance, gameBalance, m_earnStatus, profileImage, maximum_rate, m_StartTime, totalUser, activeUser;
  late Future<UserGameBalanceModel> game_obj;

  @override
  void initState() {
    super.initState();
    _getCurrentBalance();
    getActiveInactiveCount();
    setUserProfile();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showUpdatesRewardAlertDialog();
    });
  }

  Future<void> showUpdatesRewardAlertDialog() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int? lastShownTimestamp = prefs.getInt('last_shown_dialog');
      int currentTime = DateTime.now().millisecondsSinceEpoch;
      log("current time ${currentTime.toString()}");
      log("last shown time ${lastShownTimestamp.toString()}");

      // Check if 24 hours have passed
      if (lastShownTimestamp != null && (currentTime - lastShownTimestamp < 24 * 60 * 60 * 1000)) {
        log("check if 24 hours are passed : not passed");
        return;
      }
      log("check if 24 hours are passed : passed");

      await prefs.setInt('last_shown_dialog', currentTime);

      Widget closeButton = Container(
        color: Colors.grey[200],
        padding: EdgeInsets.all(10.0),
        child: Align(
          alignment: Alignment.topRight,
          child: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
      );

      Widget divider = Divider(
        color: Colors.black,
        height: 1,
      );

      Widget checkUpdateButton = ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.yellow[700],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        ),
        child: Text(
          "splash_screen_reward_btn".tr(),
          style: TextStyle(
            fontFamily: 'Montserrat-Bold',
            color: Colors.black,
          ),
        ),
        onPressed: () async {
          Navigator.of(context).pop();
          var url = Uri.parse("https://t.me/Dot_Blockchain");
          if (await canLaunchUrl(url)) {
            await launchUrl(url);
            Future.delayed(Duration(seconds: 10), () {
              _updateGameBalance();
              print("10 seconds passed, performing action now.");
            });
          } else {
            throw 'Could not launch $url';
          }
        },
      );

      AlertDialog alert = AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
        ),
        contentPadding: EdgeInsets.all(0), // Remove default padding
        content: Container(
          decoration: BoxDecoration(
            color: Colors.white, // Dialog background color
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
            border: Border.all(color: Colors.black, width: 3.0), // Black border
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              closeButton, // Close button at the top with a different background color
              divider, // Divider between the close button and content
              Padding(
                padding: EdgeInsets.all(20.0), // Content padding
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      "splash_screen_reward_title".tr(),
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * 0.022,
                        fontFamily: 'Montserrat-Bold',
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    Text(
                      "splash_screen_reward_content".tr(),
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * 0.016,
                        fontFamily: 'Montserrat',
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    checkUpdateButton, // Button at the bottom
                  ],
                ),
              ),
            ],
          ),
        ),
      );

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return alert;
        },
      );
    } catch (e) {}
  }
  // UpdatesRewardAlertDialog() {
  //   // Close button
  //   Widget closeButton = Container(
  //     color: Colors.grey[200],
  //     padding: EdgeInsets.all(10.0),
  //     child: Align(
  //       alignment: Alignment.topRight,
  //       child: IconButton(
  //         icon: Icon(Icons.close),
  //         onPressed: () {
  //           Navigator.of(context).pop();
  //         },
  //       ),
  //     ),
  //   );
  //
  //   Widget divider = Divider(
  //     color: Colors.black,
  //     height: 1,
  //   );
  //
  //   Widget checkUpdateButton = ElevatedButton(
  //     style: ElevatedButton.styleFrom(
  //       backgroundColor: Colors.yellow[700],
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(10.0),
  //       ),
  //       padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
  //     ),
  //     child: Text("splash_screen_reward_btn".tr(),
  //       style: TextStyle(
  //         fontFamily: 'Montserrat-Bold',
  //         color: Colors.black,
  //       ),
  //     ),
  //     onPressed: () async {
  //       Navigator.of(context).pop();
  //       var url = Uri.parse("https://t.me/Dot_Blockchain");
  //       if (await canLaunchUrl(url)) {
  //         await launchUrl(url);
  //         Future.delayed(Duration(seconds: 10), () {
  //           _updateGameBalance();
  //           print("10 seconds passed, performing action now.");
  //         });
  //       } else {
  //         throw 'Could not launch $url';
  //       }
  //     },
  //   );
  //
  //   AlertDialog alert = AlertDialog(
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.all(Radius.circular(15.0)),
  //     ),
  //     contentPadding: EdgeInsets.all(0), // Remove default padding
  //     content: Container(
  //       decoration: BoxDecoration(
  //         color: Colors.white, // Dialog background color
  //         borderRadius: BorderRadius.all(Radius.circular(15.0)),
  //         border: Border.all(color: Colors.black, width: 3.0), // Black border
  //       ),
  //       child: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: <Widget>[
  //           closeButton, // Close button at the top with a different background color
  //           divider, // Divider between the close button and content
  //           Padding(
  //             padding: EdgeInsets.all(20.0), // Content padding
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: <Widget>[
  //                 Text("splash_screen_reward_title".tr(),
  //                   style: TextStyle(
  //                     fontSize: MediaQuery.of(context).size.height * 0.022,
  //                     fontFamily: 'Montserrat-Bold',
  //                   ),
  //                   textAlign: TextAlign.center,
  //                 ),
  //                 SizedBox(height: 10),
  //                 Text("splash_screen_reward_content".tr(),
  //                   style: TextStyle(
  //                     fontSize: MediaQuery.of(context).size.height * 0.016,
  //                     fontFamily: 'Montserrat',
  //                   ),
  //                   textAlign: TextAlign.center,
  //                 ),
  //                 SizedBox(height: 20),
  //                 checkUpdateButton, // Button at the bottom
  //               ],
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  //
  //   // show the dialog
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (BuildContext context) {
  //       return alert;
  //     },
  //   );
  // }


  _updateGameBalance() async {
    try {
      setState(() {
        loading = true;
      });
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? UserId = preferences.getString('UserID');
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
        setState(() {});
      } else if (engLang == "en") {
        language = engLang;
        preferences.remove('zh');
        preferences.remove('fil');
        preferences.remove('id');
        preferences.remove('ko');
        preferences.remove('vi');
        setState(() {});
      }
      Map request = {
        'user_id': UserId.toString(),
        'api_username': Api.api_username,
        'api_password': Api.api_password,
        'additional_coins': "1250",
      };
      Map<String, String> data = {"Accept-Language": language};
      String updateGameBalanceUrl = Api.base_url + Api.updateGameBalance;

      game_obj = ApiConnection().gamebalance(updateGameBalanceUrl, request, data);

      game_obj.then((value) {
        if (value.status == 1) {
          gameBalance = value.gameBalance;
          setState(() {
            loading = false;
          });
        }
      });
    } catch (e) {
      setState(() {
        loading = false;
      });
    }
  }

  Widget CurrentBalance() {
    return ValueListenableBuilder(
        valueListenable: incrementedBalance,
        builder: (context, balance, child) {
          return Row(
            children: [
              Text(
                m_earnStatus == "0" ? currentBalance.toString().split('.').first : balance.toString().split('.').first,
                style: TextStyle(
                    color: AppColors.white,
                    fontSize: MediaQuery.of(context).size.height * 0.035,
                    fontFamily: 'Montserrat-Bold',
                    fontWeight: FontWeight.bold),
              ),
              Text('.',
                  style: TextStyle(
                      color: AppColors.white,
                      fontSize: MediaQuery.of(context).size.height * 0.031,
                      fontFamily: 'Montserrat-Bold',
                      fontWeight: FontWeight.bold)),
              Container(
                margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height * 0.01,
                ),
                child: Text(
                  m_earnStatus == "0" ? currentBalance.toString().split('.').last : balance.toString().split('.').last,
                  style: TextStyle(
                      color: AppColors.white,
                      fontSize: MediaQuery.of(context).size.height * 0.022,
                      fontFamily: 'Montserrat-Bold',
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          );
        });
  }

  setUserProfile() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    profileImage = pref.getString("profileImage");
  }

  Future<Speed_CurrentBalanceModel>? balanceObj;
  _getCurrentBalance() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var UserId = preferences.getString('UserID');
    log("dashboard ${UserId}");
    preferences.setString('userID', UserId.toString());

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
    setState(() {
      loading = true;
      profileImage = preferences.getString("profileImage");
    });
    Map<String, String> data = {"Accept-Language": language};
    Map res = {
      'id': UserId.toString(),
      'api_username': Api.api_username,
      'api_password': Api.api_password,
    };
    String BalanceUrl = Api.base_url + Api.currentBalance;
    log("my lan $data");
    balanceObj = ApiConnection().CurrentBalance(BalanceUrl, res, data);
    balanceObj?.then((value) {
      if (value.status == 1) {
        currentBalance = value.miningBalance;
        CurrentSpeed = double.parse(value.currentMiningSpeed ?? "0.0");
        gameBalance = value.gameBalance;
        m_earnStatus = value.miningStatus;
        m_StartTime = value.miningStartAt;
        maximum_rate = value.maximumRate;
        preferences.setDouble('CurrentSpeed', CurrentSpeed!);
        preferences.setString('CurrentBalance', currentBalance!);
        preferences.setString('GameBalance', gameBalance!);
        preferences.setString('m_Status', m_earnStatus!);
        preferences.setString('m_StartTime', m_StartTime!);
        preferences.setString('maximum_rate', maximum_rate!);
        setCurrentSpeed(CurrentSpeed ?? 0.0);
        if (!isTimerSet && m_earnStatus == "1") {
          DateTime? getM_Time = DateTime.parse(m_StartTime.toString());
          var newDate = DateTime(
            getM_Time.year,
            getM_Time.month,
            getM_Time.day + 1,
            getM_Time.hour,
            getM_Time.minute,
            getM_Time.second,
          );
          DateTime? nowTime = DateTime.now();
          Duration finalTime = newDate.difference(nowTime);
          Duration startTimerDuration = Duration(seconds: finalTime.inSeconds);
          log(startTimerDuration.toString());
          setDuration(startTimerDuration);
          setCurrentBalance(currentBalance ?? "");
          startCounterTimer();
        }
      } else {
        Fluttertoast.showToast(msg: value.msg!);
      }
      setState(() {
        loading = false;
      });
    });
  }

  late Future<totalUser_count_Model> teamObj;
  getActiveInactiveCount() async {
    setState(() {
      loading = true;
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
    Map request = {
      'id': UserId.toString(),
      'api_username': Api.api_username,
      'api_password': Api.api_password,
    };
    Map<String, String> data = {"Accept-Language": language};
    String ActiveInactiveUrl = Api.base_url + Api.referal_Team;
    log("my lan $data");
    teamObj = ApiConnection().referalTeamCount(ActiveInactiveUrl, request, data);
    await teamObj.then((value) {
      if (value.status == 1) {
        setState(() {
          activeCount = value.result?.activeUsers;
          inactiveCount = value.result?.inactiveUsers;
          totalUser = value.result?.totalUsers;
          activeUser = value.result?.activeMiners;
          activeUserPercentage = value.result?.activeMinersPercentage;
          totalUsersPercentage = value.result?.totalUsersPercentage;
          preferences.setString('TotalUser', totalUser!);
          preferences.setString('ActiveUser', activeUser!);
          preferences.setDouble('totalUsersPercentage', totalUsersPercentage!);
          preferences.setDouble('activeUserPercentage', activeUserPercentage!);
          preferences.setInt('ActiveCount', activeCount!);
          preferences.setInt('InactiveCount', inactiveCount!);
        });
      } else {
        Fluttertoast.showToast(msg: value.msg.toString());
      }
      setState(() {
        loading = false;
      });
    });
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
    final percentage = (parsedCount / 500000);
    return percentage;
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
            child: Stack(
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
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const IncreaseM_Screen()));
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
                                    Text(
                                      CurrentSpeed == null ? "0.0" : CurrentSpeed.toString(),
                                      style: TextStyle(
                                          color: Color(0xFF2C2C2C),
                                          fontWeight: FontWeight.w700,
                                          fontFamily: 'Montserrat-Bold',
                                          fontSize: height * 0.022),
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
                        InkWell(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const earnDotGoldScreen()));
                          },
                          child: Stack(
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: height * 0.06, left: width * 0.02),
                                height: height * 0.045,
                                width: width * 0.24,
                                decoration: BoxDecoration(
                                    color: const Color(0xFF00E469).withOpacity(0.18),
                                    borderRadius: BorderRadius.circular(25)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      gameBalance == null ? '0' : gameBalance.toString(),
                                      style: TextStyle(
                                          color: Color(0xFF2C2C2C),
                                          fontFamily: 'Montserrat-Bold',
                                          fontWeight: FontWeight.w700,
                                          fontSize: height * 0.022),
                                    ),
                                    SizedBox(
                                      width: width * 0.02,
                                    ),
                                    Image.asset(
                                      'assets/images/20220803_194614_0000-removebg-preview (1).png',
                                      height: 24,
                                      width: 24,
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: width * 0.23, top: height * 0.05),
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
                      ],
                    ),
                    Row(
                      children: [
                        InkWell(
                          onTap: () async {
                            final data =
                                await Navigator.push(context, MaterialPageRoute(builder: (context) => const Profile()));
                            setState(() {
                              setUserProfile();
                            });
                          },
                          child: Container(
                              margin: EdgeInsets.only(top: height * 0.06, right: width * 0.03),
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
                  ],
                ),
                Stack(children: [
                  Center(
                    child: Container(
                      margin: EdgeInsets.only(
                        top: height * 0.03,
                      ),
                      height: height * 0.23,
                      width: width * 0.94,
                      decoration:
                          BoxDecoration(borderRadius: BorderRadius.circular(10), color: const Color(0xFF1F242A)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: width * 0.05, top: height * 0.03),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    margin: EdgeInsets.only(left: width * 0.03),
                                    child: Text(
                                      'dash_board_blc'.tr(),
                                      style: TextStyle(
                                          color: AppColors.white,
                                          fontSize: height * 0.022,
                                          fontWeight: FontWeight.w600),
                                    )),
                                SizedBox(
                                  height: height * 0.015,
                                ),
                                Stack(
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset('assets/images/balance.png', width: width * 0.099),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: height * 0.015,
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: width * 0.025,
                                    ),
                                    Image.asset(
                                      'assets/images/20220803_194614_0000-removebg-preview (1).png',
                                      height: 25,
                                      width: 25,
                                    ),
                                    SizedBox(
                                      width: width * 0.01,
                                    ),
                                    Stack(
                                      children: [
                                        Container(
                                            margin: EdgeInsets.only(
                                              left: width * 0.02,
                                            ),
                                            child: SvgPicture.asset(
                                              'assets/svg_images/Ellipse 18.svg',
                                            )),
                                        Container(
                                            margin: EdgeInsets.only(
                                              top: height * 0.003,
                                            ),
                                            child: Text(
                                              gameBalance ?? '0',
                                              style: TextStyle(
                                                color: AppColors.mainColor1,
                                                fontSize: height * 0.03,
                                                fontWeight: FontWeight.w400,
                                                fontFamily: 'Montserrat-Bold',
                                              ),
                                            )),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Image.asset('assets/images/Ellipse 19 (1).png', width: width * 0.1),
                          Container(
                            child: Column(
                              children: [
                                Stack(
                                  children: [
                                    //SizedBox(width: width * 0.01,),
                                    Container(
                                      margin: EdgeInsets.only(top: height * 0.001, right: width * 0.01),
                                      height: height * 0.13,
                                      width: width * 0.25,
                                      child: Image.asset('assets/images/pngegg.png',
                                          width: width * 0.2, height: height * 0.1, fit: BoxFit.fill),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: height * 0.01,
                                ),
                                InkWell(
                                  onTap: () {
                                    log("..........................................");
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const M_Screen()));
                                  },
                                  child: Container(
                                    height: height * 0.065,
                                    width: width * 0.14,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(100),
                                        gradient: const LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [Color(0xFFFEAC02), Color(0xFFFF8133), Color(0xFFFF8134)])),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset('assets/svg_images/arrow.svg'),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(margin: EdgeInsets.only(left: width * 0.18, top: height * 0.1), child: CurrentBalance()),
                  Container(
                    margin: EdgeInsets.only(
                      top: height * 0.09,
                    ),
                    child: Image.asset('assets/images/Ellipse 19.png', width: width * 0.05),
                  ),
                  Container(
                      margin: EdgeInsets.only(top: height * 0.1, left: width * 0.65),
                      child: SvgPicture.asset('assets/svg_images/Ellipse 18.svg')),
                ]),
                Container(
                  margin: EdgeInsets.only(left: width * 0.015, right: width * 0.015, top: height * 0.03),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                          height: height * 0.21,
                          width: width * 0.45,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color(0xFFFFE4D3),
                          ),
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: height * 0.02, left: width * 0.02),
                                child: Stack(
                                  children: [
                                    Container(
                                        margin: EdgeInsets.only(left: width * 0.23, top: height * 0.01),
                                        child: Image.asset(
                                          'assets/images/video-console .png',
                                          width: width * 0.19,
                                          fit: BoxFit.contain,
                                        )),
                                    Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'dash_board_earn_ace'.tr(),
                                              style: TextStyle(
                                                  fontSize: height * 0.019,
                                                  color: Color(0xFF545454),
                                                  fontWeight: FontWeight.w700,
                                                  fontFamily: 'Montserrat-Bold'),
                                            ),
                                            SizedBox(height: height * 0.01),
                                            Text(
                                              'dash_board_PlayGame_Win_Ace'.tr(),
                                              style: TextStyle(
                                                  fontSize: height * 0.018,
                                                  color: AppColors.black,
                                                  fontWeight: FontWeight.w700,
                                                  fontFamily: 'Montserrat-Bold'),
                                            ),
                                          ],
                                        ),
                                        //SizedBox(width: width * 0.02),
                                      ],
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => GamePage()));
                                      },
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(top: height * 0.13, right: width * 0.02),
                                            height: height * 0.045,
                                            width: width * 0.4,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                                gradient: LinearGradient(
                                                    begin: Alignment.topCenter,
                                                    end: Alignment.bottomRight,
                                                    colors: [Color(0xFFF3A800), Colors.yellow.shade600])),
                                            child: Center(
                                                child: Text('dash_board_PlayNow'.tr(),
                                                    style: TextStyle(
                                                        fontSize: height * 0.014,
                                                        letterSpacing: 0.5,
                                                        fontWeight: FontWeight.w600,
                                                        color: AppColors.black,
                                                        fontFamily: 'Montserrat-Bold'))),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )),
                      Container(
                          height: height * 0.21,
                          width: width * 0.45,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color(0xFFFEFACB),
                          ),
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: height * 0.02, left: width * 0.02),
                                child: Stack(
                                  children: [
                                    Container(
                                        margin: EdgeInsets.only(left: width * 0.17, top: height * 0.003),
                                        child: Image.asset(
                                          'assets/images/teamwork 1 (3).png',
                                        )),
                                    Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'dash_board_My_team'.tr(),
                                              style: TextStyle(
                                                  fontSize: height * 0.019,
                                                  color: Color(0xFF545454),
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Montserrat-Bold'),
                                            ),
                                            SizedBox(height: height * 0.015),
                                            Row(
                                              children: [
                                                Image.asset(
                                                  'assets/images/right.png',
                                                  width: 15,
                                                  height: 15,
                                                ),
                                                SizedBox(
                                                  width: width * 0.015,
                                                ),
                                                Text(
                                                  activeCount == null ? '0' : activeCount.toString(),
                                                  style: TextStyle(
                                                      color: AppColors.black,
                                                      fontFamily: 'Montserrat-Bold',
                                                      fontWeight: FontWeight.bold),
                                                )
                                              ],
                                            ),
                                            SizedBox(height: height * 0.005),
                                            Row(
                                              children: [
                                                Image.asset('assets/images/wrong.png', width: 15, height: 15),
                                                SizedBox(
                                                  width: width * 0.015,
                                                ),
                                                Text(
                                                  inactiveCount == null ? '0' : inactiveCount.toString(),
                                                  style: TextStyle(
                                                      color: AppColors.black,
                                                      fontFamily: 'Montserrat-Bold',
                                                      fontWeight: FontWeight.bold),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context, MaterialPageRoute(builder: (context) => const ViewTeamScreen()));
                                      },
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(
                                              top: height * 0.13,
                                            ),
                                            height: height * 0.045,
                                            width: width * 0.4,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                                gradient: LinearGradient(
                                                    begin: Alignment.topCenter,
                                                    end: Alignment.bottomRight,
                                                    colors: [Color(0xFFF3A800), Colors.yellow.shade600])),
                                            child: Center(
                                                child: Text('dash_board_view'.tr(),
                                                    style: TextStyle(
                                                        fontSize: height * 0.014,
                                                        letterSpacing: 0.5,
                                                        fontWeight: FontWeight.w600,
                                                        color: AppColors.black,
                                                        fontFamily: 'Montserrat-Bold'))),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          )),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => TasksPage()));
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: height * 0.03),
                    width: width * 0.94,
                    padding: EdgeInsets.only(left:20, right: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xffeab6).withOpacity(1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                          child: Container(
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'home_screen_unlock_extra_rewards'.tr(),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Montserrat-Bold',
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        'home_screen_complete_tasks'.tr(),
                                        style: TextStyle(
                                          fontSize: 10.5,
                                          color: Color(0xFF545454),
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Montserrat-Bold',
                                        ),
                                        overflow: TextOverflow.clip,
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => TasksPage()));
                                    },
                                    child: Image.asset(
                                      "assets/images/tasks.png",
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                //
                // Container(
                //   margin: EdgeInsets.only(left: width * 0.18),
                //   width: MediaQuery.of(context).size.width,
                //   height: 120,
                //   child: Container(
                //     margin: EdgeInsets.only(top: height * 0.03),
                //     width: width * 0.94,
                //     padding: EdgeInsets.all(20),
                //     decoration: BoxDecoration(
                //       borderRadius: BorderRadius.circular(10),
                //       color: const Color(0xffeab6).withOpacity(1),
                //       // image: DecorationImage(
                //       //   image: AssetImage("assets/images/tasks.png"),
                //       //   alignment: Alignment.centerRight,
                //       // ),
                //     ),
                //     child: Row(
                //       children: [
                //         Expanded(
                //           flex: 2,
                //           child: Column(
                //             crossAxisAlignment: CrossAxisAlignment.start,
                //             children: [
                //               Text(
                //                 "Unlock Extra Rewards - Tasks",
                //                 style: TextStyle(
                //                   fontSize: 12,
                //                   color: Color(0xFF545454),
                //                   fontWeight: FontWeight.bold,
                //                   fontFamily: 'Montserrat-Bold',
                //                 ),
                //               ),
                //               Text(
                //                 "Complete tasks and unlock more rewarding opportunities!",
                //                 style: TextStyle(
                //                   fontSize: 10.5,
                //                   color: Color(0xFF545454),
                //                   fontWeight: FontWeight.bold,
                //                   fontFamily: 'Montserrat-Bold',
                //                 ),
                //                 overflow: TextOverflow.clip,
                //               ),
                //             ],
                //           ),
                //         ),
                //         Expanded(
                //           flex: 1,
                //           child: InkWell(
                //             onTap: () {
                //               Navigator.push(context, MaterialPageRoute(builder: (context) => TasksPage()));
                //             },
                //             child: Image.asset(
                //               "assets/images/tasks.png",
                //               fit: BoxFit.cover,
                //             ),
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),


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
                          fontSize: 18,
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
                      //     fontSize: 20,
                      //     color: Colors.black,
                      //     fontWeight: FontWeight.bold,
                      //     fontFamily: 'Montserrat-Bold',
                      //   ),
                      //   textAlign: TextAlign.center,
                      // ),
                      SizedBox(height: height * 0.03),
                      Center(
                        child: Container(
                          height: height * 0.055,
                          width: width * 0.75,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomRight,
                                  colors: [Color(0xFFF3A800), Colors.yellow.shade600])),
                          child: btn_widget(
                            btntext: 'follow_us'.tr().toUpperCase(),
                            color: Colors.transparent,
                            onTap: () async {
                              try {
                                "Launch URL: https://t.me/Dot_Blockchain";
                                if (!await launchUrl(
                                  Uri.parse("https://t.me/Dot_Blockchain"),
                                  mode: LaunchMode.externalApplication,
                                )) {}
                              } catch (ex) {
                                "Could not launch url $ex";
                              }
                            },
                            textStyle: TextStyle(
                                fontSize: height * 0.016,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.2,
                                color: AppColors.black,
                                fontFamily: 'Montserrat-Bold'),
                            roundedRectangleBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ),
                    ],
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
                          decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(12)),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: height * 0.4, left: width * 0.35),
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                        ),
                        Container(
                          height: 33,
                          width: 33,
                          margin: EdgeInsets.only(left: width * 0.44, top: height * 0.44),
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
        )),
      ),
    );
  }
}
