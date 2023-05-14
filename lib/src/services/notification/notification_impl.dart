
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:megas/core/references/firestore.dart';
import 'package:megas/src/models/notification.dart';
import 'package:megas/src/services/notification/interface.dart';


final streamNotification = StreamProvider.autoDispose<List<NotificationModel>>((ref) {
  final notificationStream = notificationsRef.orderBy('time_at').snapshots()
      .map((query) => query.docs
      .map((doc) => NotificationModel.fromJson(doc.data())).toList());
  return notificationStream;
});


class NotificationServiceImpl implements NotificationService{

  /// the description on the notification
  String? handleNotification(Type? type, username) {
    switch (type) {
      case Type.Likes:
        message = '@$username likes your post';
        break;
      case Type.Comments:
        message = '@$username commented on your post';
        break;
      case Type.Follower:
        message = '@$username follows you';
        break;
      default:
        message = 'This notification is from @$username';
        break;
    }
    return null;
  }

  String? message;

  StreamController stream = StreamController();

  @override
  Future<bool> deleteNotifications(String userId, notificationId) async{
    // TODO: implement deleteNotifications
    try{
      await notificationsRef.doc(notificationId).delete();
      return true;
    } on FirebaseException catch(e){
      throw e;
    }
  }

  @override
  Future<List<NotificationModel>> getNotifications() async{
    // TODO: implement getNotifications
    try{
      print('getting notification from reference');
      final stream = notificationsRef.orderBy('time_at').snapshots();
      final List<NotificationModel> notificationList = [];
      print('iterating over notification to convert it to Map<String, dynamic>');
      await for (QuerySnapshot<Map<String, dynamic>> snapshot in stream){
        for(QueryDocumentSnapshot<Map<String, dynamic>> document in snapshot.docs){
          notificationList.add(
            NotificationModel.fromJson(document.data())
          );
          print('done with iteration');
        }
      }
      print('notification returned as Map<String, dynamic>');
      return notificationList;
    } catch(e){
      throw e;
    }

  }


  @override
  Future sendNotification({Map<String, dynamic>? toJson, userToReceiveNotificationId}) async{
    // TODO: implement sendNotification
    try{
      // NotificationModel
      // notificationId = uuid.v1();
      print('about to send notification');
      // Map<String, dynamic>? toJson;
      await usersRef.doc(userToReceiveNotificationId).collection('notifications').doc().set(toJson!);
      print('notification sent');
    }on FirebaseException catch(e){
      throw e;
    }
  }
}
