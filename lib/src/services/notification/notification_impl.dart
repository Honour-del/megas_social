
import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:megas/core/references/firestore.dart';
import 'package:megas/core/utils/constants/size_config.dart';
import 'package:megas/src/models/notification.dart';
import 'package:megas/src/services/auth/auths_impl.dart';
import 'package:megas/src/services/notification/interface.dart';


final streamNotification = StreamProvider<List<NotificationModel>>((ref) {
  print('0');
  final uid = ref.watch(authProviderK).value?.uid;
  print('1');
  final notificationStream = usersRef.doc(uid).collection('notifications').orderBy('time_at', descending: false).snapshots()
      .map((query) => query.docs
      .map((doc) => NotificationModel.fromJson(doc.data())).toList());
  print('2');
  return notificationStream;
});


class NotificationServiceImpl implements NotificationService{
  final String url = 'https://fcm.googleapis.com/fcm/send';

  @override
  Future<void> sendFcmNotification({String? body, String? title, token}) async{
    final Dio dio = Dio();
    try{
      dio.options.headers['Content-Type'] = 'application/json';
      dio.options.headers['Authorization'] = 'key=$server_key';
      final data = {
        "to": token,
        "notification": {
          "title": title,
          "body": body,
        },
        // "to": token,
      };

      final headers = {
        'content-type': 'application/json',
        'Authorization': 'key=$server_key',
      };

      final response = await dio.post(
        url,
        data: json.encode(data),
        options: Options(headers: headers)
      );

      if(response.statusCode == 200)
         print("Response = ${response.statusMessage}");
    } on FirebaseException catch(e){
      throw e;
    }
  }


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
  Future sendNotification({Map<String, dynamic>? toJson, userToReceiveNotificationId, notificationId}) async{
    // TODO: implement sendNotification
    try{
      // notificationId = uuid.v1();
      print('about to send notification');
      // Map<String, dynamic>? toJson;
      await usersRef.doc(userToReceiveNotificationId).collection('notifications').doc(notificationId).set(toJson!);
      print('notification sent');
    }on FirebaseException catch(e){
      throw e;
    }
  }
}
