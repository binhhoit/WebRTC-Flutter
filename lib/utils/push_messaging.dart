import 'dart:io';
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:webrtc_flutter/firebase_options.dart';
import 'package:webrtc_flutter/utils/notification_utils.dart';

class PushNotificationsManager {

  PushNotificationsManager._();

  factory PushNotificationsManager() => _instance;

  static final PushNotificationsManager _instance =
  PushNotificationsManager._();

  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  static bool _initialized = false;

  static Future<void> init() async {
    if (!_initialized) {
      await _firebaseMessaging.setAutoInitEnabled(true);

      await _firebaseMessaging.setForegroundNotificationPresentationOptions(
        alert: true, // Required to display a heads up notification
        badge: true,
        sound: true,
      );

      // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);


      // Request permission notification
      if(Platform.isIOS) {
        await _firebaseMessaging.requestPermission(alert: true,
          announcement: false,
          badge: true,
          carPlay: false,
          criticalAlert: false,
          provisional: false,
          sound: true,
        );
      }

      FirebaseMessaging.onMessage.listen((RemoteMessage event) {
        Fluttertoast.showToast(
            msg: 'Foreground data received',
            backgroundColor: Colors.blueAccent,
            textColor: Colors.white,
            fontSize: 16);
        displayNotification(event);
      });

      // For testing purposes print the Firebase Messaging token
      String? token = await _firebaseMessaging.getToken();
      print("FirebaseMessaging token: $token");
      _initialized = true;
    }
  }

  static Future displayNotification(RemoteMessage message) async {
    if(message.data['type'] == 'incoming_call') {
      NotificationUtils.showCallkitIncoming(message);
    }
  }
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.

  print('Handling a background message ${message.messageId}');

  // WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await PushNotificationsManager.init();

  // Fluttertoast.showToast(
  //     msg: 'Silent data received',
  //     backgroundColor: Colors.blueAccent,
  //     textColor: Colors.white,
  //     fontSize: 16);

  PushNotificationsManager.displayNotification(message);

}