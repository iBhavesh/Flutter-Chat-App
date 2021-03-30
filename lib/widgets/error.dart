import 'package:flutter/material.dart';

class Error extends StatelessWidget {
  final String errorMessage;
  Error([this.errorMessage = 'Oops! an error occured']);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Text(
          errorMessage,
          style: TextStyle(
            fontSize: 24,
          ),
        ),
      ),
    );
  }
}
