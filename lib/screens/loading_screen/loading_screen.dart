import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  final String loadingMessage;
  LoadingScreen([this.loadingMessage = 'Loading...']);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              loadingMessage,
              style: TextStyle(fontSize: 24),
            )
          ],
        ),
      ),
    );
  }
}
