import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:megas/src/models/User.dart';
import 'package:megas/src/models/post.dart';
import 'package:megas/src/services/auth/auths_impl.dart';
import 'package:megas/src/services/profile/interface.dart';

final profileControllerProvider = StateNotifierProvider.autoDispose.family<ProfileController, AsyncValue<UserModel>, String>((ref, id) {
  return ProfileController(ref, id);
});

final getUsersPostProvider = StreamProvider.family((ref, String uid) {
    return ref.read(profileControllerProvider(uid).notifier).getUsersPosts();
 });

// TODO: will change this provider to the that can pass
//  argument to seperate current user profile from another persons profile

class ProfileController extends StateNotifier<AsyncValue<UserModel>> {
  final Ref _read;
  final String? uid;
  ProfileController(this._read, this.uid) : super(const AsyncValue.loading()){
   getProfile();
  }
  // {getProfile();}


  ProfileService get profileServices => _read.read(profileServiceProvider);
  /* uidk = current user's id */
  String? get  uidk => _read.watch(authProviderK).value?.uid;

  Future<void> getProfile() async {
    try {
      print("UId here under get profile = $uid");
      final profile = await profileServices.getProfile(uid);
      print("UId here = $uid");
      state = AsyncValue.data(profile);
    } on FirebaseException catch (e, _) {
      state = AsyncValue.error(e,_);
    }
  }

  Future<bool?> uploadImage(File file,) async {
    try {
      final uploaded = await profileServices.uploadImage(file, uidk);
      return uploaded;
    } on FirebaseException {
      return false;
    }
  }

  Future<bool?> updateProfile({Map<String, dynamic>? json,}) async {
    try {
      final uploaded = await profileServices.updateProfile(json: json, uid: uidk);
      return uploaded;
    } on FirebaseException {
      return false;
    }
  }

  Stream<List<PostModel>> getUsersPosts(){
    try {
      final posts =  profileServices.getUserPosts(id: uid);
      return posts;
    } on FirebaseException catch (E) {
      return Stream.error(E);
    }
  }

  Future<bool?> follow () async {
    try {
      final follow = await profileServices.follow(uidk, uid);
      return follow;
    } on FirebaseException {
      return false;
    }
  }

  Future<bool?> unfollow () async {
    try {
      final follow = await profileServices.unfollow(uidk, uid);
      return follow;
    } on FirebaseException {
      return false;
    }
  }

//     Future<bool> deletePost({required String uid, required String postid}) async {
//       try {
//         await _ref?.read(createpostServiceProvider).deletePost(uId: uid, postId: postid,);
//         return true;
//         // state = AsyncValue.data(likes!);
//       } on FirebaseException catch (e, _) {
//         return false;
//         // state = AsyncValue.error([e], _);
//       }
//     }  }
}
