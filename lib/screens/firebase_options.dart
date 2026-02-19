// File generated based on your Firebase project configuration.
// lib/firebase_options.dart

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for iOS.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  // ── Web ───────────────────────────────────────────────────
  static const FirebaseOptions web = FirebaseOptions(
    apiKey:            'AIzaSyB2Ox4JSThOHjUhM-HJh6tWZO9ylmFGSN8',
    authDomain:        'smartmeter-b1046.firebaseapp.com',
    projectId:         'smartmeter-b1046',
    storageBucket:     'smartmeter-b1046.firebasestorage.app',
    messagingSenderId: '1034077794363',
    appId:             '1:1034077794363:web:c6435384e6506a2fb92c1e',
    measurementId:     'G-7K81VQ87K3',
  );

  // ── Android ───────────────────────────────────────────────
  static const FirebaseOptions android = FirebaseOptions(
    apiKey:            'AIzaSyAjzorA3W_eNqvRBsR1vAz-Mc7_w3O1T8Y',
    authDomain:        'smartmeter-b1046.firebaseapp.com',
    projectId:         'maji-smart-37cef',
    storageBucket:     'maji-smart-37cef.firebasestorage.app',
    messagingSenderId: '451817579618',
    appId:             '1:451817579618:android:05895634c7eaaf881a1d3b',
  );
}