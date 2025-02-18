import 'dart:convert';
import 'dart:developer';
import 'package:coin_project/Screens/gamePage.dart';
import 'package:coin_project/widgets/Navbar_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../AppColors/appColors.dart';
import 'ChatScreen.dart';
import 'Dashboard.dart';
import 'ProjectStats.dart';
import 'm_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();
  @override
  void initState() {
    onMessageOpenedAppMethod(context);
    onMessage(context);
    // TODO: implement initState
    super.initState();
  }

  final _id = 1;
  NotificationDetails notificationDetails = NotificationDetails(
    android: AndroidNotificationDetails(
      "pushnotificationapp",
      "pushnotificationappchannel",
      importance: Importance.max,
      priority: Priority.high,
    ),
  );
  onMessage(BuildContext context) {
    FirebaseMessaging.onMessage.listen((message) async {
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      log("FirebaseMessaging.onMessage.listen");
      InitializationSettings initializationSettings =
          InitializationSettings(android: AndroidInitializationSettings("@mipmap/ic_launcher"));
      _notificationsPlugin.initialize(initializationSettings);
      String res = "{";
      for (String k in message.data.keys) {
        res += '"';
        res += k;
        res += '":"';
        res += message.data[k].toString();
        res += '",';
      }
      res = res.substring(0, res.length - 1);
      res += "},";
      res = res.substring(0, res.length - 1);
      var title;
      var body;
      var enLang = sharedPreferences.getString('en');
      var viLang = sharedPreferences.getString("vi");
      var zhLang = sharedPreferences.getString("zh");
      var filLang = sharedPreferences.getString("fil");
      var idLang = sharedPreferences.getString("id");
      var koLang = sharedPreferences.getString("ko");
      if (message.data.containsKey('title')) {
        title = message.data['title'].toString();
        body = message.data['body'].toString();
      } else if (zhLang == "zh") {
        title = message.data['zh_title'].toString();
        body = message.data['zh_body'].toString();
        sharedPreferences.remove('en');
        sharedPreferences.remove('id');
        sharedPreferences.remove('ko');
        sharedPreferences.remove('fil');
        sharedPreferences.remove('vi');
      } else if (filLang == "fil") {
        title = message.data['fil_title'].toString();
        body = message.data['fil_body'].toString();
        sharedPreferences.remove('en');
        sharedPreferences.remove('id');
        sharedPreferences.remove('ko');
        sharedPreferences.remove('zh');
        sharedPreferences.remove('vi');
      } else if (idLang == "id") {
        title = message.data['id_title'].toString();
        body = message.data['id_body'].toString();
        sharedPreferences.remove('en');
        sharedPreferences.remove('fil');
        sharedPreferences.remove('ko');
        sharedPreferences.remove('zh');
        sharedPreferences.remove('vi');
      } else if (koLang == "ko") {
        title = message.data['ko_title'].toString();
        body = message.data['ko_body'].toString();
        log("::::::::::::::::::::::::::::::::");
        log("$title");
        log("$body");
        log("::::::::::::::::::::::::::::::::");
        sharedPreferences.remove('en');
        sharedPreferences.remove('fil');
        sharedPreferences.remove('id');
        sharedPreferences.remove('zh');
        sharedPreferences.remove('vi');
      } else if (viLang == "vi") {
        sharedPreferences.remove('en');
        sharedPreferences.remove('fil');
        sharedPreferences.remove('id');
        sharedPreferences.remove('zh');
        sharedPreferences.remove('ko');
        title = message.data['vi_title'].toString();
        body = message.data['vi_body'].toString();
      } else if (enLang == "en") {
        sharedPreferences.remove('ko');
        sharedPreferences.remove('fil');
        sharedPreferences.remove('id');
        sharedPreferences.remove('zh');
        sharedPreferences.remove('vi');
        title = message.data['en_title'].toString();
        body = message.data['en_body'].toString();
      }
      if (title != "null" && body != "null") {
        await _notificationsPlugin.show(_id, title, body, notificationDetails, payload: res);
      }
    });
  }

  onMessageOpenedAppMethod(BuildContext context) {
    FirebaseMessaging.onMessageOpenedApp.listen((message) async {
      // InitializationSettings initializationSettings = InitializationSettings(android: AndroidInitializationSettings("@mipmap/ic_launcher"));
      // _notificationsPlugin.initialize(initializationSettings,onDidReceiveNotificationResponse: (details) {});
      // String res = "{";
      // for (String k in message.data.keys) {
      //   res += '"';
      //   res += k;
      //   res += '":"';
      //   res += message.data[k].toString();
      //   res += '",';
      // }
      // res = res.substring(0, res.length - 1);
      // res += "},";
      // res = res.substring(0, res.length - 1);
      // await _notificationsPlugin.show(
      //     _id,
      //     message.data['en_title'].toString(),
      //     message.data['en_body'].toString(),
      //     notificationDetails,
      //     payload: res);
      // if (message.data['master_id'] == "1") {
      //   Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(),));
      //   log("SuccessFully");
      //   log(message.notification!.title);
      //   log(message.notification!.body.toString());
      //   log("if part is ::::::::::::: ${message.data['master_id'].toString()}");
      // }else if(message.data['mining_id'] == "2"){
      //   log("else if part is ::::::::::::: ${message.data['master_id'].toString()}");
      //   Navigator.push(context, MaterialPageRoute(builder: (context) => M_Screen()));
      // }else{
      //   log("else::::::::::::: ${message.data['master_id'].toString()}");
      //   Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
      // }
    });
  }

  int pageIndex = 0;
  List pages = [Dashboard(), M_Screen(), GamePage(), ChatScreen(), ProjectStats()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: pages[pageIndex],
      bottomNavigationBar: NavBar(context),
    );
  }

  Container NavBar(BuildContext context) {
    return Container(
      height: 70,
      decoration: const BoxDecoration(color: AppColors.white),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          InkWell(
              onTap: () {
                setState(() {
                  pageIndex = 0;
                });
              },
              child: pageIndex == 0
                  ? NavBar_Widget(
                      text: 'home'.tr(),
                      color: AppColors.black,
                      assetName: 'assets/svg_images/Home.svg',
                      imagecolor: AppColors.black,
                    )
                  : NavBar_Widget(
                      text: 'home'.tr(),
                      color: AppColors.gray,
                      assetName: 'assets/svg_images/Home.svg',
                      imagecolor: AppColors.gray,
                    )),
          InkWell(
              onTap: () {
                setState(() {
                  pageIndex = 1;
                });
              },
              child: pageIndex == 1
                  ? NavBar_Widget(
                      text: 'mining'.tr(),
                      color: AppColors.black,
                      assetName: 'assets/svg_images/M_start.svg',
                      imagecolor: AppColors.black,
                    )
                  : NavBar_Widget(
                      text: 'mining'.tr(),
                      color: AppColors.gray,
                      assetName: 'assets/svg_images/M_start.svg',
                      imagecolor: AppColors.gray,
                    )),
          InkWell(
              onTap: () {
                setState(() {
                  pageIndex = 2;
                });
              },
              child: pageIndex == 2
                  ? NavBar_Widget(
                      text: 'P2E'.tr(),
                      color: AppColors.black,
                      assetName: 'assets/svg_images/chat.svg',
                      imagecolor: AppColors.black,
                    )
                  : NavBar_Widget(
                      text: 'P2E'.tr(),
                      color: AppColors.gray,
                      assetName: 'assets/svg_images/chat.svg',
                      imagecolor: AppColors.gray,
                    )),
          InkWell(
              onTap: () {
                setState(() {
                  pageIndex = 3;
                });
              },
              child: pageIndex == 3
                  ? NavBar_Widget(
                      text: 'chat'.tr(),
                      color: AppColors.black,
                      assetName: 'assets/svg_images/p2e.svg',
                      imagecolor: AppColors.black,
                    )
                  : NavBar_Widget(
                      text: 'chat'.tr(),
                      color: AppColors.gray,
                      assetName: 'assets/svg_images/p2e.svg',
                      imagecolor: AppColors.gray,
                    )),
          InkWell(
              onTap: () {
                setState(() {
                  pageIndex = 4;
                });
              },
              child: pageIndex == 4
                  ? NavBar_Widget(
                      text: 'project'.tr(),
                      color: AppColors.black,
                      assetName: 'assets/svg_images/project.svg',
                      imagecolor: AppColors.black,
                    )
                  : NavBar_Widget(
                      text: 'project'.tr(),
                      color: AppColors.gray,
                      assetName: 'assets/svg_images/project.svg',
                      imagecolor: AppColors.gray,
                    )),
        ],
      ),
    );
  }
}
