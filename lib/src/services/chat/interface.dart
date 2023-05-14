// ignore_for_file: avoid_print
// this file contains every logic of the chat services
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:megas/core/utils/constants/consts.dart';
import 'package:megas/src/services/chat/chats_impl.dart';
import 'package:megas/src/views/chat/chat_screen/chat_view.dart';



final chatServiceProvider = Provider<ChatRepositoryImpl>((ref) {
  return ChatRepositoryImpl();
});

abstract class ChatRepository{


  factory ChatRepository() => ChatRepositoryImpl();

  Future<dynamic> getMessages(chatId);



  Future<dynamic> uploadMediaToStorage({required File file});


  Future<dynamic> uploadVideoToStorage({required File file});

  /// coming back to this
  Future<dynamic> sendMessage(
      {String? message, String? to,
        required String chatId,
        required Map<String, dynamic> sendMessageData,
        required ChatMessageTypes chatMessageTypes,
        uid
      }) ;

  Future<dynamic> getChatByUsersIds({String? userId});

  Future<dynamic> readChat({String? chatId});

  Future<void> deleteMessage({String? messageId});


  takePermissionForStorage();
}