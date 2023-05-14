

import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:megas/core/references/firestore.dart';
import 'package:megas/core/utils/constants/consts.dart';
import 'package:megas/core/utils/constants/uuid.dart';
import 'package:megas/main.dart';
import 'package:megas/src/models/chat.dart';
import 'package:megas/src/services/chat/interface.dart';
import 'package:megas/src/services/shared_prefernces.dart';
import 'package:megas/src/views/chat/chat_screen/chat_view.dart';


class ChatRepositoryImpl extends ChatDetailPageState  implements ChatRepository {
  // GetId _id = GetId();
  final Preferences prefs = Preferences();
  late Directory audioDirectory;
  final FToast _fToast = FToast();

  @override
  Future<void> deleteMessage({String? messageId}) async{
    // TODO: implement deleteMessage
    try{
      await messagesRefs.doc(messageId).delete();
    }catch(e){
      throw e;
    }
  }

  @override
  Future<List<Chat>> getChatByUsersIds({String? userId}) async{
    // TODO: implement getChatByUsersIds
    try{
      final res = await usersRef.doc(userId).collection('chats').get();
      Map<String, dynamic> map = {};
      List<Chat> results = [];
      print('declared chat model');
      // if(res.docs.isNotEmpty){
      res.docs.forEach((element) {
        map =  element.data();
        print('getting users chat list');
        final res = Chat.fromJson(map);
        // return res.map((e) => PostModel.fromJson(e)).toList();
        print('added result to model');
        return results.add(res);
      });
      print('done with users post');
      return results;
    }catch(e){
      throw e;
    }
  }

  @override
  Future getMessages(chatId) async{
    // TODO: implement getMessages
    try{
      return chatsRef.doc(chatId).collection('messages').snapshots();
    }catch(e){
      throw e;
    }
  }

  @override
  Future readChat({String? chatId}) async{
    // TODO: implement readChat
    try{

    }catch(e){
      throw e;
    }
  }

  //connectionUserName
  @override
  Future sendMessage({String? message, String? to, required String chatId, required Map<String, dynamic> sendMessageData, required ChatMessageTypes chatMessageTypes, uid}) async {
    // TODO: implement sendMessage
    try{
      Map<String, dynamic> toJson() {
        Map<String, dynamic> json = {};
        json['_id'] = uuid;
        json['chatId'] = chatId;
        json['message'] = message;
        json['from'] = uid;
        json['to'] = to;
        json['sendAt'] = DateTime.now();
        return json;
      }
      sendMessageData = toJson();
      await chatsRef.doc(chatId).collection('messages').add(sendMessageData);
      await chatsRef.doc(chatId).update({
        "lastMessage": sendMessageData['message'],
        "from": sendMessageData['from'],
        "lastMessageSendAt": sendMessageData['sendAt'],
      });
    }catch(e){
      throw e;
    }
  }

  @override
  takePermissionForStorage() {
    // TODO: implement takePermissionForStorage
    try{

    }catch(e){
      throw e;
    }
  }

  @override
  Future uploadMediaToStorage({required File file}) async{
    // TODO: implement uploadMediaToStorage
    try{

    }catch(e){
      throw e;
    }
  }

  @override
  Future uploadVideoToStorage({required File file}) async{
    // TODO: implement uploadVideoToStorage
    try{

    }catch(e){
      throw e;
    }
  }
}