import 'dart:convert';
import 'package:coin_project/Models/NotificationData.dart';
import 'package:coin_project/Screens/ChatScreen.dart';
import 'package:coin_project/Screens/HomePage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'Screens/m_screen.dart';

// class GetData {
//   onMessageOpenedAppMethod(BuildContext context){
//     FirebaseMessaging.onMessageOpenedApp.listen((message) {
//       if (message.notification != null) {
//         Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(),));
//         log("SuccessFully");
//         log(message.notification!.title);
//         log(message.notification!.body);
//       }else if(message.notification?.title == "This is title"){
//         log("if else part");
//         Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen()));
//        }
//     });
//   }
//   onMessage(BuildContext context){
//     FirebaseMessaging.onMessage.listen((message){
//       log("FirebaseMessaging.onMessage.listen");
//       if (message.notification != null) {
//         log("if part of data");
//         log(message.notification!.title);
//         log(message.notification!.body);
//         LocalService.createanddisplaynotification(message);
//         } else{
//         log("else part of data");
//       }
//      }
//      );
//    }
//   }
//
// class LocalService {
//    static final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();
//    static void initialize(BuildContext context) {
//     const InitializationSettings initializationSettings = InitializationSettings(android: AndroidInitializationSettings("@mipmap/ic_launcher"),);
//     _notificationsPlugin.initialize(initializationSettings,
//         onDidReceiveNotificationResponse: ((details) {
//           Map<String,dynamic> data = json.decode(details.payload!);
//            NotificationData   notificationData = NotificationData.fromJson(data);
//            if(notificationData.masterId == "1"){
//              Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(),));
//            }else if(notificationData.miningId == "2"){
//              Navigator.push(context, MaterialPageRoute(builder: (context) => M_Screen(),));
//            }
//            else{
//              Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
//            }
//           }));
//   }
//   static void createanddisplaynotification(RemoteMessage message) async {
//     try {
//       log("try part");
//       final _id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
//       const NotificationDetails notificationDetails = NotificationDetails(
//         android: AndroidNotificationDetails(
//           "pushnotificationapp",
//           "pushnotificationappchannel",
//           importance: Importance.max,
//           priority: Priority.high,
//         ),
//       );
//       // String title="";
//       // String message="";
//       String res = "{";
//
//       for (String k in message.data.keys) {
//         res += '"';
//         res += k;
//         res += '":"';
//         res += message.data[k].toString();
//         res += '",';
//       }
//       res = res.substring(0, res.length - 1);
//
//       res += "},";
//       res = res.substring(0, res.length - 1);
//      var title = message.notification?.title;
//      var body = message.notification?.body;
//       await _notificationsPlugin.show(
//           _id,
//           title,
//           body,
//           notificationDetails,
//           payload: res
//       );
//     } on Exception catch (e) {
//       log("catch part");
//       log(e);
//     }
//   }
//   static Future<void> BackGroundMessage(RemoteMessage remoteMessage)async{
//     InitializationSettings initializationSettings = InitializationSettings(android: AndroidInitializationSettings("@mipmap/ic_launcher"));
//     NotificationDetails notificationDetails = NotificationDetails(
//       android: AndroidNotificationDetails(
//         "pushnotificationapp",
//         "pushnotificationappchannel",
//         importance: Importance.max,
//         priority: Priority.high,
//       ),
//     );
//     final _id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
//      FirebaseMessaging.onBackgroundMessage((message)async{
//        _notificationsPlugin.initialize(initializationSettings,onDidReceiveNotificationResponse: ((details) {}));
//        String res = "{";
//        for (String k in message.data.keys) {
//          res += '"';
//          res += k;
//          res += '":"';
//          res += message.data[k].toString();
//          res += '",';
//        }
//        res = res.substring(0, res.length - 1);
//        res += "},";
//        res = res.substring(0, res.length - 1);
//        var Title = message.data['en_title'].toString();
//        var Body = message.data['en_body'].toString();
//        await _notificationsPlugin.show(
//            _id,
//            Title,
//            Body,
//            notificationDetails,
//            payload: res);
//        log(":::::::::::::::::::::::::::::::::::");
//        log(Title);
//        log(Body);
//        log(":::::::::::::::::::::::::::::::::::");
//      });
//   }
//   static Future<void> backgroundHandler(RemoteMessage remoteMessage)async{
//      NotificationDetails notificationDetails = NotificationDetails(
//       android: AndroidNotificationDetails(
//         "pushnotificationapp",
//         "pushnotificationappchannel",
//         importance: Importance.max,
//         priority: Priority.high,
//       ),
//     );
//     log("::::::::::::::::::::::::::::::::::::::::::::::::::::");
//     log(remoteMessage.data);
//     log("::::::::::::::::::::::::::::::::::::::::::::::::::::");
//     final _id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
//     String res = "{";
//     for (String k in remoteMessage.data.keys) {
//       res += '"';
//       res += k;
//       res += '":"';
//       res += remoteMessage.data[k].toString();
//       res += '",';
//     }
//     res = res.substring(0, res.length - 1);
//     res += "},";
//     res = res.substring(0, res.length - 1);
//     await _notificationsPlugin.show(
//         _id,
//         remoteMessage.data['en_title'].toString(),
//         remoteMessage.data['en_body'].toString(),
//         notificationDetails,
//         payload: res);
//    }
//
//
// }