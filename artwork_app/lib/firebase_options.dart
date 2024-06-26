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
    apiKey: 'AIzaSyDWCsSn8m-FV9WY2VynF_KfsgVOWJlInH4',
    appId: '1:574139841799:web:e0f4c4965f1c825b4cd9a2',
    messagingSenderId: '574139841799',
    projectId: 'artwork-app-a4879',
    authDomain: 'artwork-app-a4879.firebaseapp.com',
    storageBucket: 'artwork-app-a4879.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDq7Lb2m6uczzu8Goxz7GnDlF8kB3-2zA0',
    appId: '1:574139841799:android:4f58ca8e11a7cf104cd9a2',
    messagingSenderId: '574139841799',
    projectId: 'artwork-app-a4879',
    storageBucket: 'artwork-app-a4879.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAxnt4WALh4ik-rTW2gb284UOJ7_UrfzME',
    appId: '1:574139841799:ios:611fdca791c1729f4cd9a2',
    messagingSenderId: '574139841799',
    projectId: 'artwork-app-a4879',
    storageBucket: 'artwork-app-a4879.appspot.com',
    iosBundleId: 'com.example.artworkApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAxnt4WALh4ik-rTW2gb284UOJ7_UrfzME',
    appId: '1:574139841799:ios:4210a51892b9b62a4cd9a2',
    messagingSenderId: '574139841799',
    projectId: 'artwork-app-a4879',
    storageBucket: 'artwork-app-a4879.appspot.com',
    iosBundleId: 'com.example.artworkApp.RunnerTests',
  );
}
