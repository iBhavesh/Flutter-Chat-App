import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final Timestamp createdAt;
  final bool isMe;

  const ChatBubble(this.message, this.createdAt, this.isMe, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
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
              Text(
                message,
                style: TextStyle(
                  color: isMe
                      ? Colors.black
                      : Theme.of(context).accentTextTheme.headline6!.color,
                  fontSize: Theme.of(context).textTheme.headline6!.fontSize,
                ),
              ),
              SizedBox(width: 5),
              Container(
                child: Text(
                  '${createdAt.toDate().toLocal().hour}:${createdAt.toDate().toLocal().minute}',
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
