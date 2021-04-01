import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ChatBubble extends StatelessWidget {
  final String message, senderEmail;
  final Timestamp createdAt;
  final bool isMe;

  const ChatBubble(this.message, this.createdAt, this.isMe, this.senderEmail,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final time = createdAt.toDate();
    // print(DateTime(time.year, time.month, time.day, 23, 59, 59).toString());
    final theme = Theme.of(context);
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: senderEmail)
            .snapshots(),
        builder: (context, snapshot) {
          String username = 'loading...';
          String imageUrl =
              'https://firebasestorage.googleapis.com/v0/b/flutter-chat-app-c6923.appspot.com/o/placeholder.jpg?alt=media&token=09e7f16d-2eef-4b41-8aed-dd5062b7a955';
          if (snapshot.hasData) {
            username = snapshot.data!.docs.first['username'];
            imageUrl = snapshot.data!.docs.first['profile_pic'];
            if (imageUrl.isEmpty)
              imageUrl =
                  'https://firebasestorage.googleapis.com/v0/b/flutter-chat-app-c6923.appspot.com/o/placeholder.jpg?alt=media&token=09e7f16d-2eef-4b41-8aed-dd5062b7a955';
            if (username.isEmpty) username = 'Not Available';
          }
          return Stack(
            clipBehavior: Clip.none,
            alignment: isMe ? Alignment.topRight : Alignment.topLeft,
            children: [
              Row(
                mainAxisAlignment:
                    isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 20),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isMe ? Colors.grey[300] : theme.accentColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                        bottomRight:
                            isMe ? Radius.circular(0) : Radius.circular(8),
                        bottomLeft:
                            isMe ? Radius.circular(8) : Radius.circular(0),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          constraints: BoxConstraints(maxWidth: 120),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 5, bottom: 5),
                                child: Text(
                                  username,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: isMe
                                        ? Colors.black
                                        : theme
                                            .accentTextTheme.headline6!.color,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              Text(
                                message,
                                style: TextStyle(
                                  color: isMe
                                      ? Colors.black
                                      : theme.accentTextTheme.headline6!.color,
                                  fontSize: theme.textTheme.subtitle1!.fontSize,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 5),
                        Container(
                          // width: 25,
                          child: Text(
                            '${DateFormat('Hm').format(createdAt.toDate())}',
                            style: TextStyle(
                                color: isMe
                                    ? Colors.black
                                    : theme.accentTextTheme.headline6!.color,
                                fontSize: 10),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                top: isMe ? -20 : -30,
                left: isMe ? null : -9,
                right: isMe ? -9 : null,
                child: CircleAvatar(
                  backgroundImage: NetworkImage(
                    imageUrl,
                  ),
                ),
              ),
            ],
          );
        });
  }
}
