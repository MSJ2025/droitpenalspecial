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
    apiKey: 'AIzaSyDtjZIiGF5LXUB1dhFbnKqlAoefsnCPuWE',
    appId: '1:1052086354495:web:974d574bdab816a24bee8a',
    messagingSenderId: '1052086354495',
    projectId: 'pjplus-debe2',
    authDomain: 'pjplus-debe2.firebaseapp.com',
    storageBucket: 'pjplus-debe2.firebasestorage.app',
    measurementId: 'G-45ES4617T0',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB6ddxosocfNe7qb0F4D_DjTBhFzLQdAsI',
    appId: '1:1052086354495:android:6611d3d4e8418bb54bee8a',
    messagingSenderId: '1052086354495',
    projectId: 'pjplus-debe2',
    storageBucket: 'pjplus-debe2.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAV_q3D81tmL4LGYmOUoVGftD3H88ZoXqs',
    appId: '1:1052086354495:ios:90847a4acf52ce474bee8a',
    messagingSenderId: '1052086354495',
    projectId: 'pjplus-debe2',
    storageBucket: 'pjplus-debe2.firebasestorage.app',
    iosBundleId: 'com.msj2025.pjplus',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAV_q3D81tmL4LGYmOUoVGftD3H88ZoXqs',
    appId: '1:1052086354495:ios:d73b68e45f19a2d74bee8a',
    messagingSenderId: '1052086354495',
    projectId: 'pjplus-debe2',
    storageBucket: 'pjplus-debe2.firebasestorage.app',
    iosBundleId: 'com.example.poljud',
  );
}
