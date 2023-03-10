// import 'dart:io';
//
// import 'package:awesome_notifications/android_foreground_service.dart';
// import 'package:awesome_notifications/awesome_notifications.dart';
// import 'package:device_info_plus/device_info_plus.dart';
// import 'package:flutter/material.dart';
//
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_callkit_incoming/entities/android_params.dart';
import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';
import 'package:flutter_callkit_incoming/entities/ios_params.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';

class NotificationUtils {
  static Future<void> showCallkitIncoming(RemoteMessage message) async {
    final params = CallKitParams(
      id: '${message.data['nameCaller']}',
      nameCaller: '${message.data['nameCaller']}',
      appName: 'STS WebRTC',
      avatar: '${message.data['avatar']}',
      handle: 'Incoming Call',
      duration: 30000,
      textAccept: 'Accept',
      textDecline: 'Decline',
      extra: message.data,
      android: const AndroidParams(
        actionColor: '#FF5722',
        isCustomNotification: true,
        incomingCallNotificationChannelName: "incoming_call",
        isShowLogo: true,
        isShowCallback: false,
        isShowMissedCallNotification: false,
      ),
      ios: IOSParams(
        iconName: 'CallKitLogo',
        handleType: '',
        supportsVideo: true,
        maximumCallGroups: 2,
        maximumCallsPerCallGroup: 1,
        audioSessionMode: 'default',
        audioSessionActive: true,
        audioSessionPreferredSampleRate: 44100.0,
        audioSessionPreferredIOBufferDuration: 0.005,
        supportsDTMF: true,
        supportsHolding: true,
        supportsGrouping: false,
        supportsUngrouping: false,
        ringtonePath: 'system_ringtone_default',
      ),
    );
    await FlutterCallkitIncoming.showCallkitIncoming(params);
  }
}
