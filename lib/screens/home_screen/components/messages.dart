import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../widgets/error.dart';
import './chat_bubble.dart';

class Messages extends StatelessWidget {
  final firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.data != null) {
          final document = snapshot.data!.docs;
          if (document.length < 1)
            return Container(
                padding: const EdgeInsets.only(left: 8),
                alignment: Alignment.bottomLeft,
                child: Text(
                  'Start Texting...',
                  style: TextStyle(fontSize: 20),
                ));

          return ListView.builder(
            reverse: true,
            itemCount: document.length,
            itemBuilder: (ctx, i) {
              // final time = (document[i]['createdAt'] as Timestamp).toDate();
              // if (time.isAfter(
              //     DateTime(time.year, time.month, time.day, 23, 59, 59)))
              //     return Container()
              return Container(
                padding: EdgeInsets.all(10.0),
                child: ChatBubble(
                  document[i]['text'],
                  document[i]['createdAt'],
                  document[i]['senderEmail'] ==
                      FirebaseAuth.instance.currentUser!.email,
                  document[i]['senderEmail'],
                  key: Key(document[i].id),
                ),
              );
            },
          );
        } else {
          return Error();
        }
      },
      stream: firestore
          .collection('chats')
          .orderBy('createdAt', descending: true)
          .snapshots(),
    );
  }
}
