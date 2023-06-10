import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:megas/core/utils/constants/consts.dart';
import 'package:megas/core/utils/constants/uuid.dart';
import 'package:megas/main.dart';
import 'package:megas/src/controllers/profile.dart';
import 'package:megas/src/models/User.dart';
import 'package:megas/src/models/comments.dart';
import 'package:megas/src/services/comments/comment_interface.dart';
import 'package:megas/src/services/notification/interface.dart';
import 'package:megas/src/services/notification/notification_impl.dart';


final commentProvider =
StateNotifierProvider<CommentController, AsyncValue<List<CommentModel>>>(
        (ref) => CommentController(ref));


final getCommentProvider =
StreamProvider.family(
        (ref, String id) {
          return ref.watch(commentProvider.notifier).getComments(id);
        });

class CommentController extends StateNotifier<AsyncValue<List<CommentModel>>>{
  final Ref? _ref;
  // final String? postId;
  CommentController([this._ref]) : super(const AsyncValue.data([])) {
  }

  Future<void> addComment({
    // required String userId,
    required String postId,
    required String commenterUserId,
    required String comment,
    required String displayName,
    required String userName,
    required String photoUrl,
    postOwner
}) async {
    NotificationServiceImpl notify = NotificationServiceImpl();
    try {
      final notified = await _ref!.read(notificationServiceProviderK);
      UserModel? owner = await _ref!.watch(getProfile(postOwner)).value;
      UserModel? commenter = await _ref!.watch(getProfile(commenterUserId)).value;
      final comments = await _ref!.read(commentServiceProvider).addComment( postId: postId, commenterUserId: commenterUserId,
          comment: comment,
          type: cType.Text, displayName: displayName, userName: userName, photoUrl: photoUrl);
      print('About to send notification');
      /* Sending 'fcm' notification with the receiver token so that the notification will be received authorized user only */
      notify.sendFcmNotification(
        title: 'New comment notification',
        body: "${commenter!.name} comments on your post",
        token: owner!.fcm_token,
      );
      print('FCM notification sent');
      /* Adding notification to document so it can be displayed as list view inside the app */
      String notificationId = uuid.v1();
      Map<String, dynamic> toJson() {
        var data = <String, dynamic>{};
        data['notification_id'] = notificationId;
        data['body'] = handleNotification(TypeN.Follower, commenter.username);
        data['post_id'] = postId;
        data['_type'] = TypeN.Comments.toString();
        data['time_at'] = dateTime;
        data['isRead'] = false;
        data['name'] = commenter.username;
        data['avatar_url'] = commenter.avatarUrl;
        return data;
      }
      await notified.sendNotification(toJson: toJson(), userToReceiveNotificationId: postOwner);
      print('Normal notification sent');
      return comments;
    } on FirebaseException catch (e, _) {
      state = AsyncValue.error([e], _);
    }
  }

  type(){
    cType type = cType.Text;
    switch(type){
      case cType.Text:
        return cType.Text.toString();
        // break;
      case cType.Picture:
        return cType.Picture.toString();
      case cType.Video:
        return cType.Video.toString();
    }
  }

  Stream<List<CommentModel>> getComments(postId)  {
    try {
      final comments =
       _ref?.read(commentServiceProvider).getComments(postId: postId);
      return comments!;
    } on FirebaseException catch (e, _) {
      throw e.message!;
    }
  }

  Future<void> deleteComments({
    required String userId,
    required String commentId,
  }) async {
    try {
      await _ref?.read(commentServiceProvider).deleteComments(userId: userId, commentId: commentId);
    } on FirebaseException catch (e, _) {
      rethrow;
    }
  }
}
