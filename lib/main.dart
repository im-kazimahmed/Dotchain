import 'dart:async';
import 'dart:developer';
import 'package:applovin_max/applovin_max.dart';
import 'package:clever_ads_solutions/CAS.dart';
import 'package:coin_project/Screens/splash_page.dart';
import 'package:coin_project/services/cas_ad_service.dart';
import 'package:coin_project/widgets/Locales.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

@pragma('vm:entry-point')
Future<void> onBackgroundMessageHedler(RemoteMessage remoteMessage) async {
  FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();
  InitializationSettings initializationSettings =
      InitializationSettings(android: AndroidInitializationSettings("@mipmap/ic_launcher"));
  _notificationsPlugin.initialize(initializationSettings);
  final _id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
  NotificationDetails notificationDetails = NotificationDetails(
    android: AndroidNotificationDetails(
      "pushnotificationapp",
      "pushnotificationappchannel",
      importance: Importance.max,
      priority: Priority.high,
    ),
  );
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  var zhLang = sharedPreferences.getString("zh");
  var filLang = sharedPreferences.getString("fil");
  var idLang = sharedPreferences.getString("id");
  var koLang = sharedPreferences.getString("ko");
  var ViValue = sharedPreferences.getString('vi');
  var enValue = sharedPreferences.getString('en');
  log(":::::::::::::::::::::::::::::::::::::::::::::::::::");
  log("main.dart");
  log("zh lang $zhLang");
  log("fil lang $filLang");
  log("id lang $idLang");
  log("ko lang $koLang");
  log("vi lang $ViValue");
  log("en lang $enValue");
  log(remoteMessage.data.toString());
  log("main.dart");
  log(":::::::::::::::::::::::::::::::::::::::::::::::::::");
  var title;
  var body;
  if (remoteMessage.data.containsKey('title')) {
    title = remoteMessage.data['title'].toString();
    body = remoteMessage.data['body'].toString();
  } else if (zhLang == "zh") {
    sharedPreferences.remove('en');
    sharedPreferences.remove('fil');
    sharedPreferences.remove('id');
    sharedPreferences.remove('ko');
    sharedPreferences.remove('vi');
    title = remoteMessage.data['zh_title'].toString();
    body = remoteMessage.data['zh_body'].toString();
    log(":::::::::::::::::::::::::::::::::::::::::::::::::::");
    log("my lang is $zhLang");
    log("if part title is $title");
    log("if part title is $body");
    log("vi lang null issue");
    log(":::::::::::::::::::::::::::::::::::::::::::::::::::");
  } else if (filLang == "fil") {
    sharedPreferences.remove('vi');
    sharedPreferences.remove('en');
    sharedPreferences.remove('zh');
    sharedPreferences.remove('id');
    sharedPreferences.remove('ko');
    log(":::::::::::::::::::::::::::::::::::::::::::::::::::");
    log("my lang is $filLang");
    log("if part title is $title");
    log("if part title is $body");
    log("vi lang null issue");
    log(":::::::::::::::::::::::::::::::::::::::::::::::::::");
    title = remoteMessage.data['fil_title'].toString();
    body = remoteMessage.data['fil_body'].toString();
  } else if (idLang == "id") {
    sharedPreferences.remove('vi');
    sharedPreferences.remove('en');
    sharedPreferences.remove('zh');
    sharedPreferences.remove('fil');
    sharedPreferences.remove('ko');
    title = remoteMessage.data['id_title'].toString();
    body = remoteMessage.data['id_body'].toString();
  } else if (koLang == "ko") {
    sharedPreferences.remove('vi');
    sharedPreferences.remove('en');
    sharedPreferences.remove('zh');
    sharedPreferences.remove('fil');
    sharedPreferences.remove('id');
    title = remoteMessage.data['ko_title'].toString();
    body = remoteMessage.data['ko_body'].toString();
  } else if (ViValue == "vi") {
    sharedPreferences.remove('ko');
    sharedPreferences.remove('en');
    sharedPreferences.remove('zh');
    sharedPreferences.remove('fil');
    sharedPreferences.remove('id');
    title = remoteMessage.data['vi_title'].toString();
    body = remoteMessage.data['vi_body'].toString();
  } else if (enValue == "en") {
    sharedPreferences.remove('vi');
    sharedPreferences.remove('ko');
    sharedPreferences.remove('id');
    sharedPreferences.remove('zh');
    sharedPreferences.remove('fil');
    title = remoteMessage.data['en_title'].toString();
    body = remoteMessage.data['en_body'].toString();
  }
  String res = "{";
  for (String k in remoteMessage.data.keys) {
    res += '"';
    res += k;
    res += '":"';
    res += remoteMessage.data[k].toString();
    res += '",';
  }
  res = res.substring(0, res.length - 1);
  res += "},";
  res = res.substring(0, res.length - 1);

  await _notificationsPlugin.show(_id, title, body, notificationDetails, payload: res);
}

void main() async {
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await EasyLocalization.ensureInitialized();
    await Firebase.initializeApp();
    await SharedPreferences.getInstance();
    FirebaseMessaging.instance.getInitialMessage().then((massage) {
      log(":::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::");
      // if (massage?.data['master_id'] == "1") {
      //   log("if part of data ${massage?.data['master_id'].toString()}");
      // } else if (massage?.data['mining_id'] == "2") {
      //   log("else if part of data ${massage?.data['mining_id'].toString()}");
      // } else {
      //   log("else part of data");
      // }
    });
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    FirebaseMessaging.onBackgroundMessage(onBackgroundMessageHedler);
    AppLovinMAX.initialize("Vp_RT54WgT0HPO9BE7ZJXSzHd9c2pqEKcNXKR84t5vMXzTnmJqNeLXINSQ7FN5heJO0ystPWtMP_8SDC-bgiIM");
    AppLovinMAX.setVerboseLogging(false);
    AppLovinMAX.setHasUserConsent(false);
    // AppLovinMAX.setIsAgeRestrictedUser(false);
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    var zhLang = sharedPreferences.getString("zh");
    var filLang = sharedPreferences.getString("fil");
    var idLang = sharedPreferences.getString("id");
    var koLang = sharedPreferences.getString("ko");
    var ViValue = sharedPreferences.getString('vi');
    var enValue = sharedPreferences.getString('en');
    var codeLang;
    if (zhLang != null) {
      codeLang = Locale.fromSubtags(languageCode: 'zh');
    } else if (filLang != null) {
      codeLang = Locale.fromSubtags(languageCode: 'fil');
    } else if (idLang != null) {
      codeLang = Locale.fromSubtags(languageCode: 'id');
    } else if (koLang != null) {
      codeLang = Locale.fromSubtags(languageCode: 'ko');
    } else if (ViValue != null) {
      codeLang = Locale.fromSubtags(languageCode: 'vi');
    } else if (enValue != null) {
      codeLang = Locale.fromSubtags(languageCode: 'en');
    } else {
      codeLang = Locale.fromSubtags(languageCode: 'en');
    }
    CleverAdsSolutionsService().initialize();
    CAS.setDebugMode(true);
    CAS.validateIntegration();
    runApp(
      EasyLocalization(
          supportedLocales: supported_locale, path: 'assets/translations', startLocale: codeLang, child: MyApp()),
    );
    log(":::::::::::::::::::::::::::::::::::::::::::::::::::::");
    log("land code is $codeLang");
    log(":::::::::::::::::::::::::::::::::::::::::::::::::::::");
    sharedPreferences.setString('en', codeLang.toString());
  }, (error, stack) => FirebaseCrashlytics.instance.recordError(error, stack, fatal: true));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
