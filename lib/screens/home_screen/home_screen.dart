import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Chat'),
      ),
      body: StreamBuilder(
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final document = (snapshot.data as QuerySnapshot).docs;
          return ListView.builder(
            reverse: true,
            itemCount: document.length,
            itemBuilder: (ctx, i) {
              return Container(
                padding: EdgeInsets.all(10.0),
                child: Text(document[i]['text']),
              );
            },
          );
        },
        stream: firestore
            .collection('Chats/gYNY7Qv2VrJMsZZIaiCq/messages')
            .snapshots(),
      ),
    );
  }
}
