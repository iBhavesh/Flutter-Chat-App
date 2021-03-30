import 'package:flutter/material.dart';

import '../theme/theme.dart';
import '../screens/error_screen/error_screen.dart';

class ErrorApp extends StatelessWidget {
  final String message;
  ErrorApp([this.message = 'Oops! An error occured.']);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Chat',
      theme: theme(context),
      home: ErrorScreen(message),
    );
  }
}
