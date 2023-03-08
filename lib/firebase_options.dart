// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyA07AdANBgiWCqWGO65dC7MF2p4A2EfFPQ',
    appId: '1:174153813964:web:af4755169280fa7529d769',
    messagingSenderId: '174153813964',
    projectId: 'webrtc-e4bbd',
    authDomain: 'webrtc-e4bbd.firebaseapp.com',
    databaseURL: 'https://webrtc-e4bbd-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'webrtc-e4bbd.appspot.com',
    measurementId: 'G-36B37V7JWD',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAlE_2NrYpHISIqxnZ_W8H4-hwio-jLscU',
    appId: '1:174153813964:android:ff318f2ca20352a029d769',
    messagingSenderId: '174153813964',
    projectId: 'webrtc-e4bbd',
    databaseURL: 'https://webrtc-e4bbd-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'webrtc-e4bbd.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBNCdCFOtnz3xW0w-Fou7cUNBWhcyAJ9A0',
    appId: '1:174153813964:ios:e466476d00081a6a29d769',
    messagingSenderId: '174153813964',
    projectId: 'webrtc-e4bbd',
    databaseURL: 'https://webrtc-e4bbd-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'webrtc-e4bbd.appspot.com',
    androidClientId: '174153813964-6ip6ee9blkn1noq4407pbumj0uqt88hq.apps.googleusercontent.com',
    iosClientId: '174153813964-t08cnfpemmo0jc33arifigmjsriu3phm.apps.googleusercontent.com',
    iosBundleId: 'com.example.webrtcFlutter',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBNCdCFOtnz3xW0w-Fou7cUNBWhcyAJ9A0',
    appId: '1:174153813964:ios:e466476d00081a6a29d769',
    messagingSenderId: '174153813964',
    projectId: 'webrtc-e4bbd',
    databaseURL: 'https://webrtc-e4bbd-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'webrtc-e4bbd.appspot.com',
    androidClientId: '174153813964-6ip6ee9blkn1noq4407pbumj0uqt88hq.apps.googleusercontent.com',
    iosClientId: '174153813964-t08cnfpemmo0jc33arifigmjsriu3phm.apps.googleusercontent.com',
    iosBundleId: 'com.example.webrtcFlutter',
  );
}
