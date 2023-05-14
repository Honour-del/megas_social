

// import 'package:dio/src/dio.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:megas/core/references/firestore.dart';
import 'package:megas/core/utils/constants/uuid.dart';
import 'package:megas/main.dart';
import 'package:megas/src/models/comments.dart';
// import 'package:megas/src/services/shared_prefernces.dart';

import 'comment_interface.dart';

class FakeCommentsRepo implements CommentsRepo{
  // final Dio? client;
  // FakeCommentsRepo([this.client]);
  // GetId getId = GetId(); /* get saved currentUser id */
  // User? user = FirebaseAuth.instance.currentUser;
  @override
  Future<void> addComment({required String postId,
    required String commenterUserId,
    required String comment,
    required cType type,
    required String displayName,
    required String userName,
    required String photoUrl,
  }) async{
    // TODO: implement addComment
    final commentId = uuid.v1();
    Map<String, dynamic> toJson() {
      final _data = <String, dynamic>{};
      _data['commenter_user_id'] = commenterUserId;
      _data['post_id'] = postId;
      _data['comment'] = comment;
      _data['comment_created_at'] = dateTime;
      _data['comment_id'] = commentId;
      _data['username'] = userName;
      _data['name'] = displayName;
      _data['avatar_url'] = photoUrl;
      return _data;
    }
    await postsRef.doc(postId).collection('comments').doc(commentId).set(toJson());
    // commentsRef.doc(postId).set(toJson());
    // return comments;
  }

  @override
  Future<bool> deleteComments({required String userId, required String commentId}) async{
    // TODO: implement deleteComments
    try{
      // currentUid = _preferences.getToken() as String;
      if(userId != '' )
      await commentsRef.doc(commentId).delete();
    } catch (e) {
      throw e;
    }
    return true;
  }


  /* get all "Users" posts back from database */
  Stream<QuerySnapshot> getComment(postId) {
    // currentUid = _preferences.getToken() as String;
    // FirebaseAuth.instance.currentUser!.uid
    /* Return a stream of comments for the current post */
    return postsRef.doc(postId).collection('comments').orderBy('comment_created_at').snapshots();
  }
  @override
  Future<List<CommentModel>> getComments({postId}) async{
    // TODO: implement getComments
    try{
      dynamic data = await getComments(postId: postId);
      final result = CommentModel.fromJson(data) as List<CommentModel>;
      return result;
    } catch(e){
      throw e;
    }
  }

}