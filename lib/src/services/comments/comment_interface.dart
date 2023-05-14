


// import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:megas/src/models/comments.dart';
import 'package:megas/src/services/comments/comment_impl.dart';


final commentServiceProvider = Provider<CommentsRepo>((ref) {
  // Client client = Client();
  return CommentsRepo();
});


/// [Comment type]
enum cType{Picture, Video, Text}
abstract class CommentsRepo {
  // final Dio? client;

  // CommentsRepo([this.client]);
factory CommentsRepo () => FakeCommentsRepo();

  /*
  All these class id's are commented out because
  the decision is to be made  by backend engineer if
  each class id's are to be generated on the backend
  or from the frontend!!!!!.

  Because if the id's are randomly generated from the backend
  i wont need to post id toJson it will/can only be returned fromJson
  */

  Future<void> addComment({
    required String postId,
    required String commenterUserId,
    required String comment,
    required cType type,
    required String displayName,
    required String userName,
    required String photoUrl,
  });

  Future<List<CommentModel>> getComments({postId});

  Future<bool> deleteComments({required String userId, required String commentId});
}

