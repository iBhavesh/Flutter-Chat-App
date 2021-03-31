import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../signup_screen/signup_screen.dart';

class SigninScreen extends StatefulWidget {
  final String email;

  const SigninScreen(this.email, {Key? key}) : super(key: key);

  @override
  _SigninScreenState createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  String password = '';
  bool _isWaiting = false;
  final _auth = FirebaseAuth.instance;
  final _key = GlobalKey<FormFieldState>();

  void _trySubmit(BuildContext context) async {
    final isValid = _key.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (!isValid) return;
    setState(() {
      _isWaiting = true;
    });
    _key.currentState!.save();
    try {
      print('${widget.email},$password');
      await _auth.signInWithEmailAndPassword(
          email: widget.email, password: password);
    } on FirebaseAuthException catch (e) {
      final sm = ScaffoldMessenger.of(context);
      sm.hideCurrentSnackBar();
      sm.showSnackBar(SnackBar(
        content: Text(e.message!),
        duration: Duration(seconds: 2),
      ));
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign in'),
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 250,
                child: OutlinedButton(
                  child: Text(widget.email),
                  onPressed: null,
                ),
              ),
              Container(
                width: 250,
                child: TextFormField(
                  initialValue: !kReleaseMode ? '123456' : null,
                  key: _key,
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length < 6)
                      return 'Password should be atleast 6 characters long';
                  },
                  onSaved: (value) {
                    if (value != null && value.isNotEmpty) password = value;
                  },
                ),
              ),
              SizedBox(height: 10),
              if (_isWaiting) CircularProgressIndicator(),
              if (!_isWaiting)
                ElevatedButton(
                  onPressed: () {
                    _trySubmit(context);
                  },
                  child: Text(
                    'Sign in',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              SizedBox(height: 10),
              Text('or'),
              TextButton(
                child: Text(
                  'Signup instead',
                  style: TextStyle(fontSize: 16),
                ),
                onPressed: () {
                  _key.currentState!.save();
                  _key.currentState!.reset();

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          SignupScreen(widget.email, password),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
