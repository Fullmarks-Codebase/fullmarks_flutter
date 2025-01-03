import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../main.dart';

class FirebaseMessagingService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  FirebaseMessagingService() {
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(
            sound: true, badge: true, alert: true, provisional: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }

  void getMessage() {
    _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
      print('on message $message');
      _showNotification(
        message['notification']['title'],
        message['notification']['body'],
        Platform.isIOS
            ? message['data'].toString()
            : message['data']['data'].toString(),
      );
    }, onResume: (Map<String, dynamic> message) async {
      print('on resume $message');
      _showNotification(
        message['notification']['title'],
        message['notification']['body'],
        Platform.isIOS
            ? message['data'].toString()
            : message['data']['data'].toString(),
      );
    }, onLaunch: (Map<String, dynamic> message) async {
      print('on launch $message');
      _showNotification(
        message['notification']['title'],
        message['notification']['body'],
        Platform.isIOS
            ? message['data'].toString()
            : message['data']['data'].toString(),
      );
    });
  }

  Future<void> _showNotification(String title, String body, String data) async {
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: AndroidNotificationDetails(
        'fullmarks_app_channel_id',
        'fullmarks_app_channel_name',
        'fullmarks_app_channel_description',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
        playSound: true,
      ),
      iOS: IOSNotificationDetails(
        presentSound: true,
        presentAlert: true,
      ),
    );
    await flutterLocalNotificationsPlugin
        .show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: data == null || data == "null" || data.trim().length == 0
          ? ""
          : data, //send payload here
    )
        .then((value) {
      print("SUCCESS");
    }).catchError((onError) {
      print("ERROR");
      print(onError);
    });
  }
}
