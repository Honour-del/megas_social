
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:megas/src/models/notification.dart';
import 'package:megas/src/services/notification/notification_impl.dart';


enum TypeN {Likes, Comments, Follower}

final notificationServiceProviderK = Provider<NotificationService>((ref) {
  return NotificationService();
});

abstract class NotificationService {

  factory NotificationService()=> NotificationServiceImpl();

  Future<void> sendFcmNotification({String body, String title, token});

  Future<dynamic> sendNotification({
    Map<String, dynamic>? toJson,
    userToReceiveNotificationId,
    notificationId
  });




  Future<List<NotificationModel>> getNotifications();

  Future<bool> deleteNotifications(String userId, notificationId);
}