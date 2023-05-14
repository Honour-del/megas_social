// import 'package:collection/collection.dart' show IterableExtension;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:megas/core/utils/constants/exceptions.dart';
import 'package:megas/src/models/comments.dart';
// import 'package:megas/src/services/comments.dart';
import 'package:megas/src/services/comments/comment_interface.dart';


final commentProvider =
StateNotifierProvider.autoDispose.family<CommentController, AsyncValue<List<CommentModel>>, String>(
        (ref, id) => CommentController(ref, id));


class CommentController extends StateNotifier<AsyncValue<List<CommentModel>>>{
  final Ref? _ref;
  final String? postId;
  CommentController([this._ref, this.postId]) : super(const AsyncValue.data([])) {
    // getChatByUsersIds(userId);
    // createBooking(bookings: bookings);
    getComments();
  }

  Future<void> addComment({
    // required String userId,
    required String postId,
    required String commenterUserId,
    required String comment,
    required String displayName,
    required String userName,
    required String photoUrl,
}) async {
    try {

      final comments = await _ref?.read(commentServiceProvider).addComment( postId: postId, commenterUserId: commenterUserId,
          comment: comment,
          type: type(), displayName: displayName, userName: userName, photoUrl: photoUrl);
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

  Future<List<CommentModel>> getComments() async {
    try {
      final comments =
      await _ref?.read(commentServiceProvider).getComments(postId: postId);
      state = AsyncValue.data(comments!);
      return state.value!;
    } on FirebaseException catch (e, _) {
      throw e.message!;
    }
  }

  Future<void> deleteComments({
    required String userId,
    required String commentId,
  }) async {
    try {
      //final comments =
      // var data = CommentModel(commenterUserId: userId, commentId: commentId);
      await _ref?.read(commentServiceProvider).deleteComments(userId: userId, commentId: commentId);
      // return comments[];
    } on FirebaseException catch (e, _) {
      rethrow;
    }
  }
}
