import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:megas/src/models/post.dart';
import 'package:megas/src/services/posts/posts_impl.dart';

final createpostServiceProvider = Provider((ref) {
  return CreatePost();
});

abstract class CreatePost {

  factory CreatePost()=> CreatePostImpl();

  // var uuid = const Uuid();
  /*
  All these class id's are commented out because
  the decision is to be made  by backend engineer if
  each class id's are to be generated on the backend
  or from the frontend!!!!!.

  Because if the id's are randomly generated from the backend
  i wont need to post id toJson it will/can only be returned fromJson
  */

  Future<void> uploadTextPost({
    required String uid,
    required String caption,
    required String username,
    required String name,
    required String avatarUrl,
});

  Future<void> uploadPost({
    required String uid,
    required String caption,
    required File url,
    required String username,
    required String name,
    required String avatarUrl,
    // required int width,
    // required int height,
  });


  Future<dynamic> uploadImage({required File file, directoryName, uid, fileName});

  Future<bool> deletePost({required String uId, required String postId});
}