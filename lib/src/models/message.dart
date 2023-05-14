
import 'package:megas/core/utils/constants/consts.dart';
import 'package:objectbox/objectbox.dart';
// import 'objectbox_message.g.dart';
import 'dart:convert';

// @Entity()
// @Sync()
class MessageM {

  // @Id()
  // int? localId;
  String? id;
  // String? userid;
  String? chatId;
  String? message;
  String? from;
  String? to;
  // @Property(type: PropertyType.date)
  DateTime? sendAt;
  bool? unreadByMe;

  MessageM({
    // this.localId = 0,
    this.id,
    this.chatId,
    this.message,
    this.from,
    this.to,
    this.sendAt,
    this.unreadByMe,
    // this.userid
  });

  MessageM.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    chatId = json['chatId'];
    // chatId = json['userid'];
    message = json['message'];
    from = json['from']['_id'];
    to = json['to']['_id'];
    unreadByMe = json['unreadByMe'] ?? true;
    sendAt = json['sendAt'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    // json['_id'] = id;
    json['chatId'] = chatId;
    json['message'] = message;
    json['from'] = from;
    json['to'] = to;
    json['sendAt'] = sendAt;
    return json;
  }

  MessageM.fromLocalDatabaseMap(Map<String, dynamic> json) {
    // localId = json['id_message'];
    id = json['_id'];
    chatId = json['chat_id'];
    message = json['message'];
    from = json['from_user'];
    to = json['to_user'];
    sendAt = json['send_at'];
    unreadByMe = json['unread_by_me'] == 1;
  }

  Map<String, dynamic> toLocalDatabaseMap() {
    Map<String, dynamic> map = {};
    map['_id'] = id;
    map['chat_id'] = chatId;
    map['message'] = message;
    map['from_user'] = from;
    map['to_user'] = to;
    map['send_at'] = sendAt;
    map['unread_by_me'] = unreadByMe ?? false;
    return map;
  }

  MessageM copyWith({
    int? localId,
    String? id,
    bool? unreadByMe,
  }) {
    return MessageM(
      // localId: localId ?? this.localId,
      id: id ?? this.id,
      chatId: this.chatId,
      message: this.message,
      from: this.from,
      to: this.to,
      sendAt: this.sendAt,
      unreadByMe: unreadByMe ?? this.unreadByMe,
    );
  }


  MessageM geFromJson(dynamic json){///Json
    Map<String, dynamic> data = jsonDecode(json);

    return MessageM.fromJson(data);
    //// use this to get json data
  }
}



// @Sync()
@Entity()
class LocalMessage {

  @Id()
  int? localId;
  String? userName;
  // String? userid;
  String? chatId;
  String? message;
  String? actualMessage;
  ChatMessageTypes? chatMessageTypes;
  @Property(type: PropertyType.date)
  DateTime? sendAt;
  String? messageDateLocal;
  MessageHolderType? messageHolderType;

  int? get messageTypes{
    _ensureStableEnumValues();
    return chatMessageTypes?.index;
  }

  set messageTypes(int? value){
    _ensureStableEnumValues();
    if(value == null){
      chatMessageTypes = null;
    }else{
      chatMessageTypes = ChatMessageTypes.values[value];

      chatMessageTypes = value >= 0 && value < ChatMessageTypes.values.length
      ? ChatMessageTypes.values[value] : ChatMessageTypes.Text;
    }
  }

  LocalMessage({
    this.localId = 0,
    this.userName,
    this.chatId,
    this.message,
    this.actualMessage,
    this.sendAt,
    this.chatMessageTypes,
    this.messageHolderType,
    this.messageDateLocal
    // this.userid
  });


  void _ensureStableEnumValues(){
    assert(ChatMessageTypes.Text.index == 1);
    assert(ChatMessageTypes.Image.index == 2);
    assert(ChatMessageTypes.Video.index == 3);
    assert(ChatMessageTypes.Document.index == 4);
    assert(ChatMessageTypes.Audio.index == 5);
    assert(ChatMessageTypes.Location.index == 6);
  }
}
