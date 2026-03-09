import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Background Message received: ${message.messageId} ${message.data}");

  // Add additional debug prints if needed
  print("Additional details: ${message.notification}");
  print("Additional data: ${message.data}");
  print(
      "A Background Message was received: ${message.messageId} ${message.data} ");
}

class NotificationService {
  // static AwesomeNotifications awesomeNotifications;

  static Future<void> initialize() async {
    // awesomeNotifications = AwesomeNotifications();

    // await awesomeNotifications.initialize('resource://drawable/logo', [
    //   NotificationChannel(
    //       channelKey: 'Kanban',
    //       channelName: 'Kanban',
    //       playSound: true,
    //       enableVibration: true,
    //       defaultRingtoneType: DefaultRingtoneType.Alarm,
    //       channelDescription: 'This channel is used for show notification',
    //       defaultColor: Colors.blueAccent,
    //       importance: NotificationImportance.High,
    //       defaultPrivacy: NotificationPrivacy.Public,
    //       channelShowBadge: true)
    // ]).then(print);
    // await awesomeNotifications.requestPermissionToSendNotifications();
    // await FirebaseMessaging.instance.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );
    print("object1");
    await FirebaseMessaging.instance
        .requestPermission(alert: true, sound: true);
    // Firebase
    FirebaseMessaging.onMessage.listen((event) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${event.data}');
      print("event.notification?.title??''");
      print(event.notification?.title??'');

      print('Notification Fired');
      print(event.data);
      // showNotification(
      //   event.hashCode,
      //   event.data['title'],
      //   event.data['message'],
      // );
    });
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    getFCMID();

    // getAPNS();
  }

  static Future<void> getFCMID() async {
    await FirebaseMessaging.instance.getToken().then((value) {
      print("Your FCM Token:  $value");
    });
  }

  static Future<void> getAPNS() async {
    await FirebaseMessaging.instance.getAPNSToken().then((value) {
      print("Your APNS Token:  $value");
    });
  }

  static Future<void> showNotification(
      int id, String title, String body) async {
    print("Showing Notification - id: $id, title: $title, body: $body");
    // awesomeNotifications.createNotification(
    //   content: NotificationContent(
    //     id: id,
    //     channelKey: 'Kanban',
    //     title: title,
    //     body: body,
    //     displayOnForeground: true,
    //     locked: false,
    //     notificationLayout: NotificationLayout.BigText,
    //     wakeUpScreen: true,
    //   ),
    // );
  }
}
