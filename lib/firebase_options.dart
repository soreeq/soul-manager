// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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
    apiKey: 'AIzaSyD7eoRmqKBQtETcX3nqX37IdOzihK6HJ1E',
    appId: '1:471872641540:web:8f1f60d1058336932db351',
    messagingSenderId: '471872641540',
    projectId: 'soul-manager-e38c2',
    authDomain: 'soul-manager-e38c2.firebaseapp.com',
    storageBucket: 'soul-manager-e38c2.firebasestorage.app',
    measurementId: 'G-M2H0B04346',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAdzNMY5cGca3Pu2C65NbC3v0IwjOa0Rmo',
    appId: '1:471872641540:android:7f7c97932ff5a9b82db351',
    messagingSenderId: '471872641540',
    projectId: 'soul-manager-e38c2',
    storageBucket: 'soul-manager-e38c2.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAp1SUALDXe7_WsP9ubcA-T90LY3L0FnSg',
    appId: '1:471872641540:ios:fd870bb6a9fac88b2db351',
    messagingSenderId: '471872641540',
    projectId: 'soul-manager-e38c2',
    storageBucket: 'soul-manager-e38c2.firebasestorage.app',
    iosBundleId: 'com.example.soulManager',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAp1SUALDXe7_WsP9ubcA-T90LY3L0FnSg',
    appId: '1:471872641540:ios:fd870bb6a9fac88b2db351',
    messagingSenderId: '471872641540',
    projectId: 'soul-manager-e38c2',
    storageBucket: 'soul-manager-e38c2.firebasestorage.app',
    iosBundleId: 'com.example.soulManager',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyD7eoRmqKBQtETcX3nqX37IdOzihK6HJ1E',
    appId: '1:471872641540:web:8379e2546178866b2db351',
    messagingSenderId: '471872641540',
    projectId: 'soul-manager-e38c2',
    authDomain: 'soul-manager-e38c2.firebaseapp.com',
    storageBucket: 'soul-manager-e38c2.firebasestorage.app',
    measurementId: 'G-Q8NWFN7SQ5',
  );
}
