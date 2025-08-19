import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

/// Default Firebase configuration options for your app
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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

  // Web configuration
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBJNKCAeWTN-h7hJq9ohuGzkEudPiP3CkA',
    appId: '1:251853629051:web:placeholder', // Placeholder for web as it's not in the json
    messagingSenderId: '251853629051',
    projectId: 'zed-app-444bf',
    authDomain: 'zed-app-444bf.firebaseapp.com',
    storageBucket: 'zed-app-444bf.firebasestorage.app',
  );

  // Android configuration for com.rbs.zednano.dev
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBJNKCAeWTN-h7hJq9ohuGzkEudPiP3CkA',
    appId: '1:251853629051:android:87de3f71fae1f865a364de',
    messagingSenderId: '251853629051',
    projectId: 'zed-app-444bf',
    storageBucket: 'zed-app-444bf.firebasestorage.app',
  );

  // iOS configuration
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBazqOQ5wyJoay32KgvOBE6VSLPJu-5Jw8',
    appId: '1:251853629051:ios:66e03d5c9b91ae42a364de',
    messagingSenderId: '251853629051',
    projectId: 'zed-app-444bf',
    storageBucket: 'zed-app-444bf.firebasestorage.app',
    iosClientId: '251853629051-5e6vtsbtsfcl6dddoi0iskkdcfuohjm4.apps.googleusercontent.com',
    iosBundleId: 'com.rbs.zed-nano.dev',
  );
}
