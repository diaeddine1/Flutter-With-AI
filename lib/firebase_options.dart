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
    apiKey: 'AIzaSyDaYLRIhY2buoI6bwlmjbcvyOdFMqzsB6w',
    appId: '1:805683853271:web:b341d48e17162b1513bd92',
    messagingSenderId: '805683853271',
    projectId: 'flutterai-d8353',
    authDomain: 'flutterai-d8353.firebaseapp.com',
    storageBucket: 'flutterai-d8353.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBX4uiS0y5hiqd-qWnGJuBrTmLE7RH2FR0',
    appId: '1:805683853271:android:fc54f34c4360285813bd92',
    messagingSenderId: '805683853271',
    projectId: 'flutterai-d8353',
    storageBucket: 'flutterai-d8353.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCK4E7C_CYIdd4aUjuzP6C2pvs4XLVwkKo',
    appId: '1:805683853271:ios:f9b1a557574591ed13bd92',
    messagingSenderId: '805683853271',
    projectId: 'flutterai-d8353',
    storageBucket: 'flutterai-d8353.appspot.com',
    iosBundleId: 'com.example.flutterai',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCK4E7C_CYIdd4aUjuzP6C2pvs4XLVwkKo',
    appId: '1:805683853271:ios:3b9fba20825c998213bd92',
    messagingSenderId: '805683853271',
    projectId: 'flutterai-d8353',
    storageBucket: 'flutterai-d8353.appspot.com',
    iosBundleId: 'com.example.flutterai.RunnerTests',
  );
}
