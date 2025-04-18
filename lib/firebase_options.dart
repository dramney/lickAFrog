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
        return linux;
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
    apiKey: 'AIzaSyAguUC8w2wzVRfLL9tA7Nosk4fdHYMgF44',
    appId: '1:138180288103:web:480fe89e49e07769c8fec2',
    messagingSenderId: '138180288103',
    projectId: 'lickafrogapp',
    authDomain: 'lickafrogapp.firebaseapp.com',
    storageBucket: 'lickafrogapp.firebasestorage.app',
    measurementId: 'G-QGMHDHJEB5',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCq9LcFMP2cSGfQ_h1EFmC0wHUHFPtktKM',
    appId: '1:138180288103:android:7a5985546a1ad43ac8fec2',
    messagingSenderId: '138180288103',
    projectId: 'lickafrogapp',
    storageBucket: 'lickafrogapp.firebasestorage.app',
  );

  static const FirebaseOptions linux = FirebaseOptions(
    apiKey: 'AIzaSyCq9LcFMP2cSGfQ_h1EFmC0wHUHFPtktKM',
    appId: '1:138180288103:android:7a5985546a1ad43ac8fec2',
    messagingSenderId: '138180288103',
    projectId: 'lickafrogapp',
    storageBucket: 'lickafrogapp.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBMqt50TFOEPewne3DqZFeoMAprX_m_wTw',
    appId: '1:138180288103:ios:dd11b45ccfdc6b5cc8fec2',
    messagingSenderId: '138180288103',
    projectId: 'lickafrogapp',
    storageBucket: 'lickafrogapp.firebasestorage.app',
    iosBundleId: 'com.example.frog',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBMqt50TFOEPewne3DqZFeoMAprX_m_wTw',
    appId: '1:138180288103:ios:dd11b45ccfdc6b5cc8fec2',
    messagingSenderId: '138180288103',
    projectId: 'lickafrogapp',
    storageBucket: 'lickafrogapp.firebasestorage.app',
    iosBundleId: 'com.example.frog',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAguUC8w2wzVRfLL9tA7Nosk4fdHYMgF44',
    appId: '1:138180288103:web:dc107e4f20c2ebe7c8fec2',
    messagingSenderId: '138180288103',
    projectId: 'lickafrogapp',
    authDomain: 'lickafrogapp.firebaseapp.com',
    storageBucket: 'lickafrogapp.firebasestorage.app',
    measurementId: 'G-X325J3XDCT',
  );

}