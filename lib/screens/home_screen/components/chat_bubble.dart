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
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          // width: 140,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isMe ? Colors.grey[300] : Theme.of(context).accentColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
              bottomRight: isMe ? Radius.circular(0) : Radius.circular(8),
              bottomLeft: isMe ? Radius.circular(8) : Radius.circular(0),
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
                    StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .where('email', isEqualTo: senderEmail)
                            .snapshots(),
                        builder: (context, snapshot) {
                          String username = 'loading...';
                          if (snapshot.hasData)
                            username = snapshot.data!.docs.first['username'];
                          return Text(
                            username,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isMe
                                  ? Colors.black
                                  : Theme.of(context)
                                      .accentTextTheme
                                      .headline6!
                                      .color,
                            ),
                          );
                        }),
                    Text(
                      message,
                      style: TextStyle(
                        color: isMe
                            ? Colors.black
                            : Theme.of(context)
                                .accentTextTheme
                                .headline6!
                                .color,
                        fontSize:
                            Theme.of(context).textTheme.subtitle1!.fontSize,
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
                          : Theme.of(context).accentTextTheme.headline6!.color,
                      fontSize: 10),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
