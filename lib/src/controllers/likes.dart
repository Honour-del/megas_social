

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:megas/src/models/post.dart';
import '../services/likes/interface.dart';


// var postID;
final likesProvider = StateNotifierProvider((ref) {
  return LikesController(ref);
});


final getLikesProvider = StreamProvider.family((ref, String id) {
  return ref.watch(likesProvider.notifier).getLikes(postid: id,);
});

class LikesController extends StateNotifier<AsyncValue>{
  final Ref? _ref;
  LikesController([this._ref,]) : super(const AsyncValue.loading()){}

  // String? get _token => _ref!.watch(userDetailProvider).value?.fcm_token;


  Stream<PostModel> getLikes({required String postid}) {
    try {
      return _ref!.read(likesUpdateServicesProvider).getLikes(postid: postid,);
    } on FirebaseException catch (e, _) {
      throw e;
    }
  }






  Future<bool?> likePost({required String postid, required String likerId, bool? liked, post_owner}) async {
    try {
      await _ref?.read(likesUpdateServicesProvider).likePost(postid: postid, likerid: likerId, liked: liked, post_owner: post_owner);
        return true;
    } on FirebaseException catch (e, _) {
      return false;
    }
  }
}


