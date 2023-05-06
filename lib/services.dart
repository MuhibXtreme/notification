import 'dart:ffi';
import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:notification/secondscreen.dart';

class NotifcationHelper {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void requestNotificatinPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      if (kDebugMode) {
        print('user gived permission');
      }
    } else {
      if (kDebugMode) {
        print('user denied permission');
      }
    }
  }

  Future<String> gettokenid() async {
    String? token = await messaging.getToken();
    return token!;
  }

  void firebasemegs(BuildContext context) {
    FirebaseMessaging.onMessage.listen((message) {
      print(message.notification!.title);
      print(message.notification!.body);
      localnotify(context, message);
      showNotification(message);
    });
  }

  void localnotify(BuildContext context, RemoteMessage message) async {
    var androidsetting =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initialzationsetting = InitializationSettings(android: androidsetting);

    flutterLocalNotificationsPlugin.initialize(
      initialzationsetting,
      onDidReceiveNotificationResponse: (details) {
        handleMessage(context, message);
      },
    );
  }

  Future<void> showNotification(RemoteMessage message) async {
    AndroidNotificationChannel channel = AndroidNotificationChannel(
        Random.secure().nextInt(100000).toString(), 'High importance',
        importance: Importance.max);

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
            channel.id.toString(), channel.name.toString(),
            channelDescription: 'abc',
            importance: Importance.high,
            priority: Priority.high);

    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    await flutterLocalNotificationsPlugin.show(0, message.notification!.title,
        message.notification!.body, notificationDetails);
  }

  static Future<void> background(RemoteMessage message) async {
    await Firebase.initializeApp();
    print(
        'this is background notification ${message.notification!.title.toString()}');
  }

  void handleMessage(BuildContext context, RemoteMessage message) {
    if (message.data['name'] == 'second') {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const SecondScreen()));
    }
  }

  Future<void> terminatedandback(BuildContext context) async {
    // For terminated state
    RemoteMessage? initialmsg = await messaging.getInitialMessage();

    if (initialmsg != null) {
      handleMessage(context, initialmsg);
    }

    // for background
    FirebaseMessaging.onMessageOpenedApp.listen((msg) {
      handleMessage(context, msg);
    });
  }
}
