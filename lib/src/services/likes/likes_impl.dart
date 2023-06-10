

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:megas/core/references/firestore.dart';
import 'package:megas/core/utils/constants/consts.dart';
import 'package:megas/core/utils/constants/uuid.dart';
import 'package:megas/main.dart';
import 'package:megas/src/controllers/profile.dart';
import 'package:megas/src/models/User.dart';
import 'package:megas/src/models/post.dart';
import 'package:megas/src/services/notification/interface.dart';
import 'package:megas/src/services/notification/notification_impl.dart';


class UpdateLikesImpl{
  Ref? _ref;
  UpdateLikesImpl(this._ref);
  NotificationServiceImpl notify = NotificationServiceImpl();

  // @override
  Future<void> likePost({required String postid, required String likerid, PostModel? postModel, bool? liked, post_owner_token, post_owner}) async{
    UserModel? liker = await _ref?.watch(getProfile(likerid)).value;
    UserModel? owner = await _ref?.watch(getProfile(post_owner)).value;
    final notified =  await _ref?.read(notificationServiceProviderK);
    final doc = await postsRef.doc(postid).get();
    if(doc.exists)
      print("The reference exists");
    if(liked!){
      postsRef.doc(postid).update({
        'likes': FieldValue.arrayUnion([likerid])
      });
      if(liker != null){
        if(owner != null){
          print('OwnerToken: ${owner.fcm_token}');
          notify.sendFcmNotification(
            title: 'New like notification',
            body: "${liker.name} liked your post",
            token: owner.fcm_token,
          );
          print('FCM: like notification sent');
          String notificationId = uuid.v1();
          Map<String, dynamic> toJson() {
            var data = <String, dynamic>{};
            data['notification_id'] = notificationId;
            data['body'] = handleNotification(TypeN.Likes, liker.username);
            data['post_id'] = postid;
            data['_type'] = TypeN.Likes.name;
            data['time_at'] = dateTime;
            data['isRead'] = false;
            data['name'] = liker.name;
            data['avatar_url'] = liker.avatarUrl;
            return data;
          }
          notified!.sendNotification(toJson: toJson(), userToReceiveNotificationId: owner.id, notificationId: notificationId);
          print('local notification sent');
        }
      } else{
        print('conditions are null');
      }
    }else{
      postsRef.doc(postid).update({
        'likes': FieldValue.arrayRemove([likerid])
      });
    }
  }



  // @override
  Stream<PostModel> getLikes({required String postid}){
    // TODO: implement addLike
    try{
      final postRef = postsRef.doc(postid);
      final likeRef = postRef.snapshots()
      .map((event) => PostModel.fromJson(event.data()));
      return likeRef;
      // PostModel _post = likeRef.first;
      // List<String> likes = [];
      // likes.add(likeRef)
    } catch (e){
      throw e;
    }
  }
}

