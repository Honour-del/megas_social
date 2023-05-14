
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:megas/src/models/notification.dart';
import 'package:megas/src/services/notification/notification_impl.dart';


enum Type {Likes, Comments, Follower}

final notificationServiceProviderK = Provider<NotificationService>((ref) {
  return NotificationService();
});

abstract class NotificationService {

  factory NotificationService()=> NotificationServiceImpl();

  Future<dynamic> sendNotification({
    Map<String, dynamic>? toJson,
    userToReceiveNotificationId,
    // required String body,
    // required String postId,String? notificationId, required Type type, username, avatarUrl, comment
  });




  Future<List<NotificationModel>> getNotifications();

  Future<bool> deleteNotifications(String userId, notificationId);
}