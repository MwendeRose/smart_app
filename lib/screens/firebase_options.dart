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
    apiKey:            'AIzaSyCDocYZOoFVZIQxq5YsuVBp4m92298wG58',
    authDomain:        'smartmeter-b1046.firebaseapp.com',
    projectId:         'smartmeter-b1046',
    storageBucket:     'smartmeter-b1046.firebasestorage.app',
    messagingSenderId: '1034077794363',
    appId:             '1:1034077794363:android:220f4a082081c347b92c1e',
  );
}