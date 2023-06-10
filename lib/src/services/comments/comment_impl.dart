

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:megas/core/references/firestore.dart';
import 'package:megas/core/utils/constants/uuid.dart';
import 'package:megas/main.dart';
import 'package:megas/src/models/comments.dart';

import 'comment_interface.dart';

class CommentsRepoImpl implements CommentsRepo{
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
    await commentsRef.doc(commentId).set(toJson());
    await postsRef.doc(postId).update({
      'comments': FieldValue.arrayUnion([commenterUserId]),
      'commentCounts': FieldValue.increment(1)
    });
  }

  @override
  Future<bool> deleteComments({required String userId, required String commentId}) async{
    // TODO: implement deleteComments
    try{
      // if(userId != '' )
      await commentsRef.doc(commentId).delete();
    } catch (e) {
      throw e;
    }
    return true;
  }


  @override
  Stream<List<CommentModel>> getComments({postId}) {
    // TODO: implement getComments
    return commentsRef.where('post_id', isEqualTo: postId).orderBy('comment_created_at', descending: true).snapshots()
        .map((event) => event.docs.map((e) => CommentModel.fromJson(e.data())
    ).toList());
  }
}