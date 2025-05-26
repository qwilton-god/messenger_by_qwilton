
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: 'AIzaSyAf5rJcm4ShkPSzJCC_wlMK2LFG5gC9-pg',
    appId: '1:841210640881:web:f72a1783998c7fab342c50',
    messagingSenderId: '841210640881',
    projectId: 'chat-app-by-qwilton',
    authDomain: 'chat-app-by-qwilton.firebaseapp.com',
    storageBucket: 'chat-app-by-qwilton.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD7oKfz880XUY2oDEzFxxhFQv3gXoUQ92w',
    appId: '1:841210640881:android:b8a7058f3825fc0e342c50',
    messagingSenderId: '841210640881',
    projectId: 'chat-app-by-qwilton',
    storageBucket: 'chat-app-by-qwilton.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAeUA8sX2Jm5UOXWH51QBIhfkb2fF-uPU0',
    appId: '1:841210640881:ios:856a94b064d921b2342c50',
    messagingSenderId: '841210640881',
    projectId: 'chat-app-by-qwilton',
    storageBucket: 'chat-app-by-qwilton.firebasestorage.app',
    iosBundleId: 'com.example.messengerByQwilton',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAeUA8sX2Jm5UOXWH51QBIhfkb2fF-uPU0',
    appId: '1:841210640881:ios:856a94b064d921b2342c50',
    messagingSenderId: '841210640881',
    projectId: 'chat-app-by-qwilton',
    storageBucket: 'chat-app-by-qwilton.firebasestorage.app',
    iosBundleId: 'com.example.messengerByQwilton',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAf5rJcm4ShkPSzJCC_wlMK2LFG5gC9-pg',
    appId: '1:841210640881:web:55c38d4c902027d1342c50',
    messagingSenderId: '841210640881',
    projectId: 'chat-app-by-qwilton',
    authDomain: 'chat-app-by-qwilton.firebaseapp.com',
    storageBucket: 'chat-app-by-qwilton.firebasestorage.app',
  );
}
