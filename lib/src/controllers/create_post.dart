import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/posts/interface.dart';

final createPostProvider =
StateNotifierProvider<CreatePostController, dynamic>(
        (ref) => CreatePostController(ref: ref));


class CreatePostController extends StateNotifier{
  final Ref? ref;
  CreatePostController({
      required this.ref
  }) : super(null);

  // Posts without image
  Future<void> uploadTextPost({
    required String uid,
    required String caption,
    required String username,
    required String name,
    required String avatarUrl,
}) async{
    try {
      await ref?.read(createpostServiceProvider).uploadTextPost(uid: uid, caption: caption, username: username, name: name, avatarUrl: avatarUrl,);
    } on FirebaseException catch (e, _) {
      print(e.message);
      rethrow;
    }
  }


  Future<void> uploadPost({
    required String uid,
    required String caption,
    required String username,
    required File url,
    required String name,
    required String avatarUrl,
}) async {
    try {
      await ref?.read(createpostServiceProvider).uploadPost(uid: uid, caption: caption, url: url, username: username, name: name, avatarUrl: avatarUrl,);
    } on FirebaseException catch (e, _) {
      print(e.message);
      rethrow;
    }
  }

  Future<void> uploadImage({
    required File file
  }) async {
    try {
      await ref?.read(createpostServiceProvider).uploadImage(file: file);
    } on FirebaseException catch (e, _) {
      rethrow;
    }
  }
}
