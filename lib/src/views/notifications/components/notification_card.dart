import 'package:flutter/material.dart';
import 'package:megas/src/models/notification.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationCard extends StatefulWidget {
  const NotificationCard({Key? key, required this.note}) : super(key: key);

  final NotificationModel note;
  @override
  State<NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  @override
  Widget build(BuildContext context) {
    final timeAgo = timeago.format(widget.note.timeAt.toDate());
    // final timeAgo = DateTime.fromMicrosecondsSinceEpoch(widget.note.timeAt as int);
    return GestureDetector(
      onTap: (){
        // push(context, ChatDetailPage(userName: '@alienwear',));
      },
      child: Container(
        padding: const EdgeInsets.only(left: 16,right: 16,top: 10,bottom: 10),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: NetworkImage(widget.note.avatarUrl),
                    maxRadius: 30,
                  ),
                  const SizedBox(width: 16,),
                  Expanded(
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(widget.note.name, style: const TextStyle(fontSize: 16),),
                          const SizedBox(height: 6,),
                          Text(widget.note.body,style: TextStyle(fontSize: 13,color: Colors.grey.shade600, fontWeight: widget.note.isRead?FontWeight.bold:FontWeight.normal),),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Text(timeAgo.toString(),style: TextStyle(fontSize: 12,fontWeight: widget.note.isRead?FontWeight.bold:FontWeight.normal),),
          ],
        ),
      ),
    );
  }
}
