import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as fst;

import '../../helpers.dart';
import './components/custom_picker.dart';

class SignupScreen extends StatefulWidget {
  final String email, password;

  const SignupScreen(this.email, this.password, {Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();

  bool _isWaiting = false;
  String _email = '';
  String _password = '';
  String _username = !kReleaseMode ? 'bhavesh' : '';
  File? _userImageFile;

  void _setPickedImage(File pickedImage) {
    _userImageFile = pickedImage;
  }

  void _signup(BuildContext context) async {
    final isValid = _formKey.currentState!.validate();
    String imageUrl = '';
    FocusScope.of(context).unfocus();
    if (!isValid) {
      return;
    }

    _formKey.currentState!.save();
    setState(() {
      _isWaiting = true;
    });
    try {
      final authResult = await _auth.createUserWithEmailAndPassword(
          email: _email, password: _password);
      if (_userImageFile != null) {
        await fst.FirebaseStorage.instance
            .ref('profile_pictures/${authResult.user!.uid}.jpg')
            .putFile(_userImageFile!);
        imageUrl = await fst.FirebaseStorage.instance
            .ref('profile_pictures/${authResult.user!.uid}.jpg')
            .getDownloadURL();
      }
      if (authResult.user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(authResult.user!.uid)
            .set({
          'username': _username,
          'email': _email,
          'pofile_pic': imageUrl,
          'createdAt': Timestamp.now()
        });
        Navigator.pop(context);
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      debugPrint(e.message);
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.message!),
        duration: Duration(seconds: 2),
        backgroundColor: Theme.of(context).primaryColor,
      ));
    } catch (e) {
      debugPrint(e.toString());
    }

    // setState(() {
    //   _isWaiting = false;
    // });
  }

  @override
  void initState() {
    super.initState();
    _email = widget.email;
    _passwordController.value = TextEditingValue(text: widget.password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              width: 250,
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomPicker(_setPickedImage),
                      TextFormField(
                        initialValue: _email,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          labelText: 'Email',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return 'Please enter an email address';
                          RegExp regex = new RegExp(pattern.toString());
                          if (!regex.hasMatch(value))
                            return 'Please enter a valid email address';
                        },
                        onSaved: (value) {
                          if (value != null) {
                            value.trim();
                            _email = value;
                          }
                        },
                      ),
                      TextFormField(
                        initialValue: _username,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          labelText: 'Username',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return 'Please enter username';
                          if (value.length < 5)
                            return 'username cannot be less than 5 characters';
                        },
                        onSaved: (value) {
                          if (value != null) {
                            value.trim();
                            _username = value;
                          }
                        },
                      ),
                      TextFormField(
                        // initialValue: widget.password,
                        controller: _passwordController,
                        obscureText: true,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(labelText: 'Password'),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.length < 6)
                            return 'Password should be atleast 6 characters long';
                        },
                        onSaved: (value) {
                          if (value != null && value.isNotEmpty) {
                            value.trim();
                            _password = value;
                          } else
                            _password = '';
                        },
                      ),
                      TextFormField(
                        initialValue:
                            !kReleaseMode ? _passwordController.text : null,
                        obscureText: true,
                        decoration:
                            InputDecoration(labelText: 'Confirm Password'),
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return 'Please enter password again to confirm';
                          if (_passwordController.value.text != value)
                            return 'Passwords do not match';
                        },
                      ),
                      if (!_isWaiting) SizedBox(height: 10),
                      if (_isWaiting) SizedBox(height: 22),
                      if (_isWaiting) CircularProgressIndicator(),
                      if (!_isWaiting)
                        ElevatedButton(
                          onPressed: () {
                            _signup(context);
                          },
                          child: Text(
                            'Sign up',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
