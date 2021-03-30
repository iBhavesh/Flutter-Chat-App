import 'package:flutter/material.dart';

import '../../widgets/error.dart';

class ErrorScreen extends StatelessWidget {
  final String errorMessage;
  ErrorScreen([this.errorMessage = 'Oops! an error occured']);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Error'),
      ),
      body: Error(errorMessage),
    );
  }
}
