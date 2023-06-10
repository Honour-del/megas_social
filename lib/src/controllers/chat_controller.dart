import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:megas/src/controllers/profile.dart';
import 'package:megas/src/models/chat_contact.dart';
import 'package:megas/src/models/message_f.dart';
import 'package:megas/src/services/auth/auths_impl.dart';
import 'package:megas/src/services/message_enum.dart';
import 'package:megas/src/services/message_reply_provider.dart';
import 'package:megas/src/services/notification/notification_impl.dart';

import '../services/chat/chat_repository.dart';

final chatControllerProvider = Provider((ref) {
  final chatRepository = ref.watch(chatRepositoryProvider);
  return ChatController(
    chatRepository: chatRepository,
    ref: ref,
  );
});

class ChatController {
  final ChatRepository chatRepository;
  final ProviderRef ref;
  ChatController({
    required this.chatRepository,
    required this.ref,
  });

  NotificationServiceImpl notify = NotificationServiceImpl();

  Stream<List<ChatContact>> chatContacts() {
    return chatRepository.getChatContacts();
  }


  Stream<List<Message>> chatStream(String recieverUserId) {
    return chatRepository.getChatStream(recieverUserId);
  }

  Stream<List<Message>> groupChatStream(String groupId) {
    return chatRepository.getGroupChatStream(groupId);
  }

  void deleteChat(
      recieverUserId
      ){
    chatRepository.deleteChat(recieverUserId);
  }

  void deleteMessage(
      messageId, recieverUserId
      ){
    chatRepository.deleteMessage(messageId, recieverUserId);
  }

  void sendTextMessage(
    BuildContext context,
    String text,
    String recieverUserId,
    bool isGroupChat,
  ) async{
    dynamic owner = await ref.read(getProfile(recieverUserId)).value?.fcm_token;
    dynamic current = await ref.read(userDetailProvider).value?.fcm_token;
    final messageReply = ref.read(messageReplyProvider);
    ref.read(userDetailProvider).whenData(
          (value) => chatRepository.sendTextMessage(
            context: context,
            text: text,
            recieverUserId: recieverUserId,
            senderUser: value!,
            messageReply: messageReply,
            isGroupChat: isGroupChat,
          ),
        );
    if(owner != null && owner != current){
      notify.sendFcmNotification(
        title: 'New message notification',
        body: "text",
        token: owner,
      );
      print('Fcm notification sent');
    }
    ref.read(messageReplyProvider.notifier).update((state) => null); // state
  }

  void sendFileMessage(
    BuildContext context,
    File file,
    String recieverUserId,
    MessageEnum messageEnum,
    bool isGroupChat,
  ) async{
    dynamic owner = await ref.read(getProfile(recieverUserId)).value?.fcm_token;
    dynamic current = await ref.read(userDetailProvider).value?.fcm_token;
    final messageReply = ref.read(messageReplyProvider);
    ref.read(userDetailProvider).whenData(
          (value) => chatRepository.sendFileMessage(
            context: context,
            file: file,
            recieverUserId: recieverUserId,
            senderUserData: value!,
            messageEnum: messageEnum,
            ref: ref,
            messageReply: messageReply,
            isGroupChat: isGroupChat,
          ),
        );
    if(owner != null && owner != current){
      notify.sendFcmNotification(
        title: 'New message notification',
        body: "File message",
        token: owner,
      );
      print('Fcm notification sent');
    }
    ref.read(messageReplyProvider.notifier).update((state) => null);
  }

  void sendGIFMessage(
    BuildContext context,
    String gifUrl,
    String recieverUserId,
    bool isGroupChat,
  ) async{
    dynamic owner = await ref.read(getProfile(recieverUserId)).value?.fcm_token;
    dynamic current = await ref.read(userDetailProvider).value?.fcm_token;
    final messageReply = ref.read(messageReplyProvider);
    int gifUrlPartIndex = gifUrl.lastIndexOf('-') + 1;
    String gifUrlPart = gifUrl.substring(gifUrlPartIndex);
    String newgifUrl = 'https://i.giphy.com/media/$gifUrlPart/200.gif';
    ref.read(userDetailProvider).whenData(
          (value) => chatRepository.sendGIFMessage(
            context: context,
            gifUrl: newgifUrl,
            recieverUserId: recieverUserId,
            senderUser: value!,
            messageReply: messageReply,
            isGroupChat: isGroupChat,
          ),
        );
    if(owner != null && owner != current){
      notify.sendFcmNotification(
        title: 'New message notification',
        body: "text",
        token: owner,
      );
      print('Fcm notification sent');
    }
    ref.read(messageReplyProvider.notifier).update((state) => null);
  }

  void setChatMessageSeen(
    BuildContext context,
    String recieverUserId,
    String messageId,
  ) {
    chatRepository.setChatMessageSeen(
      context,
      recieverUserId,
      messageId,
    );
  }
}
