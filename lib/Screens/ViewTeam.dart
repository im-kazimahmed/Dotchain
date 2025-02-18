import 'dart:developer';

import 'package:coin_project/ApiConnection/Api.dart';
import 'package:coin_project/ApiConnection/network.dart';
import 'package:coin_project/Models/SendReminderModel.dart';
import 'package:coin_project/Screens/IncreaseM.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../AppColors/appColors.dart';
import '../IntegrationWidget/CounterMethods.dart';
import 'Activeuser.dart';
import 'Inactiveuser.dart';
import 'Profile.dart';

class ViewTeamScreen extends StatefulWidget {
  const ViewTeamScreen({Key? key}) : super(key: key);

  @override
  State<ViewTeamScreen> createState() => _ViewTeamScreenState();
}

class _ViewTeamScreenState extends State<ViewTeamScreen> {
  final TeamTab = [const ActiveUser(), const InActiveUser()];
  int teamIndex = 0;
  bool loading = false;
  int? activeCount = 0, inactiveCount = 0;
  double? currentSpeed;
  String? m_Status, m_Time, profileImage;

  @override
  void initState() {
    super.initState();
    getActiveInactiveCount();
    profileImageGet();
  }

  profileImageGet() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    profileImage = preferences.getString('profileImage');
  }

  getActiveInactiveCount() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    currentSpeed = preferences.getDouble('CurrentSpeed');
    activeCount = preferences.getInt('ActiveCount');
    inactiveCount = preferences.getInt('InactiveCount');
    m_Status = preferences.getString('m_Status');
    m_Time = preferences.getString('m_StartTime');

    setState(() {});
    if (!isTimerSet && m_Status == "1") {
      DateTime? getM_Time = DateTime.parse(m_Time.toString());
      var newDate = DateTime(
          getM_Time.year, getM_Time.month, getM_Time.day + 1, getM_Time.hour, getM_Time.minute, getM_Time.second);
      DateTime? nowTime = DateTime.now();
      Duration finalTime = newDate.difference(nowTime);

      Duration startTimerDuration = Duration(seconds: finalTime.inSeconds);

      log(startTimerDuration.toString());

      setDuration(startTimerDuration);
      startCounterTimer();
    }
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
      loading = false;
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
    String SendReminderUrl = Api.base_url + Api.sendReminder;
    log('Send Reminder Url::::::::::::::$SendReminderUrl');
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
                end: Alignment.topRight,
                colors: [AppColors.mainColor1, AppColors.mainColor])),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => IncreaseM_Screen()));
                          },
                          child: Stack(
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: height * 0.06, left: width * 0.05),
                                height: height * 0.045,
                                width: width * 0.21,
                                decoration: BoxDecoration(
                                    color: const Color(0xFF00E469).withOpacity(0.18),
                                    borderRadius: BorderRadius.circular(25)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    //SizedBox(width: width * 0.01,),
                                    Text(
                                      currentSpeed == null ? "0.0" : currentSpeed.toString(),
                                      style: TextStyle(
                                          color: Color(0xFF2C2C2C),
                                          fontFamily: 'Montserrat-Bold',
                                          fontWeight: FontWeight.bold,
                                          fontSize: height * 0.022),
                                    ),
                                    SizedBox(
                                      width: width * 0.02,
                                    ),
                                    Image.asset(
                                      'assets/images/CHECK.png',
                                      height: 24,
                                      width: 24,
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: width * 0.22, top: height * 0.05),
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
                        var data =
                            await Navigator.push(context, MaterialPageRoute(builder: (context) => const Profile()));
                        profileImageGet();
                      },
                      child: Stack(
                        children: [
                          Container(
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
                                      child: profileImage == null
                                          ? Image.asset(
                                              'assets/images/profileimage.jpg',
                                              fit: BoxFit.cover,
                                            )
                                          : Image.network(profileImage!.toString()))),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: height * 0.02),
                Container(
                  height: height * 0.9,
                  decoration: const BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30))),
                  child: Container(
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.03,
                            left: MediaQuery.of(context).size.width * 0.06,
                            right: MediaQuery.of(context).size.width * 0.06,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  InkWell(
                                      onTap: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Icon(
                                        Icons.arrow_back,
                                        color: AppColors.black,
                                      )),
                                  SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                                  Text(
                                    'view_team_screen_referal_team'.tr(),
                                    style: TextStyle(
                                        fontFamily: 'Montserrat-Bold',
                                        fontSize: height * 0.024,
                                        color: AppColors.black,
                                        fontWeight: FontWeight.w300),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    '',
                                    style: TextStyle(
                                      fontSize: height * 0.014,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.mainColor1,
                                      fontFamily: 'Montserrat',
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.02,
                            left: MediaQuery.of(context).size.width * 0.06,
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    height: 10,
                                    width: 10,
                                    decoration:
                                        BoxDecoration(borderRadius: BorderRadius.circular(100), color: AppColors.green),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.03,
                                  ),
                                  Text(
                                    'view_team_screen_active'.tr(),
                                    style: TextStyle(
                                      color: AppColors.black,
                                      fontWeight: FontWeight.w600,
                                      fontSize: height * 0.018,
                                      fontFamily: 'Montserrat',
                                    ),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.08,
                                  ),
                                  Container(
                                    height: MediaQuery.of(context).size.height * 0.025,
                                    width: MediaQuery.of(context).size.width * 0.12,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Color(0xFF7DD954).withOpacity(0.26)),
                                    child: Center(
                                      child: Text(
                                        activeCount == null ? "0" : activeCount.toString(),
                                        style: TextStyle(
                                          fontSize: height * 0.014,
                                          color: Color(0xFF7DD954),
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Montserrat-Bold',
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.height * 0.03,
                              ),
                              Row(
                                children: [
                                  Container(
                                    height: 10,
                                    width: 10,
                                    decoration:
                                        BoxDecoration(borderRadius: BorderRadius.circular(100), color: Colors.red),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.03,
                                  ),
                                  Text(
                                    'view_team_screen_inactive'.tr(),
                                    style: TextStyle(
                                      color: AppColors.black,
                                      fontWeight: FontWeight.w600,
                                      fontSize: height * 0.018,
                                      fontFamily: 'Montserrat',
                                    ),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.05,
                                  ),
                                  Container(
                                    height: MediaQuery.of(context).size.height * 0.025,
                                    width: MediaQuery.of(context).size.width * 0.12,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20), color: Colors.red.withOpacity(0.2)),
                                    child: Center(
                                      child: Text(
                                        inactiveCount == null ? "0" : inactiveCount.toString(),
                                        style: TextStyle(
                                          fontSize: height * 0.014,
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Montserrat',
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: height * 0.01),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              InkWell(
                                  onTap: () {
                                    setState(() {
                                      teamIndex = 0;
                                    });
                                  },
                                  child: teamIndex == 0
                                      ? Container(
                                          margin: const EdgeInsets.only(top: 10),
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                  child: Container(
                                                child: Text(
                                                  'view_team_screen_active'.tr(),
                                                  style: TextStyle(
                                                    fontSize: height * 0.02,
                                                    color: AppColors.mainColor1,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'Montserrat-Bold',
                                                  ),
                                                ),
                                              )),
                                              const SizedBox(height: 10),
                                              Container(
                                                height: 2,
                                                width: MediaQuery.of(context).size.width * 0.5,
                                                color: AppColors.mainColor1,
                                              ),
                                            ],
                                          ),
                                        )
                                      : Container(
                                          margin: const EdgeInsets.only(top: 10),
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                  child: Container(
                                                      child: Text(
                                                'view_team_screen_active'.tr(),
                                                style: TextStyle(
                                                  fontSize: height * 0.02,
                                                  color: AppColors.gray,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Montserrat-Bold',
                                                ),
                                              ))),
                                              const SizedBox(height: 10),
                                              Container(
                                                height: 2,
                                                width: MediaQuery.of(context).size.width * 0.5,
                                                color: AppColors.lightGray,
                                              ),
                                            ],
                                          ),
                                        )),
                              InkWell(
                                  onTap: () {
                                    setState(() {
                                      teamIndex = 1;
                                    });
                                  },
                                  child: teamIndex == 1
                                      ? Container(
                                          margin: const EdgeInsets.only(top: 10),
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                child: Container(
                                                    child: Text(
                                                  'view_team_screen_inactive'.tr(),
                                                  style: TextStyle(
                                                    fontSize: height * 0.02,
                                                    color: AppColors.mainColor1,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'Montserrat-Bold',
                                                  ),
                                                )),
                                              ),
                                              const SizedBox(height: 10),
                                              Container(
                                                height: 2,
                                                width: MediaQuery.of(context).size.width * 0.5,
                                                color: AppColors.mainColor1,
                                              ),
                                            ],
                                          ),
                                        )
                                      : Container(
                                          margin: const EdgeInsets.only(top: 10),
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                  child: Container(
                                                      child: Text(
                                                'view_team_screen_inactive'.tr(),
                                                style: TextStyle(
                                                  fontSize: height * 0.02,
                                                  color: AppColors.gray,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Montserrat-Bold',
                                                ),
                                              ))),
                                              const SizedBox(height: 10),
                                              Container(
                                                height: 2,
                                                width: MediaQuery.of(context).size.width * 0.5,
                                                color: AppColors.lightGray,
                                              ),
                                            ],
                                          ),
                                        )),
                            ],
                          ),
                        ),
                        Container(height: MediaQuery.of(context).size.height * 0.52, child: TeamTab[teamIndex]),
                        InkWell(
                          onTap: () {
                            _sendReminder();
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
                            height: MediaQuery.of(context).size.height * 0.055,
                            width: MediaQuery.of(context).size.width * 0.86,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomRight,
                                  colors: [Color(0xFFF3A800), Colors.yellow.shade600]),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                SizedBox(width: MediaQuery.of(context).size.width * 0.04),
                                SvgPicture.asset('assets/svg_images/reminder.svg'),
                                SizedBox(width: MediaQuery.of(context).size.width * 0.2),
                                Text('view_team_screen_send_reminder'.tr(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Montserrat-Bold',
                                      fontSize: height * 0.018,
                                    ))
                              ],
                            ),
                          ),
                        ),
                        Center(
                          child: Container(
                              margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01),
                              child: Text(
                                'view_team_screen_send_a_notification'.tr(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: height * 0.016,
                                ),
                              )),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
