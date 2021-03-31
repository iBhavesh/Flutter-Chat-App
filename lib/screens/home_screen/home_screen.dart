import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import './components/messages.dart';
import './components/new_message.dart';
import '../../widgets/custom_dialog.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = '/home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isWaiting = false;

  void _deleteAccount(BuildContext context) async {
    final theme = Theme.of(context);
    bool exists = false;

    final String? value = await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) => CustomDialog(theme: theme));
    if (value == null) return;
    setState(() {
      _isWaiting = true;
    });
    try {
      AuthCredential credential = EmailAuthProvider.credential(
          email: FirebaseAuth.instance.currentUser!.email!, password: value);
      await FirebaseAuth.instance.currentUser!
          .reauthenticateWithCredential(credential);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .delete();
      final uploadPath = FirebaseStorage.instance.ref(
          'profile_pictures/${FirebaseAuth.instance.currentUser!.uid}.jpg');
      try {
        await uploadPath.getDownloadURL();
        exists = true;
      } catch (e) {
        exists = false;
      }
      if (exists) await uploadPath.delete();
      await FirebaseAuth.instance.currentUser!.delete();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {}
    } catch (e) {
      debugPrint(e.toString());
    }
    setState(() {
      _isWaiting = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Chat'),
        actions: _buildActions(context),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isWaiting) return Center(child: CircularProgressIndicator());
    return Column(
      children: [
        Expanded(
          child: Messages(),
        ),
        NewMessage(),
      ],
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    return [
      PopupMenuButton(
        icon: Icon(
          Icons.more_vert,
          color: Theme.of(context).primaryIconTheme.color,
        ),
        itemBuilder: (context) => [
          PopupMenuItem(
            child: Container(
              child: Row(
                children: [
                  Icon(
                    Icons.exit_to_app,
                    color: Colors.black,
                  ),
                  SizedBox(width: 8),
                  Text('Logout'),
                ],
              ),
            ),
            value: 'logout',
          ),
          PopupMenuItem(
            child: Container(
              child: Row(
                children: [
                  Icon(
                    Icons.cancel,
                    color: Colors.red,
                  ),
                  SizedBox(width: 8),
                  Text('Delete Account'),
                ],
              ),
            ),
            value: 'delete_account',
          ),
        ],
        onSelected: (value) async {
          if (value == 'logout') {
            FirebaseAuth.instance.signOut();
          }
          if (value == 'delete_account') {
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (_) => AlertDialog(
                      title: Text('Delete Account'),
                      content: Text('Are you sure?'),
                      actions: [
                        TextButton(
                          child: Text('No'),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        TextButton(
                          child: Text('Yes'),
                          onPressed: () {
                            Navigator.pop(context);
                            _deleteAccount(context);
                          },
                        ),
                      ],
                    ));
          }
        },
      ),
    ];
  }
}
