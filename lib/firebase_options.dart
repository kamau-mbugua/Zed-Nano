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

  // iOS configuration - placeholder until GoogleService-Info.plist values are available
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBJNKCAeWTN-h7hJq9ohuGzkEudPiP3CkA', // Using same API key as Android
    appId: '1:251853629051:ios:placeholder', // Will need to be updated
    messagingSenderId: '251853629051',
    projectId: 'zed-app-444bf',
    storageBucket: 'zed-app-444bf.firebasestorage.app',
    iosClientId: 'ios-client-id-needs-to-be-updated', // Will need to be updated
    iosBundleId: 'com.rbs.zednano',
  );
}
