import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../screens/welcome_screen/welcome_screen.dart';
import '../screens/home_screen/home_screen.dart';
import '../routes.dart';
import '../theme/theme.dart';

class MainApp extends StatefulWidget {
  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Chat',
      theme: theme(context),
      // darkTheme: darkTheme(context),
      routes: routes,
      home: StreamBuilder(
        builder: (context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.hasData) {
            // SharedPreferences.getInstance()
            //     .then((prefs) {
            //       if (prefs.containsKey('username')) {
            //         FirebaseFirestore.instance
            //             .collection('users')
            //             .doc(auth.currentUser!.uid)
            //             .set({
            //           'username': prefs.getString('username')
            //         }).catchError((onError) {
            //           print(onError);
            //         });
            //       }
            //     })
            //     .then((value) => HomeScreen())
            //     .catchError((onError) {
            //       print(onError);
            //     });
            return HomeScreen();
          } else
            return WelcomeScreen();
        },
        stream: auth.authStateChanges(),
      ),
    );
  }
}
