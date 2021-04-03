import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'apps/error_app.dart';
import 'apps/loading_app.dart';
import 'apps/main_app.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (message.notification == null) return;

  print('Got a message whilst in the background!');
  print("Title: ${message.notification!.title}");
  print("Message: ${message.notification!.body}");
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
    if (kReleaseMode) exit(1);
  };

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return ErrorApp('Error while initialiazing firebase!');
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MainApp();
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return LoadingApp('Initializing firebase...');
      },
    );
  }
}
