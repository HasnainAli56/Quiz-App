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
    apiKey: 'AIzaSyCzKb7_bweZ_2aIodta9BvgAPdejxOECpQ',
    appId: '1:937428769954:web:3a8f95979718322db94bfb',
    messagingSenderId: '937428769954',
    projectId: 'quiz-app-9386a',
    authDomain: 'quiz-app-9386a.firebaseapp.com',
    storageBucket: 'quiz-app-9386a.firebasestorage.app',
    measurementId: 'G-XXXXXXXXXX',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCzKb7_bweZ_2aIodta9BvgAPdejxOECpQ',
    appId: '1:937428769954:android:3a8f95979718322db94bfb',
    messagingSenderId: '937428769954',
    projectId: 'quiz-app-9386a',
    storageBucket: 'quiz-app-9386a.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCzKb7_bweZ_2aIodta9BvgAPdejxOECpQ',
    appId: '1:937428769954:ios:3a8f95979718322db94bfb',
    messagingSenderId: '937428769954',
    projectId: 'quiz-app-9386a',
    storageBucket: 'quiz-app-9386a.firebasestorage.app',
    iosBundleId: 'com.example.quizApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCzKb7_bweZ_2aIodta9BvgAPdejxOECpQ',
    appId: '1:937428769954:macos:3a8f95979718322db94bfb',
    messagingSenderId: '937428769954',
    projectId: 'quiz-app-9386a',
    storageBucket: 'quiz-app-9386a.firebasestorage.app',
    iosBundleId: 'com.example.quizApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCzKb7_bweZ_2aIodta9BvgAPdejxOECpQ',
    appId: '1:937428769954:windows:3a8f95979718322db94bfb',
    messagingSenderId: '937428769954',
    projectId: 'quiz-app-9386a',
    storageBucket: 'quiz-app-9386a.firebasestorage.app',
  );
} 