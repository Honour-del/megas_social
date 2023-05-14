import 'dart:convert';
import 'package:objectbox/objectbox.dart';
import 'package:flutter/cupertino.dart';
import 'package:megas/src/models/User.dart';
import 'package:megas/src/models/message.dart';
// import 'package:megas/objectbox.g.dart';
import 'package:flutter/material.dart';
// import 'objectbox_chat.g.dart';


// @Sync()
class Chat {
  int? id;
  // @Backlink()
  List<MessageM>? messages;
  UserModel? user;
  int? unreadMessages;
  String? lastMessage;
  // @Property(type: PropertyType.date)
  DateTime? lastMessageSendAt;

  Chat({
    @required this.id,
    @required this.user,
    this.messages = const [],
    this.unreadMessages,
    this.lastMessage,
    this.lastMessageSendAt,
  });

  Chat.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    messages = json['messages'];
    unreadMessages = json['unreadMessages'];
    lastMessage = json['lastMessage'];
    lastMessageSendAt = json['sendAt'];
    user = UserModel.fromJson(json['user']);
    messages = [];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['_id'] = id;
    json['messages'] = messages;
    json['lastMessage'] = lastMessage;
    json['lastMessageSendAt'] = lastMessageSendAt;
    json['unreadMessages'] = unreadMessages;
    return json;
  }

  Chat.fromLocalDatabaseMap(Map<String, dynamic> map) {
    id = map['_id'];
    // user = UserModel.fromLocalDatabaseMap({
    //   '_id': map['user_id'],
    //   'name': map['name'],
    //   'username': map['username'],
    // });
    messages = [];
    unreadMessages = map['unread_messages'];
    lastMessage = map['last_message'];
    lastMessageSendAt = map['last_message_send_at'];
  }

  Map<String, dynamic> toLocalDatabaseMap() {
    Map<String, dynamic> map = {};
    map['_id'] = id;
    // map['user_id'] = user.id;
    return map;
  }

  Future<Chat> formatChat() async {
    return this;
  }

  Chat geFromJson(dynamic json){///Json
    Map<String, dynamic> data = jsonDecode(json);

    return Chat.fromJson(data);
    //// use this to get json data
  }
}

@Entity()
class LocalChat {
  @Id()
  int? localId;
  int? id;
  // @Backlink()
  final messages = ToMany<LocalMessage?>();
  final user = ToOne<UserModel?>();
  int? unreadMessages;
  String? lastMessage;
  @Property(type: PropertyType.date)
  DateTime? lastMessageSendAt;

  LocalChat({
    this.localId =0,
    @required this.id,
    this.unreadMessages,
    this.lastMessage,
    this.lastMessageSendAt,
  });

}



// class ChatUsers{
//   String name;
//   String messageText;
//   String imageURL;
//   String time;
//   ChatUsers({required this.name,required this.messageText,required this.imageURL,required this.time});
// }


@Entity()
class ChatWallPaper{
  @Id()
  int? id;
  final String?  image;
  final int? chatId;

  ChatWallPaper({this.id=0, this.image, this.chatId});

  Map<String, dynamic> toMap(){
    return {
      "id" : id,
      "image" : image,
    };
  }
}

// LocalChat? yes;
// final me = yes.messages;