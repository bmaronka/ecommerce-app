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
    apiKey: 'AIzaSyCMO95Gafc5Rd5lnfol3d6IoGLR3ij8WCY',
    appId: '1:459166818558:web:d763c0077b7cb143c505af',
    messagingSenderId: '459166818558',
    projectId: 'ecommerce-app-a8e8b',
    authDomain: 'ecommerce-app-a8e8b.firebaseapp.com',
    storageBucket: 'ecommerce-app-a8e8b.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDVWwhzkVSEmrXf-cMrbXYIYNwi9uDd-hs',
    appId: '1:459166818558:android:5c62546b65984a2fc505af',
    messagingSenderId: '459166818558',
    projectId: 'ecommerce-app-a8e8b',
    storageBucket: 'ecommerce-app-a8e8b.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAJ4HQshPsj0k7oIVZSHy7gwH4PEQWfbio',
    appId: '1:459166818558:ios:1641026b6435a475c505af',
    messagingSenderId: '459166818558',
    projectId: 'ecommerce-app-a8e8b',
    storageBucket: 'ecommerce-app-a8e8b.appspot.com',
    iosBundleId: 'com.example.ecommerceAppDev',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAJ4HQshPsj0k7oIVZSHy7gwH4PEQWfbio',
    appId: '1:459166818558:ios:dfbc4f3fde8dc218c505af',
    messagingSenderId: '459166818558',
    projectId: 'ecommerce-app-a8e8b',
    storageBucket: 'ecommerce-app-a8e8b.appspot.com',
    iosBundleId: 'com.example.ecommerceApp',
  );
}
