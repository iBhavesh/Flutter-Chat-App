import 'package:flutter/material.dart';

import '../theme/theme.dart';
import '../screens/loading_screen/loading_screen.dart';

class LoadingApp extends StatelessWidget {
  final String message;
  LoadingApp([this.message = 'loading...']);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Chat',
      theme: theme(context),
      // routes: routes,
      home: LoadingScreen(message),
    );
  }
}
