import 'package:flutter/material.dart';

import '../../../helpers.dart';
import '../../signin_screen/signin_screen.dart';

class Body extends StatefulWidget {
  const Body({
    Key? key,
  }) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  String email = 'dummy@email.com';
  final _key = GlobalKey<FormFieldState>();
  final _controller = TextEditingController();

  void _trySubmit(BuildContext context) {
    final isValid = _key.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (!isValid) return;
    _key.currentState!.save();
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SigninScreen(email)));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Spacer(
              flex: 1,
            ),
            Text(
              'Welcome to flutter chat',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: 250,
              child: TextFormField(
                key: _key,
                controller: _controller,
                decoration: InputDecoration(labelText: 'Email'),
                autocorrect: false,
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Please enter some text!';

                  RegExp regex = new RegExp(pattern.toString());
                  if (!regex.hasMatch(value))
                    return 'Please enter a valid email address';
                },
                onSaved: (value) {
                  email = value!;
                },
              ),
            ),
            SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: () {
                _trySubmit(context);
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Next'),
                  Icon(Icons.navigate_next_rounded),
                ],
              ),
            ),
            Spacer(
              flex: 2,
            ),
          ],
        ),
      ),
    );
  }
}
