import 'package:flutter/material.dart';

import './screens/welcome_screen/welcome_screen.dart';
import './screens/home_screen/home_screen.dart';

final Map<String, WidgetBuilder> routes = {
  HomeScreen.routeName: (BuildContext context) => HomeScreen(),
  WelcomeScreen.routeName: (BuildContext context) => WelcomeScreen(),
};
