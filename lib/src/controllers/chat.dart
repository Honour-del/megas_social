
// import 'package:collection/collection.dart' show IterableExtension;

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:megas/core/utils/constants/consts.dart';
import 'package:megas/core/utils/constants/exceptions.dart';
import 'package:megas/src/models/chat.dart';
import 'package:megas/src/services/auth/auths_impl.dart';

import '../services/chat/interface.dart';

final chatProvider =
StateNotifierProvider<ChatController, AsyncValue<List<Chat>>>(
        (ref) => ChatController(ref));

//final filterProvider = StateProvider((ref) => Filter.issued);


/////changes needs to be made to filter the categories accordingly

class ChatController extends StateNotifier<AsyncValue<List<Chat>>>{
  final Ref? _ref;
  final String? chatId;
  ChatController([this._ref,this.chatId]) : super(const AsyncValue.data([])) {
    getChatByUsersIds();
    // getChatByUsersIds(userId);
    // createBooking(bookings: bookings);
  }

  String? get  uid => _ref?.watch(authProviderK).value?.uid;

  Future<void> getMessages(chatId) async {
    try {
      final bookings = await _ref?.read(chatServiceProvider).getMessages(chatId);
      state = AsyncValue.data(bookings!);
    } on FirebaseException catch (e, _) {
      state = AsyncValue.error([e], _);
    }
  }

  Future<void> deleteMessage(String messageId) async {
    try {
      final deletes = await _ref?.read(chatServiceProvider).deleteMessage(messageId: messageId);
      return deletes;
    } on FirebaseException catch (e, _) {
      state = AsyncValue.error([e], _);
    }
  }

  Future<void> readChat(String chatId) async {
    try {
      final read = await _ref?.read(chatServiceProvider).readChat(chatId: chatId);
      return read;
    } on FirebaseException catch (e, _) {
      state = AsyncValue.error([e], _);
    }
  }


  Future<void> getChatByUsersIds() async {
    try {
      final bookings = await _ref?.read(chatServiceProvider).getChatByUsersIds(userId: uid);
      state = AsyncValue.data(bookings!);
    } on FirebaseException catch (e, _) {
      state = AsyncValue.error([e], _);
    }
  }

  Future<void> sendMessage({String? message, String? to,
    required String username,
    required Map<String, dynamic> sendMessageData,
    required ChatMessageTypes chatMessageTypes
  }) async {
    try {
      final messages = await _ref?.read(chatServiceProvider).sendMessage(chatId: username, sendMessageData: sendMessageData, chatMessageTypes: chatMessageTypes);
      // state = AsyncValue.data(bookings!);
      return messages;
    } on FirebaseException catch (e, _) {
      throw e.message!;
    }
  }
  Future<void> amountToScroll(ChatMessageTypes chatMessageTypes, BuildContext context,
      {String? actualMessageKey}
      ) async {
    try {
       _ref?.read(chatServiceProvider).amountToScroll(chatMessageTypes, context, actualMessageKey: actualMessageKey);
      // state = AsyncValue.data(bookings!);
      // return messages;
    } on FirebaseException catch (e, _) {
      throw e.message!;
    }
  }


  Future<void> loadPreviousStoredMessages( BuildContext context,{required String userName}) async {
    try {
      final messages = await _ref?.read(chatServiceProvider).loadPreviousStoredMessages(userName: userName, context);
      // state = AsyncValue.data(bookings!);
      return messages;
    } on FirebaseException catch (e, _) {
     throw e.message!;
    }
  }



  Future<void> storeAndShowIncomingMessageData({
    required String mediaFileLocalPath,
    String? userName,
    required ChatMessageTypes chatMessageTypes,
    required var mediaMessage
}) async {
    try {
      final messages = await _ref?.read(chatServiceProvider).storeAndShowIncomingMessageData(mediaFileLocalPath: mediaFileLocalPath,
          chatMessageTypes: chatMessageTypes, mediaMessage: mediaMessage, userName: userName);
      // state = AsyncValue.data(bookings!);
      return messages;
    } on FirebaseException catch (e, _) {
      throw e.message!;
    }
  }


  Future<void> manageIncomingTextMessages( BuildContext context,{var textMessage, required String userName}) async {
    try {
      final messages = await _ref?.read(chatServiceProvider).manageIncomingTextMessages(context, userName: userName);
      // state = AsyncValue.data(bookings!);
      return messages;
    } on FirebaseException catch (e, _) {
      throw e.message!;
    }
  }

  Future<void> manageIncomingMediaMessages( BuildContext context,{var mediaMessage, required ChatMessageTypes chatMessageTypes}) async {
    try {
      final messages = await _ref?.read(chatServiceProvider).
      manageIncomingMediaMessages(chatMessageTypes: chatMessageTypes, mediaMessage: mediaMessage, context);
      // state = AsyncValue.data(bookings!);
      return messages;
    } on FirebaseException catch (e, _) {
      throw e.message!;
    }
  }

  Future<void> manageIncomingLocationMessages({var locationMessage,
    required String userName,}) async {
    try {
      final messages = await _ref?.read(chatServiceProvider).manageIncomingLocationMessages(userName: userName,
          locationMessage);
      // state = AsyncValue.data(bookings!);
      return messages;
    } on FirebaseException catch (e, _) {
      throw e.message!;
    }
  }


  Future uploadMediaToStorage({required File file}) async {
    try {
      await _ref?.read(chatServiceProvider).uploadMediaToStorage(file: file);
      // state = AsyncValue.data(bookings!);
      // return messages;
    } on FirebaseException catch (e, _) {
      throw e.message!;
    }
  }


  Future uploadVideoToStorage({required File file}) async {
    try {
      await _ref?.read(chatServiceProvider).uploadVideoToStorage(file: file);
      // state = AsyncValue.data(bookings!);
      // return messages;
    } on FirebaseException catch (e, _) {
      throw e.message!;
    }
  }

  Future<void> makeDirectoryForRecordings() async {
    try {
      await _ref?.read(chatServiceProvider).makeDirectoryForRecordings();
      // state = AsyncValue.data(bookings!);
      // return messages;
    } on FirebaseException catch (e, _) {
      throw e.message!;
    }
  }


  Future<void> takePermissionForStorage() async {
    try {
      await _ref?.read(chatServiceProvider).takePermissionForStorage();
      // return messages;
    } on FirebaseException catch (e, _) {
      throw e.message!;
      // state = AsyncValue.error([e], _);
    }
  }
  Future<void> takeLocationInput(BuildContext context, userName) async {
    try {
      await _ref?.read(chatServiceProvider).takeLocationInput(context, userName);
      // return messages;
    } on FirebaseException catch (e, _) {
      throw e.message!;
      // state = AsyncValue.error([e], _);
    }
  }

  Future<void> addSelectedMediaToChat(
      String path, userName, BuildContext context,
      {ChatMessageTypes chatMessageTypeTake = ChatMessageTypes.Image,
        String thumbnailPath = ''}
      ) async {
    try {
       _ref?.read(chatServiceProvider).addSelectedMediaToChat(path, context, userName);
      // return messages;
    } on FirebaseException catch (e, _) {
      throw e.message!;
      // state = AsyncValue.error([e], _);
    }
  }
}
